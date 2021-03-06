import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/resources/app_string_res.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Widget changeBattleDrawer({
  required double height,
  required double width,
  required BuildContext context,
  required String titleDrawer,
  required String? userPhoto,
  required String userName,
  required String userRank,
  required double currentDistanceValue,
  required bool isKM,
  required Function(double value) onSeekChanged,
  required VoidCallback onTapGetDatePicker,
  required String dateAndTimeForUser,
  required RoundedLoadingButtonController applyChangeBattleController,
  required VoidCallback onTapApplyBattle,
  required VoidCallback onTapCancelBattle,
  required Function(String? value) onChangedDistanceMenu,
  required String distanceMenuValue,
  required TextEditingController weeklyDistanceCustomController,
}) {
  return Container(
    width: width,
    margin: EdgeInsets.only(left: width * 0.15),
    child: Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    interactIcon,
                    height: 12.0,
                    width: 12.0,
                    fit: BoxFit.contain,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    titleDrawer,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Text(
                AppStringRes.opponent,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              height: height * 0.12,
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xffCDCDCD).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: userAvatarPhoto(
                      photoUrl: userPhoto,
                      height: height,
                      width: width,
                      context: context,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        userName ?? "NickName",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            '${AppStringRes.rank}  $userRank',
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
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            // seekBarWeekly(
            //   title: AppStringRes.distance,
            //   context: context,
            //   dialogTitle: AppStringRes.distance,
            //   dialogText: AppStringRes.distanceText,
            //   timePerKM: currentDistanceValue,
            //   unit: isKM ? 'km' : 'mile',
            //   minValue: isKM ? 2 : 3,
            //   maxValue: isKM ? 11 : 18,
            //   sliderValue: currentDistanceValue,
            //   onChanged: onSeekChanged,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(
                children: <Widget>[
                  Text(
                    AppStringRes.frequentDistances,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'roboto',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              AppStringRes.weeklyDistance,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'roboto',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                            content: Text(
                              AppStringRes.weeklyDistanceText,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'roboto',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            actions: <Widget>[
                              Center(
                                child: Container(
                                  width: 80.0,
                                  height: 50.0,
                                  margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                                  child: buttonNoIcon(
                                    title: AppStringRes.ok,
                                    color: redColor,
                                    height: 40.h,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  distanceIcon,
                  height: height * 0.02,
                  width: height * 0.02,
                  fit: BoxFit.fill,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 7.0,
                ),
                Text(
                  AppStringRes.distance,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  height: height * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    alignment: AlignmentDirectional.center,
                    value: distanceMenuValue,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    underline: const Divider(
                      color: Colors.transparent,
                    ),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(5),
                    style: const TextStyle(color: Colors.black),
                    iconEnabledColor: Colors.red,
                    items: <String>[
                      Constants.filterMenuThree,
                      Constants.filterMenuFive,
                      Constants.filterMenuTen,
                      Constants.filterMenuHalfMarathon,
                      Constants.filterMenuMarathon,
                      Constants.filterMenuCustom,
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      AppStringRes.select,
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: onChangedDistanceMenu,
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Text(
                  isKM ? 'km' : 'mile',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Visibility(
              visible: distanceMenuValue == Constants.filterMenuCustom,
              child: Container(
                height: height * 0.08,
                width: width * 0.35,
                margin: EdgeInsets.only(
                  top: height * 0.01,
                  left: width * 0.31,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: inputBattleCustomTextField(
                  controller: weeklyDistanceCustomController,
                  errorText: null,
                  hintText: AppStringRes.customValue,
                  maxLength: 6,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Text(
                AppStringRes.deadlineDate,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.02, right: width * 0.03),
              child: TextButton(
                onPressed: onTapGetDatePicker,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        dateAndTimeForUser,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w500),
                      ),
                      Image.asset(
                        calendarIcon,
                        height: height * 0.02,
                        width: height * 0.02,
                        fit: BoxFit.contain,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              margin: EdgeInsets.only(top: height * 0.33),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildRoundedButton(
                      label: AppStringRes.apply,
                      width: width,
                      height: 40.h,
                      buttonTextSize: 14.0,
                      controller: applyChangeBattleController,
                      textColor: Colors.white,
                      backColor: redColor,
                      onTap: onTapApplyBattle,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buttonNoIcon(
                      title: AppStringRes.cancel,
                      color: Colors.transparent,
                      height: 40.h,
                      textColor: Colors.black,
                      buttonTextSize: 14.0,
                      shadowColor: Colors.transparent,
                      onPressed: onTapCancelBattle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget battleOfferOnNotificationDrawer({
  required double height,
  required double width,
  required num distance,
  required String deadLineDate,
  required String? battleMessage,
  required ApplicationUser currentUserModel,
  required ApplicationUser secondUserModel,
  required BuildContext context,
  required RoundedLoadingButtonController acceptBattleController,
  required VoidCallback onTapAcceptBattle,
  required VoidCallback onTapChangeConditions,
  required VoidCallback onTapCancelBattle,
}) {
  return Container(
    width: width,
    margin: EdgeInsets.only(left: width * 0.15),
    child: Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    interactIcon,
                    height: 12.0,
                    width: 12.0,
                    fit: BoxFit.contain,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    AppStringRes.battle,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Text(
                AppStringRes.opponent,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              height: height * 0.12,
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xffCDCDCD).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: height * 0.08,
                    width: height * 0.08,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: userAvatarPhoto(
                      photoUrl: secondUserModel.photoLink,
                      height: height,
                      width: width,
                      context: context,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        secondUserModel.nickName.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            '${AppStringRes.rank} ${secondUserModel.rank}',
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
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        AppStringRes.distance,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'roboto',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  AppStringRes.distance,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'roboto',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                content: Text(
                                  AppStringRes.distanceText,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'roboto',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                                actions: <Widget>[
                                  Center(
                                    child: Container(
                                      width: 80.0,
                                      height: 50.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: buttonNoIcon(
                                        title: AppStringRes.ok,
                                        color: redColor,
                                        height: 40.h,
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    currentUserModel.isMetric
                        ? '${distance.toStringAsFixed(0)} km'
                        : '${distance.toStringAsFixed(1)} mile',
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppStringRes.deadlineDate,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'roboto',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                deadLineDate,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppStringRes.message,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'roboto',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                battleMessage ?? AppStringRes.willBePieceOfCake,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              margin: EdgeInsets.only(top: height * 0.2),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildRoundedButton(
                      label: AppStringRes.accept,
                      width: width,
                      height: 40.h,
                      buttonTextSize: 14.0,
                      controller: acceptBattleController,
                      textColor: Colors.white,
                      backColor: redColor,
                      onTap: onTapAcceptBattle,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buttonNoIcon(
                      title: AppStringRes.changeConditions,
                      color: Colors.transparent,
                      height: 40.h,
                      textColor: Colors.black,
                      buttonTextSize: 14.0,
                      shadowColor: Colors.transparent,
                      onPressed: onTapChangeConditions,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buttonNoIcon(
                      title: AppStringRes.cancel,
                      color: Colors.transparent,
                      height: 40.h,
                      textColor: Colors.black,
                      buttonTextSize: 14.0,
                      shadowColor: Colors.transparent,
                      onPressed: onTapCancelBattle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget filterDrawer({
  required BuildContext context,
  required double height,
  required double width,
  required bool isNeedFilter,
  required Function(bool value) onSwitchFilter,
  required String valuePaceStart,
  required String valuePaceEnd,
  required double valuePaceEndValue,
  required bool isKM,
  required RangeValues currentRangeValuesPace,
  required Function(RangeValues values) onRangePaceChanged,
  required double valueWeeklyStart,
  required double valueWeeklyEnd,
  required RangeValues currentRangeValuesWeekly,
  required Function(RangeValues values) onRangeWeeklyChanged,
  required VoidCallback onTapMinusRuns,
  required int countOfRuns,
  required VoidCallback onTapPlusRuns,
  required RoundedLoadingButtonController applyController,
  required VoidCallback onTapApply,
  required VoidCallback onTapCancel,
}) {
  return Container(
    width: width,
    margin: EdgeInsets.only(left: width * 0.15),
    color: Colors.white,
    child: Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Text(
                AppStringRes.filters,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${!isNeedFilter ? 'Enable' : 'Disable'} filters',
                    style: TextStyle(
                        color: const Color(0xff838383),
                        fontSize: 13.sp,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: isNeedFilter,
                    activeColor: const Color(0xffc1ff9b),
                    onChanged: onSwitchFilter,
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    rangeSeekBarPace(
                      title: AppStringRes.pace,
                      context: context,
                      dialogTitle: AppStringRes.pace,
                      dialogText: AppStringRes.paceText,
                      startTimePerKM: valuePaceStart,
                      endTimePerKM: valuePaceEnd,
                      unit: isKM ? 'km' : 'mile',
                      kmPerHour: (60 * 60) / valuePaceEndValue,
                      minValue: (isKM ? 2.01 : 3) * 60,
                      maxValue: (isKM ? 11 : 18) * 60,
                      rangeValue: currentRangeValuesPace,
                      onRangeChanged: onRangePaceChanged,
                    ),
                    rangeSeekBarWeekly(
                      title: AppStringRes.weeklyDistance,
                      context: context,
                      dialogTitle: AppStringRes.weeklyDistance,
                      dialogText: AppStringRes.weeklyDistanceText,
                      startTimePerKM: valueWeeklyStart,
                      endTimePerKM: valueWeeklyEnd,
                      unit: isKM ? 'km' : 'mile',
                      minValue: isKM ? 4 : 2.5,
                      maxValue: isKM ? 150 : 94,
                      rangeValue: currentRangeValuesWeekly,
                      onChanged: onRangeWeeklyChanged,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Text(
                        AppStringRes.runsAtLeast,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'roboto',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          buttonNoIcon(
                            title: '-',
                            color: grayColor,
                            textColor: Colors.black,
                            width: width * 0.17,
                            height: 30.h,
                            onPressed: onTapMinusRuns,
                          ),
                          SizedBox(
                            width: 80.w,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  countOfRuns.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'roboto',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                const Divider(
                                  height: 3,
                                  thickness: 2,
                                ),
                                Text(
                                  AppStringRes.timesPerWeek,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'roboto',
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          buttonNoIcon(
                            title: '+',
                            color: redColor,
                            width: width * 0.17,
                            height: 30.h,
                            onPressed: onTapPlusRuns,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      margin: EdgeInsets.only(top: height * 0.2),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: buildRoundedButton(
                              label: AppStringRes.apply,
                              width: width,
                              height: height * 0.065,
                              buttonTextSize: 14.0,
                              controller: applyController,
                              textColor: Colors.white,
                              backColor: redColor,
                              onTap: onTapApply,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: buttonNoIcon(
                              title: AppStringRes.cancel,
                              color: Colors.transparent,
                              height: height * 0.065,
                              textColor: Colors.black,
                              buttonTextSize: 14.0,
                              shadowColor: Colors.transparent,
                              onPressed: onTapCancel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: !isNeedFilter,
                  child: Container(
                    width: width,
                    height: height - (height * 0.4),
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget battleDrawer({
  required double height,
  required double width,
  required ConnectUsersModel? model,
  required TextEditingController battleNameController,
  required BuildContext context,
  required bool isKM,
  required VoidCallback onTapGetDatePicker,
  required String dateAndTimeForUser,
  required VoidCallback onTapOpenCloseMessageDrawer,
  required String messageToOpponent,
  required RoundedLoadingButtonController applyBattleController,
  required VoidCallback onTapApplyBattle,
  required VoidCallback onTapCancelBattle,
  required String distanceMenuValue,
  required Function(String? value) onChangedDistanceMenu,
  required TextEditingController weeklyDistanceCustomController,
}) {
  return Drawer(
    child: Padding(
      padding: EdgeInsets.only(top: height * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: <Widget>[
                Image.asset(
                  interactIcon,
                  height: 12.0,
                  width: 12.0,
                  fit: BoxFit.contain,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  AppStringRes.battle,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Text(
              AppStringRes.opponent,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.sp,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            height: height * 0.12,
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.04, vertical: height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xffCDCDCD).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: height * 0.08,
                  width: height * 0.08,
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: userAvatarPhoto(
                    photoUrl: model?.photoLink,
                    height: height,
                    width: width,
                    context: context,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      model?.nickName ?? AppStringRes.nickname,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          '${AppStringRes.rank} ${model?.rank}',
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
            ),
            child: inputTextField(
              controller: battleNameController,
              errorText: null,
              maxLength: 25,
              isCounterShown: true,
              hintText: 'Battle vs ${model?.nickName ?? 'Name'}',
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Row(
              children: <Widget>[
                Text(
                  AppStringRes.frequentDistances,
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'roboto',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            AppStringRes.weeklyDistance,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            AppStringRes.weeklyDistanceText,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal),
                          ),
                          actions: <Widget>[
                            Center(
                              child: Container(
                                width: 80.0,
                                height: 50.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: buttonNoIcon(
                                  title: AppStringRes.ok,
                                  color: redColor,
                                  height: 40.h,
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                distanceIcon,
                height: height * 0.02,
                width: height * 0.02,
                fit: BoxFit.fill,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 7.0,
              ),
              Text(
                AppStringRes.distance,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                height: height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  alignment: AlignmentDirectional.center,
                  value: distanceMenuValue,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  underline: const Divider(
                    color: Colors.transparent,
                  ),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(5),
                  style: const TextStyle(color: Colors.black),
                  iconEnabledColor: Colors.red,
                  items: <String>[
                    Constants.filterMenuThree,
                    Constants.filterMenuFive,
                    Constants.filterMenuTen,
                    Constants.filterMenuHalfMarathon,
                    Constants.filterMenuMarathon,
                    Constants.filterMenuCustom,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    AppStringRes.select,
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: onChangedDistanceMenu,
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Text(
                isKM ? 'km' : 'mile',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Visibility(
            visible: distanceMenuValue == Constants.filterMenuCustom,
            child: Container(
              height: height * 0.08,
              width: width * 0.35,
              margin: EdgeInsets.only(
                top: height * 0.01,
                left: width * 0.31,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: inputBattleCustomTextField(
                controller: weeklyDistanceCustomController,
                errorText: null,
                hintText: AppStringRes.customValue,
                maxLength: 6,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStringRes.deadlineDate,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  AppStringRes.deadlineDateMessage,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.02, right: width * 0.03),
            child: TextButton(
              onPressed: onTapGetDatePicker,
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      dateAndTimeForUser,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500),
                    ),
                    Image.asset(
                      calendarIcon,
                      height: height * 0.02,
                      width: height * 0.02,
                      fit: BoxFit.contain,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
            child: Text(
              AppStringRes.messageToOpponent,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.sp,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.02, right: width * 0.03),
            child: TextButton(
              onPressed: onTapOpenCloseMessageDrawer,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.68,
                        child: Text(
                          messageToOpponent,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[400],
                        size: 24.0,
                      ),
                    ],
                  ),
                  const Divider(
                    height: 5,
                    thickness: 2.0,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            //  margin: EdgeInsets.only(top: height * 0.04),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildRoundedButton(
                    label: AppStringRes.apply,
                    width: width,
                    height: 40.h,
                    buttonTextSize: 14.0,
                    controller: applyBattleController,
                    textColor: Colors.white,
                    backColor: redColor,
                    onTap: onTapApplyBattle,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buttonNoIcon(
                    title: AppStringRes.cancel,
                    color: Colors.transparent,
                    height: 40.h,
                    textColor: Colors.black,
                    buttonTextSize: 14.0,
                    shadowColor: Colors.transparent,
                    onPressed: onTapCancelBattle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget messageToOpponentDrawer({
  required BuildContext context,
  required double height,
  required double width,
  required VoidCallback onTapOpenCloseMessageDrawer,
  required Function(int index) onTapSelectMessageToOpponent,
  required VoidCallback onTapApplyMessage,
  required TextEditingController messageController,
  required int selectedMessageIndex,
  required RoundedLoadingButtonController applyMessageController,
}) {
  return Drawer(
    child: Padding(
      padding: EdgeInsets.only(top: height * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: onTapOpenCloseMessageDrawer,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                    size: 20.0,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  AppStringRes.messageToOpponent,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
            ),
            child: inputTextField(
              controller: messageController,
              errorText: null,
              hintText: AppStringRes.myVariant,
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            height: height * 0.7,
            child: ListView.builder(
                itemCount: AppStringRes.messagesToOpponent.length,
                itemBuilder: (BuildContext con, int index) {
                  return Container(
                    color: index == selectedMessageIndex
                        ? const Color(0xfff8d2d2)
                        : Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      child: InkWell(
                        onTap: () {
                          onTapSelectMessageToOpponent(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(
                                color: index == selectedMessageIndex
                                    ? Colors.red
                                    : const Color(0xffCDCDCD).withOpacity(0.8),
                              ),
                            ),
                            child: Text(
                              AppStringRes.messagesToOpponent[index],
                              style: TextStyle(
                                  color: index == selectedMessageIndex
                                      ? Colors.red
                                      : Colors.black,
                                  fontSize: 16.sp,
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
            ),
            child: buildRoundedButton(
              label: AppStringRes.apply,
              width: width,
              height: 40.h,
              buttonTextSize: 14.0,
              controller: applyMessageController,
              textColor: Colors.white,
              backColor: redColor,
              onTap: onTapApplyMessage,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget drawerItem({
  required String label,
  required String icon,
  required VoidCallback onPressed,
  required double height,
  required double width,
  required Color selectedItemColor,
}) {
  return Container(
    color: Colors.transparent,
    child: TextButton(
      onPressed: onPressed,
      child: SizedBox(
        child: Column(
          children: <Widget>[
            Image.asset(
              icon,
              height: height,
              width: width,
              fit: BoxFit.fill,
              color: selectedItemColor,
            ),
            const SizedBox(
              height: 2.0,
            ),
            Text(
              label,
              style: TextStyle(
                  color: selectedItemColor,
                  fontSize: 12.sp,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}
