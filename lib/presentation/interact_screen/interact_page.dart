import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/apis/interact_api.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/bloc.dart'
    as interact_bloc;
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_state.dart';
import 'package:one2one_run/presentation/interact_screen/pending_tab.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:one2one_run/utils/extension.dart' show ToastExtension;

//NOte:'/interact'
class InteractPage extends StatefulWidget {
  InteractPage({Key? key, required this.onTapChange}) : super(key: key);

  final Function(String id, BattleRespondModel model) onTapChange;

  @override
  _InteractPageState createState() => _InteractPageState();
}

class _InteractPageState extends State<InteractPage> {
  final _interActApi = InteractApi();
  final _homeApi = HomeApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;

    return BlocProvider<InteractBloc>(
      create: (final context) => InteractBloc(),
      child: BlocListener<InteractBloc, InteractState>(
        listener: (final context, final state) async {
          if (state is BattleIsAccepted) {
            await _homeApi.acceptBattle(battleId: state.id).then((value) async {
              if (value) {
                await Fluttertoast.showToast(
                    msg: 'You have successfully accepted the battle!',
                    fontSize: 16.0,
                    textColor: Colors.green,
                    gravity: ToastGravity.CENTER);
              } else {
                await toastUnexpectedError();
              }
            });
          } else if (state is BattleIsDeclined) {
            await _homeApi
                .declineBattle(battleId: state.id)
                .then((value) async {
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
          }
          BlocProvider.of<InteractBloc>(context)
              .add(interact_bloc.UpdateState());
        },
        child: BlocBuilder<InteractBloc, InteractState>(
            builder: (final context, final state) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: colorPrimary,
              appBar: TabBar(
                indicatorColor: Colors.red,
                tabs: [
                  interactTab(title: 'Active'),
                  interactTab(title: 'Pending'),
                  interactTab(title: 'Finished'),
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xffF5F5F5),
                    child: const Center(
                      child: Text('Active Page'),
                    ),
                  ),
                  FutureBuilder<List<BattleRespondModel>?>(
                      future: _interActApi.getInteractTabsDataById(tabId: 1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return PendingTab(
                            pendingList: snapshot.data,
                            currentUserId:
                                PreferenceUtils.getCurrentUserModel().id,
                            onTapAccept: (id) {
                              BlocProvider.of<InteractBloc>(context)
                                  .add(interact_bloc.AcceptBattle(id: id));
                            },
                            onTapChange: widget.onTapChange,
                            onTapDecline: (id) {
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
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xffF5F5F5),
                    child: const Center(
                      child: Text('Finished Page'),
                    ),
                  ),
                ],
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
