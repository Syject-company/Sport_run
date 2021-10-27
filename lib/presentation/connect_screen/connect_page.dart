import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/bloc.dart'
    as connect_bloc;
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_bloc.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_state.dart';
import 'package:one2one_run/presentation/connect_screen/user_info.dart';
import 'package:one2one_run/resources/app_string_res.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/extension.dart' show DateTimeExtension;

//NOte:'/connect'
class ConnectPage extends StatefulWidget {
  const ConnectPage(
      {Key? key,
      required this.users,
      required this.onBattleTap,
      required this.isNeedToShowSearchBar})
      : super(key: key);

  final List<ConnectUsersModel> users;
  final Function(ConnectUsersModel userModel) onBattleTap;
  final bool isNeedToShowSearchBar;

  @override
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage> {
  final TextEditingController _searchController = TextEditingController();

  List<ConnectUsersModel> usersConnect = <ConnectUsersModel>[];

  @override
  void initState() {
    super.initState();

    usersConnect.addAll(widget.users);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            MediaQuery.of(context).padding.bottom);
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<ConnectBloc>(
      create: (final BuildContext context) => ConnectBloc(),
      child: BlocListener<ConnectBloc, ConnectState>(
        listener: (final BuildContext context, final ConnectState state) async {
          if (state is NavigatedToUserInfo) {
            await Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (_) => UserInfo(
                  userModel: state.userModel,
                  onBattleTap: (ConnectUsersModel userModel) {
                    Navigator.of(context).pop();
                    widget.onBattleTap(
                      userModel,
                    );
                  },
                ),
              ),
            );
          } else if (state is SearchTheValueIsStarted) {
            usersConnect.addAll(widget.users.where((ConnectUsersModel element) {
              return element.nickName
                  .toString()
                  .toLowerCase()
                  .contains(state.value);
            }));
          } else if (state is SearchTheValueIsCleared) {
            usersConnect.addAll(widget.users);
          }
          BlocProvider.of<ConnectBloc>(context).add(connect_bloc.UpdateState());
        },
        child: BlocBuilder<ConnectBloc, ConnectState>(
            builder: (final BuildContext context, final ConnectState state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: widget.isNeedToShowSearchBar,
                    child: Container(
                      height: height * 0.06,
                      width: width,
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.025, vertical: height * 0.01),
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
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: height * 0.05,
                            width: width - (height * 0.207),
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            child: inputBattleCustomTextField(
                              controller: _searchController,
                              errorText: null,
                              hintText: '${AppStringRes.search}...',
                              maxLength: 30,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  color: redColor,
                                  splashColor: const Color(0xffCFFFB1),
                                  highlightColor: const Color(0xffCFFFB1),
                                  splashRadius: height * 0.03,
                                  icon: const Icon(Icons.search_rounded),
                                  iconSize: height * 0.035,
                                  tooltip: AppStringRes.search,
                                  onPressed: () {
                                    usersConnect.clear();

                                    BlocProvider.of<ConnectBloc>(context).add(
                                        connect_bloc.StartSearchTheValue(
                                            _searchController.text
                                                .trim()
                                                .toLowerCase()));
                                  },
                                ),
                                Container(
                                  color: Colors.grey,
                                  height: height * 0.04,
                                  width: 0.5,
                                ),
                                IconButton(
                                  color: Colors.grey,
                                  splashColor: const Color(0xffCFFFB1),
                                  highlightColor: const Color(0xffCFFFB1),
                                  splashRadius: height * 0.03,
                                  tooltip: AppStringRes.clear,
                                  icon:
                                      const Icon(Icons.delete_forever_outlined),
                                  iconSize: height * 0.035,
                                  onPressed: () {
                                    usersConnect.clear();
                                    _searchController.text = '';
                                    BlocProvider.of<ConnectBloc>(context).add(
                                        connect_bloc.ClearSearchTheValue());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.isNeedToShowSearchBar
                        ? height - (height * 0.2)
                        : height - (height * 0.121),
                    width: width,
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: usersConnect.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext con, int index) {
                            return userCardMain(
                              context: context,
                              width: width,
                              height: height,
                              model: usersConnect[index],
                              pace: getFormattedPaceTime(pace: usersConnect[index].pace.toDouble()),
                              onTapCard: () {
                                BlocProvider.of<ConnectBloc>(context).add(
                                    connect_bloc.NavigateToUserInfo(
                                        usersConnect[index]));
                              },
                              onTapBattleCreate: (ConnectUsersModel model) {
                                widget.onBattleTap(
                                  model,
                                );
                              },
                            );
                          }),
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
