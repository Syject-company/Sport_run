import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/extension.dart';

//NOte: '/userInfo'
class UserInfo extends StatelessWidget {
  const UserInfo({Key? key, required this.userModel, required this.onBattleTap})
      : super(key: key);

  final ConnectUsersModel userModel;
  final Function(ConnectUsersModel userModel) onBattleTap;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(
          userModel.nickName ?? 'NickName',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: colorPrimary,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                        height: height * 0.12,
                        width: height * 0.12,
                        child: userAvatarPhoto(
                          photoUrl: userModel.photoLink,
                          height: height,
                          width: width,
                          context: context,
                        )),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: width * 0.65,
                          child: Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  userModel.nickName ?? 'NickName',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontFamily: 'roboto',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.15,
                              ),
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
                                'Rank ${userModel.rank}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: width * 0.65,
                          child: Text(
                            userModel.moto ?? 'Here will be your Motto.',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: 'roboto',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  children: <Widget>[
                    _cardItem(
                      height: height,
                      width: width + 10,
                      title: 'Pace',
                      icon: paceIcon,
                      value:
                          '${userModel.pace.toStringAsFixed(1)} min/${userModel.isMetric ? 'km' : 'mile'}',
                    ),
                    SizedBox(
                      width: height * 0.02,
                    ),
                    _cardItem(
                      height: height,
                      width: width + 10,
                      title: 'Runs',
                      icon: runsIcon,
                      value: '${userModel.workoutsPerWeek} times/week',
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: _cardItem(
                    height: height,
                    width: width + 120,
                    title: 'Weekly Distance',
                    icon: weeklyDistanceIcon,
                    value:
                        '${userModel.isMetric ? double.parse(userModel.weeklyDistance.toStringAsFixed(0)) : double.parse(userModel.weeklyDistance.toStringAsFixed(1))} ${userModel.isMetric ? 'km' : 'mile'}',
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const Divider(
                  height: 3,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _userWonLoss(
                        title: 'Won',
                        value: '${userModel.wins}',
                        colorValue: Colors.red),
                    Container(
                      color: Colors.grey,
                      height: 10.h,
                      width: 0.5,
                    ),
                    _userWonLoss(
                      title: 'Loss',
                      value: '${userModel.loses}',
                    ),
                    Container(
                      color: Colors.grey,
                      height: 10.h,
                      width: 0.5,
                    ),
                    _userWonLoss(
                      title: 'Discarded',
                      value: '${userModel.discarded}',
                    ),
                    Container(
                      color: Colors.grey,
                      height: 10.h,
                      width: 0.5,
                    ),
                    _userWonLoss(
                      title: 'My score',
                      value: '${userModel.score}',
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const Divider(
                  height: 3,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: height * 0.5,
                  child: _userBio(
                      value: userModel.description ??
                          'Here will be your Biography.'),
                ),
                buttonWithIcon(
                  title: 'BATTLE',
                  icon: battleIcon,
                  buttonColor: Colors.red,
                  iconColor: Colors.white,
                  iconSize: 13.0,
                  titleColor: Colors.white,
                  height: height * 0.06,
                  onPressed: () async {
                    onBattleTap(
                      userModel,
                    );
                  },
                ),
              ],
            ),
          ),
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

  Widget _userBio({required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Bio',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xff2B2B2B),
              fontFamily: 'roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: const Color(0xff455A64),
            fontFamily: 'roboto',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            wordSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _cardItem(
      {required double width,
      required double height,
      required String icon,
      required String title,
      required String value}) {
    return Container(
      width: width / 2.5,
      height: height * 0.04,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xffCDCDCD).withOpacity(0.3),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            icon,
            height: height * 0.015,
            width: height * 0.015,
            fit: BoxFit.fill,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 7.0,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
