import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_completed_detail_page/finished_completed_detail_bloc/bloc.dart'
    as finished_completed_detail_bloc;
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_completed_detail_page/finished_completed_detail_bloc/finished_completed_detail_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_completed_detail_page/finished_completed_detail_bloc/finished_completed_detail_state.dart';
import 'package:one2one_run/resources/app_string_res.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/data_values.dart';
import 'package:one2one_run/utils/extension.dart' show UserData, ToastExtension;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:one2one_run/utils/signal_r.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

//NOte:'/finishedCompletedDetail'
class FinishedCompletedDetailPage extends StatefulWidget {
  const FinishedCompletedDetailPage({
    Key? key,
    required this.finishedModel,
    required this.currentUserId,
    required this.signalR,
  }) : super(key: key);

  final BattleRespondModel finishedModel;
  final String currentUserId;
  final SignalR signalR;

  @override
  FinishedCompletedDetailPageState createState() =>
      FinishedCompletedDetailPageState();
}

class FinishedCompletedDetailPageState
    extends State<FinishedCompletedDetailPage> {
  final TextEditingController _chatController = TextEditingController();

  List<Messages> _messages = <Messages>[];

  final InteractApi _interactApi = InteractApi();

  late UserModel _currentUserModel;
  late BattleUsers _opponentBattleModel;
  late BattleUsers _myBattleModel;
  late ApplicationUser _opponentAppUserModel;

  String _messageText = '';

  final FinishedCompletedDetailBloc _finishedCompletedDetailBloc =
      FinishedCompletedDetailBloc();

  @override
  void initState() {
    super.initState();
    _currentUserModel = PreferenceUtils.getCurrentUserModel();

    _myBattleModel = getMyBattleModel(
        model: widget.finishedModel, currentUserId: widget.currentUserId);
    _opponentBattleModel = getOpponentBattleModel(
        model: widget.finishedModel, currentUserId: widget.currentUserId);
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
            return BlocProvider<FinishedCompletedDetailBloc>(
                create: (final BuildContext context) =>
                    _finishedCompletedDetailBloc,
                child: BlocListener<FinishedCompletedDetailBloc,
                        FinishedCompletedDetailState>(
                    listener: (final BuildContext context,
                        final FinishedCompletedDetailState state) async {
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
                      id: widget.finishedModel.id,
                    );
                  } else if (state is ChatMessageGot) {
                    _messages.add(state.messageModel);
                  } else if (state is ImageBattleIsShared) {
                    await _interactApi
                        .getImageBattleShare(id: widget.finishedModel.id)
                        .then((Uint8List? imageUrl) async {
                      if (imageUrl != null) {
                        final Directory? dir =
                            await getExternalStorageDirectory();
                        final String myImagePath = '${dir!.path}/tempimg.png';
                        final File imageFile = File(myImagePath);
                        if (!imageFile.existsSync()) {
                          imageFile.create(recursive: true);
                        }
                        imageFile.writeAsBytes(imageUrl);
                        Share.shareFiles(<String>[(imageFile.path)],
                            subject: 'One2One.run\nBattle of Supermen!\n');
                      } else {
                        toastUnexpectedError();
                      }
                    });
                  }
                  if (!_finishedCompletedDetailBloc.isClosed) {
                    BlocProvider.of<FinishedCompletedDetailBloc>(context)
                        .add(finished_completed_detail_bloc.UpdateState());
                  }
                }, child: BlocBuilder<FinishedCompletedDetailBloc,
                        FinishedCompletedDetailState>(
                  builder: (final BuildContext context,
                      final FinishedCompletedDetailState state) {
                    receiveChatMessage(context: context);

                    return Scaffold(
                      backgroundColor: homeBackground,
                      appBar: AppBar(
                        shadowColor: Colors.transparent,
                        actions: appBarButtons(
                          isNeedSecondButton: false,
                          firstButtonIcon: const Icon(Icons.share_rounded),
                          onTapFirstButton: () async {
                            BlocProvider.of<FinishedCompletedDetailBloc>(
                                    context)
                                .add(finished_completed_detail_bloc
                                    .ShareImageBattle());
                          },
                        ),
                        title: Text(
                          widget.finishedModel.battleName ?? AppStringRes.battle,
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
    return finishedBattleDetailsCard(
      model: widget.finishedModel,
      width: width,
      height: height,
      context: context,
      resultMyApprovalState: getResultApprovalState(
          resultIsConfirmed: _myBattleModel.resultIsConfirmed,
          resultIsRejected: _myBattleModel.resultIsRejected),
      resultOpponentApprovalState: getResultApprovalState(
          resultIsConfirmed: _opponentBattleModel.resultIsConfirmed,
          resultIsRejected: _opponentBattleModel.resultIsRejected),
      finishedTime: widget.finishedModel.finishTime != null
          ? getDateWithOutTime(date: widget.finishedModel.finishTime!)
          : '--:--',
      opponentProofPhotos: _opponentBattleModel.photos.cast<String>(),
      opponentProofTime: getTimeWithOutDate(time: _opponentBattleModel.time),
      myProofTime: getMyProofTime(
        model: widget.finishedModel,
        currentUserId: widget.currentUserId,
      ),
      myProofsPhoto: getMyProofPhotos(
        model: widget.finishedModel,
        currentUserId: widget.currentUserId,
      ).cast<String>(),
      currentUserModel: _currentUserModel,
      messages: _messages.reversed.toList(),
      chatController: _chatController,
      onMessageSend: () {
        _messageText = _chatController.text;
        _chatController.clear();
        BlocProvider.of<FinishedCompletedDetailBloc>(context)
            .add(finished_completed_detail_bloc.SendMessageChat());
      },
      onTapProofImage: (List<String> photos) {
        BlocProvider.of<FinishedCompletedDetailBloc>(context).add(
            finished_completed_detail_bloc.OpenImageZoomDialog(photos: photos));
      },
      distance: distance(distance: widget.finishedModel.distance),
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
        onReceiveChatMessage: (List<Object> arguments) {
      final Messages? model = getChatMessageData(arguments: arguments);
      if (model != null && !_finishedCompletedDetailBloc.isClosed) {
        BlocProvider.of<FinishedCompletedDetailBloc>(context).add(
            finished_completed_detail_bloc.GetChatMessage(messageModel: model));
      }
    });
  }

  Map<String, dynamic> getResultApprovalState(
      {required bool resultIsConfirmed, required bool resultIsRejected}) {
    if (resultIsConfirmed && !resultIsRejected) {
      return DataValues.resultImagesApprovalState;
    }
    if (!resultIsConfirmed && resultIsRejected) {
      return DataValues.resultImagesRejectedState;
    }

    return DataValues.resultImagesPendingState;
  }

  @override
  void dispose() {
    _finishedCompletedDetailBloc.close();
    _chatController.dispose();
    super.dispose();
  }
}
