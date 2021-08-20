import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/bloc.dart'
    as enjoy_bloc;
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/enjoy_bloc.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/enjoy_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;

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

  List<Messages> messages = <Messages>[];

  final InteractApi _interactApi = InteractApi();

  @override
  void initState() {
    super.initState();

    getOpponentMessages();
  }

  // TODO(Issa): complete
  Future<void> getOpponentMessages() async {
    await _interactApi
        .getOpponentChatMessages(
            opponentId: getOpponentId(
                model: widget.activeModel, currentUserId: widget.currentUserId))
        .then((OpponentChatModel? value) {

          if(value!=null){
            messages = value.messages.cast<Messages>();
          }else{

          }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<EnjoyBloc>(
      create: (final BuildContext context) => EnjoyBloc(),
      child: BlocListener<EnjoyBloc, EnjoyState>(
        listener: (final BuildContext context, final EnjoyState state) async {
          if (state is StateUpdated) {}
          BlocProvider.of<EnjoyBloc>(context).add(enjoy_bloc.UpdateState());
        },
        child: BlocBuilder<EnjoyBloc, EnjoyState>(
            builder: (final BuildContext context, final EnjoyState state) {
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
            body: SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.04, top: height * 0.04),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Chat',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    //NOTE:Chat
                    Container(
                      height: height * 0.5,
                      width: width,
                      padding: EdgeInsets.all(width * 0.035),
                      margin: EdgeInsets.symmetric(
                        horizontal: width * 0.025,
                        vertical: height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        //  mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.371,
                            width: width,
                            child: messages.isNotEmpty
                                ? Column(
                                    children: <Widget>[],
                                  )
                                : Center(
                                    child: Image.asset(
                                      startChatImage,
                                      height: height * 0.13,
                                      width: height * 0.2,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                          const Divider(
                            height: 5,
                            endIndent: 1.0,
                            indent: 1.0,
                          ),
                          inputTextChatField(
                              controller: _chatController,
                              height: height,
                              width: width,
                              messages: <String>[],
                              onSend: () {})
                        ],
                      ),
                    ),
                    //NOTE:Chat
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
