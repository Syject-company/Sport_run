import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/accepted_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/bloc.dart'
    as accepted_bloc;

import 'package:one2one_run/presentation/interact_screen/battle_state_cards/accepted_page/accepted_bloc/accepted_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/accepted'
class AcceptedPage extends StatefulWidget {
  const AcceptedPage({
    Key? key,
    required this.activeModel,
    required this.currentUserId,
  }) : super(key: key);

  final BattleRespondModel activeModel;
  final String currentUserId;

  @override
  _AcceptedPageState createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  final TextEditingController _chatController = TextEditingController();
  final RoundedLoadingButtonController _uploadResultsController =
      RoundedLoadingButtonController();

  List<Messages> messages = <Messages>[];

  final InteractApi _interactApi = InteractApi();

  late UserModel _currentUserModel;

  @override
  void initState() {
    super.initState();
    _currentUserModel = PreferenceUtils.getCurrentUserModel();
    getOpponentMessages();
  }

  // TODO(Issa): complete get Message 'Put it in Widget build(BuildContext context) FutureBuilder above BlocProvider'
  Future<void> getOpponentMessages() async {
    await _interactApi
        .getOpponentChatMessages(
            opponentId: getOpponentId(
                model: widget.activeModel, currentUserId: widget.currentUserId))
        .then((OpponentChatModel? value) {
      if (value != null) {
        messages = value.messages.cast<Messages>();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<AcceptedBloc>(
      create: (final BuildContext context) => AcceptedBloc(),
      child: BlocListener<AcceptedBloc, AcceptedState>(
        listener:
            (final BuildContext context, final AcceptedState state) async {
          if (state is ResultBattleUploaded) {
            _uploadResultsController.reset();
            // TODO Complete work here
            uploadResultsDialog(
                context: context,
                width: width,
                height: height,
                time: '10:00',
                onTimePressed: (){

                },
                onAddPressed: () async {
                });
          }
          BlocProvider.of<AcceptedBloc>(context)
              .add(accepted_bloc.UpdateState());
        },
        child: BlocBuilder<AcceptedBloc, AcceptedState>(
            builder: (final BuildContext context, final AcceptedState state) {
          return Scaffold(
            backgroundColor: homeBackground,
            appBar: AppBar(
              shadowColor: Colors.transparent,
              title: Text(
                widget.activeModel.battleName ?? 'Battle',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              backgroundColor: colorPrimary,
            ),
            body: battleDetailsCard(
              model: widget.activeModel,
              width: width,
              height: height,
              context: context,
              currentUserModel: _currentUserModel,
              messages: messages,
              chatController: _chatController,
              uploadResultsController: _uploadResultsController,
              onTapUploadResults: (String battleId) {
                BlocProvider.of<AcceptedBloc>(context)
                    .add(accepted_bloc.UploadResultBattle(id: battleId));
              },
              distance: distance(distance: widget.activeModel.distance),
              opponentName: getOpponentName(
                model: widget.activeModel,
                currentUserId: widget.currentUserId,
              ),
              opponentPhoto: getOpponentPhoto(
                model: widget.activeModel,
                currentUserId: widget.currentUserId,
              ),
              myProofTime: getMyProofTime(
                model: widget.activeModel,
                currentUserId: widget.currentUserId,
              ),
              myProofPhotos: getMyProofPhotos(
                model: widget.activeModel,
                currentUserId: widget.currentUserId,
              ).cast<String>(),
              opponentProofTime: getOpponentProofTime(
                model: widget.activeModel,
                currentUserId: widget.currentUserId,
              ),
              opponentProofPhotos: getOpponentProofPhotos(
                model: widget.activeModel,
                currentUserId: widget.currentUserId,
              ).cast<String>(),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }
}
