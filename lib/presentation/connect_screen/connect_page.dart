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

//NOte:'/connect'
class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key, required this.users, required this.onBattleTap})
      : super(key: key);

  final List<ConnectUsersModel> users;
  final Function(ConnectUsersModel userModel) onBattleTap;

  @override
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage> {
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
            body: Container(
              width: width,
              height: height,
              color: Colors.white,
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
