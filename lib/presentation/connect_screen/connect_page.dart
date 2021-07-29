import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/bloc.dart'
    as connect_bloc;
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_bloc.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_state.dart';
import 'package:one2one_run/presentation/connect_screen/user_info.dart';
import 'package:one2one_run/resources/images.dart';

//NOte:'/connect'
class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key, required this.users, required this.onBattleTap})
      : super(key: key);

  final List<ConnectUsersModel> users;
  final Function(ConnectUsersModel userModel) onBattleTap;

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
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
                      )),
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
                      return _userCard(
                          context: context,
                          width: width,
                          height: height,
                          model: widget.users[index]);
                    }),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _userCard({
    required double width,
    required double height,
    required ConnectUsersModel model,
    required BuildContext context,
  }) {
    return Center(
      child: Container(
        height: height * 0.41,
        width: width,
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                BlocProvider.of<ConnectBloc>(context)
                    .add(connect_bloc.NavigateToUserInfo(model));
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: height * 0.055,
                  left: width * 0.025,
                  right: width * 0.025,
                  bottom: height * 0.02,
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
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: (width * 0.09) + (height * 0.1),
                        top: height * 0.015,
                      ),
                      child: Text(
                        model.nickName ?? 'NickName',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: (width * 0.09) + (height * 0.1),
                        top: height * 0.013,
                      ),
                      child: Text(
                        model.moto ?? '',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: height * 0.03,
                        ),
                        cardItem(
                          height: height,
                          width: width,
                          title: 'Pace',
                          icon: paceIcon,
                          value:
                              '${model.pace} min/${model.isMetric ? 'km' : 'mile'}',
                        ),
                        SizedBox(
                          width: height * 0.02,
                        ),
                        cardItem(
                          height: height,
                          width: width,
                          title: 'Runs',
                          icon: runsIcon,
                          value: '${model.workoutsPerWeek}+ times/week',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: height * 0.03),
                      alignment: Alignment.centerLeft,
                      child: cardItem(
                        height: height,
                        width: width + 120,
                        title: 'Weekly Distance',
                        icon: weeklyDistanceIcon,
                        value:
                            '${model.weeklyDistance} ${model.isMetric ? 'km' : 'mile'}',
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Divider(
                      height: 3,
                      endIndent: height * 0.03,
                      indent: height * 0.03,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _userWonLoss(
                            title: 'Won',
                            value: '${model.wins}',
                            colorValue: Colors.red),
                        Container(
                          color: Colors.grey,
                          height: 10.h,
                          width: 0.5,
                        ),
                        _userWonLoss(
                          title: 'Loss',
                          value: '${model.loses}',
                        ),
                        SizedBox(
                          width: height * 0.02,
                        ),
                        buttonWithIcon(
                          title: 'BATTLE',
                          icon: battleIcon,
                          iconSize: 13.0,
                          titleColor: Colors.red,
                          height: height * 0.06,
                          width: width * 0.05,
                          onPressed: () async {
                            widget.onBattleTap(
                              model,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: width * 0.07,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.1,
                    width: height * 0.1,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 80,
                      backgroundImage: model.photoLink == null
                          ? AssetImage(
                              defaultProfileImage,
                            ) as ImageProvider
                          : NetworkImage(model.photoLink!),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        rankIcon,
                        height: height * 0.015,
                        width: height * 0.015,
                        fit: BoxFit.fill,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 7.0,
                      ),
                      Text(
                        'Rank ${model.rank}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userWonLoss(
      {required String title,
      required String value,
      Color colorValue = Colors.black}) {
    return Row(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xff838383),
              fontFamily: 'roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: colorValue,
              fontFamily: 'roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
