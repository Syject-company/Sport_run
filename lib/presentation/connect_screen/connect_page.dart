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
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
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
                            width: width - (height * 0.14),
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.025),
                            child: inputFilterTextField(
                              controller: _searchController,
                              errorText: null,
                              hintText: 'Search...',
                              maxLength: 30,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              color: redColor,
                              splashColor: const Color(0xffCFFFB1),
                              highlightColor: const Color(0xffCFFFB1),
                              splashRadius: height * 0.03,
                              icon: const Icon(Icons.search_rounded),
                              iconSize: height * 0.035,
                              onPressed: () {
                                //TODO: here
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.isNeedToShowSearchBar
                        ? height - (height * 0.2)
                        : height - (height * 0.12),
                    width: width,
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: widget.users.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext con, int index) {
                            return userCardMain(
                              context: context,
                              width: width,
                              height: height,
                              model: widget.users[index],
                              onTapCard: () {
                                BlocProvider.of<ConnectBloc>(context).add(
                                    connect_bloc.NavigateToUserInfo(
                                        widget.users[index]));
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
