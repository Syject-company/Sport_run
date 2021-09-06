import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/pending_detail_page/pending_detail_bloc/bloc.dart'
    as pending_detail_bloc;
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/pending_detail_page/pending_detail_bloc/pending_detail_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/pending_detail_page/pending_detail_bloc/pending_detail_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:one2one_run/utils/signal_r.dart';

//NOte:'/pendingDetail'
class PendingDetailPage extends StatefulWidget {
  const PendingDetailPage({
    Key? key,
    required this.pendingModel,
    required this.currentUserId,
    required this.signalR,
  }) : super(key: key);

  final BattleRespondModel pendingModel;
  final String currentUserId;
  final SignalR signalR;

  @override
  _PendingDetailPageState createState() => _PendingDetailPageState();
}

class _PendingDetailPageState extends State<PendingDetailPage> {
  final TextEditingController _chatController = TextEditingController();

  List<Messages> _messages = <Messages>[];

  final InteractApi _interactApi = InteractApi();

  late UserModel _currentUserModel;
  late BattleUsers _opponentBattleModel;
  late ApplicationUser _opponentAppUserModel;

  String _messageText = '';

  final PendingDetailBloc _pendingDetailBloc = PendingDetailBloc();

  @override
  void initState() {
    super.initState();
    _currentUserModel = PreferenceUtils.getCurrentUserModel();
    _opponentBattleModel = getOpponentBattleModel(
        model: widget.pendingModel, currentUserId: widget.currentUserId);
    _opponentAppUserModel = _opponentBattleModel.applicationUser;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<OpponentChatModel?>(
        future: _interactApi.getOpponentChatMessages(
            opponentId: _opponentAppUserModel.id),
        builder:
            (BuildContext context, AsyncSnapshot<OpponentChatModel?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _messages = snapshot.data!.messages.cast<Messages>();
            return BlocProvider<PendingDetailBloc>(
                create: (final BuildContext context) => _pendingDetailBloc,
                child: BlocListener<PendingDetailBloc, PendingDetailState>(
                    listener: (final BuildContext context,
                        final PendingDetailState state) async {
                  if (state is ImageZoomDialogIsOpened) {
                    dialogImageZoom(
                      context: context,
                      height: height,
                      width: width,
                      photos: state.photos,
                    );
                  } else if (state is MessageChatSent) {
                    await sendMessage(
                      message: _messageText,
                      id: widget.pendingModel.id,
                    );
                  } else if (state is ChatMessageGot) {
                    _messages.add(state.messageModel);
                  }

                  if (!_pendingDetailBloc.isClosed) {
                    BlocProvider.of<PendingDetailBloc>(context)
                        .add(pending_detail_bloc.UpdateState());
                  }
                }, child: BlocBuilder<PendingDetailBloc, PendingDetailState>(
                  builder: (final BuildContext context,
                      final PendingDetailState state) {
                    receiveChatMessage(context: context);

                    return Scaffold(
                      backgroundColor: homeBackground,
                      appBar: AppBar(
                        shadowColor: Colors.transparent,
                        title: Text(
                          widget.pendingModel.battleName ?? 'Battle',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'roboto',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: colorPrimary,
                      ),
                      body: detailsCard(
                          width: width, height: height, context: context),
                    );
                  },
                )));
          }
          return Container(
            width: width,
            height: height,
            color: const Color(0xffF5F5F5),
            child: Center(child: progressIndicator()),
          );
        });
  }

  Widget detailsCard(
      {required BuildContext context,
      required double width,
      required double height}) {
    return pendingFinishedBattleDetailsCard(
      model: widget.pendingModel,
      width: width,
      height: height,
      context: context,
      currentUserModel: _currentUserModel,
      messages: _messages.reversed.toList(),
      chatController: _chatController,
      onMessageSend: () {
        _messageText = _chatController.text;
        _chatController.clear();
        BlocProvider.of<PendingDetailBloc>(context)
            .add(pending_detail_bloc.SendMessageChat());
      },
      onTapProofImage: (List<String> photos) {
        BlocProvider.of<PendingDetailBloc>(context)
            .add(pending_detail_bloc.OpenImageZoomDialog(photos: photos));
      },
      distance: distance(distance: widget.pendingModel.distance),
      opponentName: _opponentAppUserModel.nickName,
      opponentPhoto: _opponentAppUserModel.photoLink,
    );
  }

  Future<void> sendMessage(
      {required String message, required String id}) async {
    await widget.signalR.sendChatMessage(message: message, id: id);
  }

  Future<void> receiveChatMessage({required BuildContext context}) async {
    await widget.signalR.receiveChatMessage(
        tab: InteractPageTab.PendingTab,
        onReceiveChatMessage: (List<Object> arguments) {
          final Object data = arguments[0];
          if (data != null) {
            final Map<dynamic, dynamic> dataMessage =
                data as Map<dynamic, dynamic>;
            final Messages model =
                Messages.fromJson(dataMessage as Map<String, dynamic>);
            if (model != null &&
                widget.signalR.interactPageTab == InteractPageTab.PendingTab &&
                !_pendingDetailBloc.isClosed) {
              BlocProvider.of<PendingDetailBloc>(context)
                  .add(pending_detail_bloc.GetChatMessage(messageModel: model));
            }
          }
        });
  }

  @override
  void dispose() {
    _pendingDetailBloc.close();
    _chatController.dispose();
    super.dispose();
  }
}
