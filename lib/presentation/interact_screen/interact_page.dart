import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:one2one_run/components/faq_helper.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/bloc.dart'
    as interact_bloc;
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_state.dart';
import 'package:one2one_run/presentation/interact_screen/tabs/active_tab.dart';
import 'package:one2one_run/presentation/interact_screen/tabs/finished_tab.dart';
import 'package:one2one_run/presentation/interact_screen/tabs/pending_tab.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:one2one_run/utils/extension.dart' show ToastExtension;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:one2one_run/utils/signal_r.dart';

//NOte:'/interact'
class InteractPage extends StatefulWidget {
  const InteractPage({
    Key? key,
    required this.onTapChange,
    required this.signalR,
    required this.drawerItems,
    required this.battleId,
  }) : super(key: key);

  final Function(String id, BattleRespondModel model) onTapChange;
  final SignalR signalR;
  final DrawerItems drawerItems;
  final String battleId;

  @override
  InteractPageState createState() => InteractPageState();
}

class InteractPageState extends State<InteractPage> {
  final InteractApi _interActApi = InteractApi();
  final HomeApi _homeApi = HomeApi();

  late Future<List<BattleRespondModel>?> getInteractTabsDataById;

  @override
  void initState() {
    super.initState();
    getInteractTabsDataById = _interActApi.getInteractTabsDataById(tabId: 0);

    showFAQHelperPage();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            MediaQuery.of(context).padding.bottom);
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<InteractBloc>(
      create: (final BuildContext context) => InteractBloc(),
      child: BlocListener<InteractBloc, InteractState>(
        listener:
            (final BuildContext context, final InteractState state) async {
          if (state is BattleIsAccepted) {
            if (state.isNegotiate) {
              await _interActApi
                  .battleAcceptConditions(id: state.id)
                  .then((int value) async {
                if (value == 200) {
                  await Fluttertoast.showToast(
                      msg: 'You have successfully accepted the battle!',
                      fontSize: 16.0,
                      textColor: Colors.green,
                      gravity: ToastGravity.CENTER);
                  getInteractTabsDataById =
                      _interActApi.getInteractTabsDataById(tabId: 0);
                } else {
                  if (value == 400) {
                    await Fluttertoast.showToast(
                        msg: 'Conditions must be accepted by your opponent!',
                        fontSize: 18.0,
                        textColor: Colors.white,
                        gravity: ToastGravity.CENTER);
                  } else {
                    await toastUnexpectedError();
                  }
                }
              });
            } else {
              await _homeApi
                  .acceptBattle(battleId: state.id)
                  .then((int value) async {
                if (value == 200) {
                  await Fluttertoast.showToast(
                      msg: 'You have successfully accepted the battle!',
                      fontSize: 16.0,
                      textColor: Colors.green,
                      gravity: ToastGravity.CENTER);
                  getInteractTabsDataById =
                      _interActApi.getInteractTabsDataById(tabId: 0);
                } else {
                  if (value == 403) {
                    await Fluttertoast.showToast(
                        msg: "Can't accept! Waiting for other participant",
                        fontSize: 18.0,
                        textColor: Colors.white,
                        gravity: ToastGravity.CENTER);
                  } else if (value == 400) {
                    await Fluttertoast.showToast(
                        msg: 'Conditions must be accepted by your opponent!',
                        fontSize: 18.0,
                        textColor: Colors.white,
                        gravity: ToastGravity.CENTER);
                  } else {
                    await toastUnexpectedError();
                  }
                }
              });
            }
          } else if (state is BattleIsDeclined) {
            await _homeApi
                .declineBattle(battleId: state.id)
                .then((bool value) async {
              if (value) {
                await Fluttertoast.showToast(
                    msg: 'You have successfully Declined the battle!',
                    fontSize: 16.0,
                    textColor: Colors.red,
                    gravity: ToastGravity.CENTER);
              } else {
                await toastUnexpectedError();
              }
            });
          } else if (state is ActivePageUpdated) {
            getInteractTabsDataById =
                _interActApi.getInteractTabsDataById(tabId: 0);
            print('onNeedToRefreshActivePage');
          }
          BlocProvider.of<InteractBloc>(context)
              .add(interact_bloc.UpdateState());
        },
        child: BlocBuilder<InteractBloc, InteractState>(
            builder: (final BuildContext context, final InteractState state) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: colorPrimary,
              appBar: TabBar(
                indicatorColor: Colors.red,
                tabs: <Widget>[
                  interactTab(title: 'Active'),
                  interactTab(title: 'Pending'),
                  interactTab(title: 'Finished'),
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  FutureBuilder<List<BattleRespondModel>?>(
                      future: getInteractTabsDataById,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BattleRespondModel>?> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return ActiveTab(
                            activeList: snapshot.data ?? <BattleRespondModel>[],
                            signalR: widget.signalR,
                            currentUserId:
                                PreferenceUtils.getCurrentUserModel().id,
                            onNeedToRefreshActivePage: () {
                              BlocProvider.of<InteractBloc>(context)
                                  .add(interact_bloc.UpdateActivePage());
                            },
                          );
                        }
                        return Container(
                          width: width,
                          height: height,
                          color: const Color(0xffF5F5F5),
                          child: Center(child: progressIndicator()),
                        );
                      }),
                  FutureBuilder<List<BattleRespondModel>?>(
                      future: _interActApi.getInteractTabsDataById(tabId: 1),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BattleRespondModel>?> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return PendingTab(
                            battleId: widget.battleId,
                            pendingList:
                                snapshot.data ?? <BattleRespondModel>[],
                            signalR: widget.signalR,
                            currentUserId:
                                PreferenceUtils.getCurrentUserModel().id,
                            onTapAccept: (String id, bool isNegotiate) {
                              BlocProvider.of<InteractBloc>(context).add(
                                  interact_bloc.AcceptBattle(
                                      id: id, isNegotiate: isNegotiate));
                            },
                            onTapChange: widget.onTapChange,
                            onTapDecline: (String id) {
                              BlocProvider.of<InteractBloc>(context)
                                  .add(interact_bloc.DeclineBattle(id: id));
                            },
                          );
                        }
                        return Container(
                          width: width,
                          height: height,
                          color: const Color(0xffF5F5F5),
                          child: Center(child: progressIndicator()),
                        );
                      }),
                  FutureBuilder<List<BattleRespondModel>?>(
                      future: _interActApi.getInteractTabsDataById(tabId: 2),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BattleRespondModel>?> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return FinishedTab(
                            finishedList:
                                snapshot.data ?? <BattleRespondModel>[],
                            signalR: widget.signalR,
                            currentUserId:
                                PreferenceUtils.getCurrentUserModel().id,
                          );
                        }
                        return Container(
                          width: width,
                          height: height,
                          color: const Color(0xffF5F5F5),
                          child: Center(child: progressIndicator()),
                        );
                      }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void showFAQHelperPage() {
    if (widget.drawerItems == DrawerItems.Interact &&
        !PreferenceUtils.getIsInteractFAQHelperShown()) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.push<dynamic>(context,
            MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          PreferenceUtils.setIsInteractFAQHelperShown(true);
          return const FAQHelperPage(
            faqHelperState: FAQHelperState.InteractState,
          );
        }));
      });
    }
  }

  @override
  void dispose() {
    widget.signalR.stopReceiveChatMessageData();
    super.dispose();
  }
}
