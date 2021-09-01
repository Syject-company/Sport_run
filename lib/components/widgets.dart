import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/data_values.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

TextStyle get hintTextStyle => const TextStyle(
      color: Color(0xff8E8E93),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

TextStyle get errorTextStyle => const TextStyle(
      color: Colors.red,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

TextStyle get errorTextStyleSmall => const TextStyle(
      color: Colors.red,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

Widget inputTextField({
  required TextEditingController controller,
  required String hintText,
  required String? errorText,
  bool obscureText = false,
  bool isCounterShown = false,
  bool isMultiLine = false,
  VoidCallback? obscureTextOnTap,
  IconData? icon,
  bool isReadOnly = false,
  double fontSize = 15.0,
  int maxLength = 6,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    controller: controller,
    style: TextStyle(
      color: Colors.black87,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ),
    obscureText: obscureText,
    cursorColor: const Color(0xffFF1744),
    maxLength: isCounterShown ? maxLength : null,
    keyboardType: keyboardType,
    maxLines: isMultiLine ? null : 1,
    readOnly: isReadOnly,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.only(
        bottom: 5.0,
        top: 10.0,
      ),
      alignLabelWithHint: false,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(),
      fillColor: Colors.transparent,
      filled: true,
      hintText: hintText,
      suffixIcon: icon != null
          ? GestureDetector(
              onTap: obscureTextOnTap,
              child: Icon(
                icon,
                color: Colors.redAccent,
              ),
            )
          : null,
      hintStyle: hintTextStyle,
      errorText: errorText,
      errorStyle: errorTextStyleSmall,
      labelText: hintText,
      labelStyle: errorText != null ? errorTextStyle : hintTextStyle,
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffFF1744), width: 5.0),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffFF1744), width: 5.0),
      ),
    ),
  );
}

Widget inputTextChatField({
  required TextEditingController controller,
  required double width,
  required double height,
  required VoidCallback onSend,
}) {
  return Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: height * 0.02),
        width: width - (width * 0.28),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: const Color(0xffFF1744),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              bottom: height * 0.03,
              top: 10.0,
              left: 5.0,
            ),
            alignLabelWithHint: false,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
            hintText: 'Message',
            hintStyle: hintTextStyle,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: onSend,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          minimumSize: Size(width * 0.05, height * 0.065),
          primary: const Color(0xfff6f6f6),
          shadowColor: Colors.grey[200],
          onPrimary: redColor,
        ),
        child: const Icon(
          Icons.send,
          color: Color(0xffCDCDCD),
        ),
      ),
    ],
  );
}

Widget buttonWithIcon(
    {required VoidCallback onPressed,
    required double height,
    double width = double.maxFinite,
    double iconSize = 24.0,
    Color titleColor = Colors.black,
    Color buttonColor = Colors.white,
    Color? iconColor,
    required String icon,
    required String title}) {
  return Center(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(width, height),
        primary: buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            icon,
            height: iconSize,
            width: iconSize,
            color: iconColor,
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 17.0, fontWeight: FontWeight.w600, color: titleColor),
          ),
        ],
      ),
    ),
  );
}

Widget buttonWithIconAndTitleBelow({
  required VoidCallback onPressed,
  required double height,
  double width = double.maxFinite,
  double iconSize = 24.0,
  Color buttonColor = Colors.white,
  Color textColor = Colors.black,
  Color? iconColor,
  double textSize = 17.0,
  String? text,
  required String icon,
  Color? shadowColor,
}) {
  return Center(
    child: Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            shadowColor: shadowColor,
            minimumSize: Size(width, height),
            primary: buttonColor,
          ),
          child: Image.asset(
            icon,
            height: iconSize,
            width: iconSize,
            color: iconColor,
          ),
        ),
        Visibility(
          visible: text != null,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              text ?? '',
              style: TextStyle(
                fontSize: textSize,
                color: textColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buttonNoIcon({
  required String title,
  required Color color,
  required VoidCallback onPressed,
  double width = double.maxFinite,
  required double height,
  Color textColor = Colors.white,
  Color? shadowColor,
  double buttonTextSize = 17.0,
}) {
  return Center(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(width, height),
        primary: color,
        shadowColor: shadowColor,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: buttonTextSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget buildRoundedButton({
  required String label,
  required VoidCallback onTap,
  required Color backColor,
  required Color textColor,
  required double height,
  required double width,
  double buttonTextSize = 17.0,
  required RoundedLoadingButtonController controller,
}) {
  return RoundedLoadingButton(
    width: width,
    height: height,
    controller: controller,
    onPressed: onTap,
    color: backColor,
    borderRadius: 10.0,
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: buttonTextSize,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buttonSquareNoIcon(
    {required String title,
    required String underButtonTitle,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed}) {
  return Column(
    children: <Widget>[
      Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minimumSize: Size(140.w, 80.h),
            primary: color,
          ),
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Text(
        underButtonTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17.0,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget seekBarPace({
  required String title,
  required BuildContext context,
  required String dialogTitle,
  required String dialogText,
  required double timePerKM,
  required double kmPerHour,
  required double sliderValue,
  required double minValue,
  required double maxValue,
  required String unit,
  required Function(double value) onChanged,
}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
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
                            dialogTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            dialogText,
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
                                  title: 'Ok',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${timePerKM ~/ 60} min/$unit',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${kmPerHour.toStringAsFixed(2)} $unit/h',
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'roboto',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
      Slider(
        value: sliderValue,
        min: minValue,
        max: maxValue,
        divisions: 90,
        onChanged: onChanged,
        activeColor: Colors.red,
        inactiveColor: const Color(0xffF6C3C3),
      ),
    ],
  );
}

Widget rangeSeekBarPace({
  required String title,
  required BuildContext context,
  required String dialogTitle,
  required String dialogText,
  required double endTimePerKM,
  required double startTimePerKM,
  required double kmPerHour,
  required double minValue,
  required double maxValue,
  required String unit,
  required Function(RangeValues value) onRangeChanged,
  required RangeValues rangeValue,
}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
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
                            dialogTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            dialogText,
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
                                  title: 'Ok',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${startTimePerKM ~/ 60} - ${endTimePerKM ~/ 60} min/$unit',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${kmPerHour.toStringAsFixed(2)} $unit/h',
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'roboto',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
      RangeSlider(
        values: rangeValue,
        min: minValue,
        max: maxValue,
        divisions: 90,
        onChanged: onRangeChanged,
        activeColor: Colors.red,
        inactiveColor: const Color(0xffF6C3C3),
      ),
    ],
  );
}

void dialog({
  required BuildContext context,
  required String title,
  required String text,
  required String cancelButtonText,
  required String applyButtonText,
  required VoidCallback onApplyPressed,
}) {
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'roboto',
              fontSize: 13.sp,
              fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 100.0,
                height: 50.0,
                child: buttonNoIcon(
                  title: cancelButtonText,
                  color: Colors.transparent,
                  height: 40.h,
                  shadowColor: Colors.transparent,
                  textColor: Colors.grey,
                  buttonTextSize: 13.sp,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 100.0,
                height: 50.0,
                child: buttonNoIcon(
                  title: applyButtonText,
                  color: Colors.transparent,
                  height: 40.h,
                  shadowColor: Colors.transparent,
                  textColor: redColor,
                  buttonTextSize: 13.sp,
                  onPressed: onApplyPressed,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void dialogImageZoom({
  required BuildContext context,
  required double height,
  required double width,
  required List<String> photos,
}) {
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        title: Text(
          'Pinch to zoom',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'roboto',
              fontSize: 13.sp,
              fontWeight: FontWeight.normal),
        ),
        content: SizedBox(
          height: height * 0.6,
          width: width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  PinchZoomImage(
                    image: CachedNetworkImage(
                      imageUrl: photos[0],
                      fit: BoxFit.fill,
                      placeholder: (BuildContext context, String url) =>
                          Container(
                        width: 60,
                        height: 60,
                        color: Colors.transparent,
                        child: Center(child: progressIndicator()),
                      ),
                    ),
                    zoomedBackgroundColor:
                        const Color.fromRGBO(240, 240, 240, 1.0),
                  ),
                  Visibility(
                    visible: photos.length > 1,
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      child: PinchZoomImage(
                        image: CachedNetworkImage(
                          imageUrl: photos.length > 1 ? photos[1] : '',
                          fit: BoxFit.fill,
                          placeholder: (BuildContext context, String url) =>
                              Container(
                            width: 60,
                            height: 60,
                            color: Colors.transparent,
                            child: Center(child: progressIndicator()),
                          ),
                        ),
                        zoomedBackgroundColor:
                            const Color.fromRGBO(240, 240, 240, 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: buttonNoIcon(
              title: 'Close'.toUpperCase(),
              color: Colors.transparent,
              height: 40.h,
              shadowColor: Colors.transparent,
              textColor: Colors.black,
              buttonTextSize: 13.sp,
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget seekBarWeekly({
  required String title,
  required BuildContext context,
  required String dialogTitle,
  required String dialogText,
  required double timePerKM,
  required double sliderValue,
  required double minValue,
  required double maxValue,
  required String unit,
  required Function(double value) onChanged,
}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
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
                            dialogTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            dialogText,
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
                                  title: 'Ok',
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
              unit == 'km'
                  ? '${timePerKM.toStringAsFixed(0)} $unit'
                  : '${timePerKM.toStringAsFixed(1)} $unit',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      Slider(
        value: sliderValue,
        min: minValue,
        max: maxValue,
        onChanged: onChanged,
        divisions: 183,
        activeColor: Colors.red,
        inactiveColor: const Color(0xffF6C3C3),
      ),
    ],
  );
}

Widget rangeSeekBarWeekly({
  required String title,
  required BuildContext context,
  required String dialogTitle,
  required String dialogText,
  required double endTimePerKM,
  required double startTimePerKM,
  required double minValue,
  required double maxValue,
  required String unit,
  required Function(RangeValues value) onChanged,
  required RangeValues rangeValue,
}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
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
                            dialogTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            dialogText,
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
                                  title: 'Ok',
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
              unit == 'km'
                  ? '${startTimePerKM.toStringAsFixed(0)} - ${endTimePerKM.toStringAsFixed(0)} $unit'
                  : '${startTimePerKM.toStringAsFixed(1)} - ${endTimePerKM.toStringAsFixed(1)} $unit',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      RangeSlider(
        values: rangeValue,
        min: minValue,
        max: maxValue,
        onChanged: onChanged,
        divisions: 183,
        activeColor: Colors.red,
        inactiveColor: const Color(0xffF6C3C3),
      ),
    ],
  );
}

BoxDecoration get codeDecoration {
  return BoxDecoration(
    border: Border.all(color: Colors.grey.withAlpha(80), width: 0.5),
    color: Colors.white,
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 7,
        offset: const Offset(0, 1),
      ),
    ],
    borderRadius: BorderRadius.circular(5.0),
  );
}

Widget progressIndicator() {
  return const Center(
    child: SizedBox(
      width: 24.0,
      height: 24.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    ),
  );
}

void battleCreated({
  required BuildContext context,
  required double height,
  required double width,
  required String currentUserName,
  required String opponentUserName,
  required String? currentUserPhoto,
  required String? opponentUserPhoto,
}) {
  showDialog<bool>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            content: Container(
              width: width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    battleCreatedBackground,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.24,
                      left: width * 0.1,
                    ),
                    child: _userCreatedBattleInfo(
                      context: context,
                      width: width,
                      height: height,
                      userName: currentUserName,
                      userPhoto: currentUserPhoto,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.24,
                      right: width * 0.04,
                    ),
                    child: _userCreatedBattleInfo(
                      context: context,
                      width: width,
                      height: height,
                      userName: opponentUserName,
                      userPhoto: opponentUserPhoto,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget _userCreatedBattleInfo({
  required BuildContext context,
  required double height,
  required double width,
  required String userName,
  required String? userPhoto,
}) {
  return RotationTransition(
    turns: const AlwaysStoppedAnimation<double>(-5 / 360),
    child: SizedBox(
      child: Column(
        children: <Widget>[
          Container(
            height: height * 0.07,
            width: height * 0.07,
            margin: EdgeInsets.only(bottom: height * 0.01),
            child: userAvatarPhoto(
              photoUrl: userPhoto,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: width * 0.25,
            child: Text(
              userName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget interactTab({required String title}) {
  return SizedBox(
    height: 32,
    child: Center(
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            fontFamily: 'roboto', fontSize: 14.sp, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Widget cardItem(
    {required double width,
    required double height,
    required String icon,
    required String title,
    required String value}) {
  return SizedBox(
    width: width / 2.5,
    child: FittedBox(
      alignment: Alignment.centerLeft,
      fit: BoxFit.scaleDown,
      child: Container(
        height: height * 0.04,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffCDCDCD).withOpacity(0.3),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    ),
  );
}

Widget statusLabel(
    {required double width,
    required int statusCode,
    required bool isBattleMainStatus}) {
  return Container(
    width: width * (isBattleMainStatus ? 0.26 : 0.2),
    height: width * 0.071,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: isBattleMainStatus
          ? DataValues.battleStatusLabels[statusCode]!['color'] as Color
          : DataValues.battleUserStatusLabel[statusCode]!['color'] as Color,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          isBattleMainStatus
              ? DataValues.battleStatusLabels[statusCode]!['icon'] as String
              : DataValues.battleUserStatusLabel[statusCode]!['icon'] as String,
          height: width * 0.05,
          width: width * 0.05,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          width: 4.0,
        ),
        Text(
          isBattleMainStatus
              ? DataValues.battleStatusLabels[statusCode]!['title'] as String
              : DataValues.battleUserStatusLabel[statusCode]!['title']
                  as String,
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

Widget interactListItem({
  required BuildContext context,
  required double width,
  required double height,
  required String distance,
  required BattleRespondModel model,
  required String? opponentName,
  required String? opponentPhoto,
  Function(String id)? onTapAccept,
  Function(String id, BattleRespondModel model)? onTapChange,
  Function(String id)? onTapDecline,
  required bool isNeedButtons,
  bool isFinishedTab = false,
  required int statusCodeNum,
  int? myStatusCodeNum,
  required double heightPercentage,
  required VoidCallback onTapCard,
}) {
  return GestureDetector(
    onTap: onTapCard,
    child: Container(
      height: height * heightPercentage,
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
        children: <Widget>[
          Text(
            model.battleName ?? 'Battle',
            style: TextStyle(
                color: Colors.red,
                fontSize: 18.sp,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: height * 0.017,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              statusLabel(
                width: width,
                isBattleMainStatus: true,
                statusCode: statusCodeNum,
              ),
              Visibility(
                visible: myStatusCodeNum != null && isFinishedTab,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 5,
                    ),
                    statusLabel(
                      width: width,
                      isBattleMainStatus: false,
                      statusCode: myStatusCodeNum ?? 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.008,
          ),
          Row(
            children: <Widget>[
              Container(
                height: height * 0.05,
                width: height * 0.05,
                margin: EdgeInsets.only(
                  right: width * 0.02,
                ),
                child: userAvatarPhoto(photoUrl: opponentPhoto),
              ),
              Text(
                'Opponent',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                opponentName ?? 'Nickname',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Visibility(
            visible: !isFinishedTab,
            child: Container(
              alignment: Alignment.center,
              width: width,
              height: height * 0.038,
              margin: EdgeInsets.only(
                bottom: height * 0.02,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Text(
                  model.message ?? 'It will be a piece of cake!',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isFinishedTab,
            child: Align(
              alignment: Alignment.centerLeft,
              child: cardItem(
                height: height,
                width: width + width * 0.7,
                title: 'Time left',
                icon: weeklyDistanceIcon,
                value: model.timeLeft.toString(),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: cardItem(
              height: height,
              width: width + 50,
              title: 'Distance',
              icon: distanceIcon,
              value: distance,
            ),
          ),
          Visibility(
            visible: isNeedButtons,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: const Divider(
                height: 5,
                endIndent: 3.0,
                indent: 3.0,
              ),
            ),
          ),
          Visibility(
            visible: isNeedButtons,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buttonNoIcon(
                  title: 'Accept',
                  color: const Color(0xffCFFFB1),
                  textColor: Colors.black87,
                  width: width * 0.25,
                  height: height * 0.055,
                  buttonTextSize: 14.sp,
                  onPressed: () {
                    onTapAccept!(model.id);
                  },
                ),
                buttonNoIcon(
                  title: 'Change',
                  color: const Color(0xffEDEDED),
                  textColor: Colors.grey,
                  width: width * 0.25,
                  height: height * 0.055,
                  buttonTextSize: 14.sp,
                  onPressed: () {
                    onTapChange!(model.id, model);
                  },
                ),
                buttonNoIcon(
                  title: 'Decline',
                  color: Colors.white,
                  textColor: Colors.grey,
                  width: width * 0.25,
                  height: height * 0.055,
                  buttonTextSize: 14.sp,
                  onPressed: () {
                    onTapDecline!(model.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget battleDetailsCard({
  required double width,
  required double height,
  required BattleRespondModel model,
  required BuildContext context,
  String myProofTime = '00:00',
  String opponentProofTime = '00:00',
  List<String> myProofsPhoto = const <String>[],
  List<String> myProofPhotosLocalStorage = const <String>[],
  List<String>? opponentProofPhotos,
  required UserModel currentUserModel,
  required String distance,
  required String? opponentPhoto,
  required String opponentName,
  required List<Messages> messages,
  required TextEditingController chatController,
  required RoundedLoadingButtonController uploadResultsController,
  required VoidCallback onTapUploadResults,
  required VoidCallback onMessageSend,
  required Function(List<String> photos) onTapProofImage,
}) {
  return Center(
    child: SizedBox(
      width: width,
      height: height,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              //height: height * 0.41,
              height: height * 0.49,
              width: width,
              color: Colors.transparent,
              margin: EdgeInsets.only(top: height * 0.01),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
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
                        SizedBox(
                          height: height * 0.12,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: width,
                          height: height * 0.038,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              model.message ?? 'It will be a piece of cake!',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        cardItem(
                          height: height,
                          width: width + width * 0.7,
                          title: 'Deadline',
                          icon: weeklyDistanceIcon,
                          value: model.timeLeft.toString(),
                        ),
                        timeAndPhotoInteract(
                          height: height,
                          width: width,
                          model: model,
                          myProofTime: myProofTime,
                          myProofPhotos: myProofsPhoto.isNotEmpty
                              ? myProofsPhoto
                              : myProofPhotosLocalStorage,
                          opponentProofTime: opponentProofTime,
                          opponentProofPhotos:
                              opponentProofPhotos ?? <String>[],
                          uploadResultsController: uploadResultsController,
                          onTapUploadResults: onTapUploadResults,
                          onTapProofImage: onTapProofImage,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: height * 0.01,
                    left: width * 0.17,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: height * 0.1),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: height * 0.1,
                                    width: height * 0.1,
                                    child: userAvatarPhoto(
                                        photoUrl: currentUserModel.photoLink),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    currentUserModel.nickName ?? 'Nickname',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: height * 0.1,
                                    child: Center(
                                      child: statusLabel(
                                        width: width,
                                        isBattleMainStatus: true,
                                        statusCode: model.status.toInt(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    height: height * 0.04,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.017),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffCDCDCD)
                                              .withOpacity(0.3),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                          distanceIcon,
                                          height: height * 0.015,
                                          width: height * 0.015,
                                          fit: BoxFit.fill,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          distance,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontFamily: 'roboto',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: height * 0.1),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: height * 0.1,
                                    width: height * 0.1,
                                    child: userAvatarPhoto(
                                        photoUrl: opponentPhoto),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    opponentName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //NOTE: Chat title
            Container(
              margin: EdgeInsets.only(left: width * 0.04, top: height * 0.01),
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
            //NOTE:Chat card
            Container(
              height: height * 0.415,
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
                children: <Widget>[
                  SizedBox(
                    height: height * 0.271,
                    width: width,
                    child: messages.isNotEmpty
                        ? ListView.builder(
                            itemCount: messages.length,
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext con, int index) {
                              return Column(
                                children: <Widget>[
                                  Visibility(
                                    visible: currentUserModel.id ==
                                        messages[index].applicationUserId,
                                    child: Wrap(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          margin: EdgeInsets.symmetric(
                                              vertical: height * 0.008),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            color: redColor,
                                          ),
                                          child: Text(
                                            messages[index].text ?? '.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'roboto',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Visibility(
                                    visible: currentUserModel.id !=
                                        messages[index].applicationUserId,
                                    child: Wrap(children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          margin: EdgeInsets.symmetric(
                                              vertical: height * 0.008),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            ),
                                            color: Color(0xffF5F5F5),
                                          ),
                                          child: Text(
                                            messages[index].text ?? '.',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'roboto',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              );
                            })
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
                    controller: chatController,
                    height: height,
                    width: width,
                    onSend: onMessageSend,
                  )
                ],
              ),
            ),
            //NOTE:Chat
          ],
        ),
      ),
    ),
  );
}

Widget timeAndPhotoInteract({
  required BattleRespondModel model,
  required double height,
  required double width,
  required String myProofTime,
  required String opponentProofTime,
  required List<String> myProofPhotos,
  required List<String> opponentProofPhotos,
  required RoundedLoadingButtonController uploadResultsController,
  required VoidCallback onTapUploadResults,
  required Function(List<String> photos) onTapProofImage,
}) {
  return Padding(
    padding: EdgeInsets.only(
        left: width * 0.03, bottom: width * 0.03, right: width * 0.03),
    child: Column(
      children: <Widget>[
        SizedBox(
          height: height * 0.02,
        ),
        const Divider(
          height: 3,
          endIndent: 3.0,
          indent: 3.0,
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            timePhotosProofs(
              isMyProofs: true,
              time: myProofTime,
              photos: myProofPhotos,
              width: width,
              height: height,
              battleId: model.id,
              uploadResultsController: uploadResultsController,
              onTapUploadResults: onTapUploadResults,
              onTapProofImage: onTapProofImage,
            ),
            Container(
              color: Colors.grey,
              height: height * 0.1,
              width: 0.2,
              margin: EdgeInsets.symmetric(horizontal: width * 0.02),
            ),
            timePhotosProofs(
              isMyProofs: false,
              time: opponentProofTime,
              photos: opponentProofPhotos,
              width: width,
              height: height,
              battleId: model.id,
              uploadResultsController: uploadResultsController,
              onTapUploadResults: onTapUploadResults,
              onTapProofImage: onTapProofImage,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget timePhotosProofs({
  required double height,
  required double width,
  required bool isMyProofs,
  required String time,
  required List<String> photos,
  required RoundedLoadingButtonController uploadResultsController,
  required VoidCallback onTapUploadResults,
  required Function(List<String> photos) onTapProofImage,
  required String battleId,
}) {
  return SizedBox(
    width: width / 2.45,
    child: isMyProofs && photos.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
            ),
            child: buildRoundedButton(
              label: 'Upload Results'.toUpperCase(),
              width: width,
              height: 35.h,
              buttonTextSize: 13.0,
              controller: uploadResultsController,
              textColor: Colors.black,
              backColor: const Color(0xffF2F2F2),
              onTap: onTapUploadResults,
            ),
          )
        : Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 3.0,
                ),
                width: width * 0.33,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffCDCDCD).withOpacity(0.3),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      timeIcon,
                      height: height * 0.018,
                      width: height * 0.018,
                      fit: BoxFit.fill,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      'Time',
                      maxLines: 1,
                      style: TextStyle(
                          color: const Color(0xff9F9F9F),
                          fontSize: 12.sp,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      time != '00:00' ? time : '--:--',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              if (photos.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    onTapProofImage(photos);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.08,
                        width: height * 0.08,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: photos[0],
                            fit: BoxFit.fill,
                            placeholder: (BuildContext context, String url) =>
                                Container(
                              width: 50,
                              height: 50,
                              color: Colors.transparent,
                              child: Center(child: progressIndicator()),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: photos.length > 1,
                        child: Container(
                          height: height * 0.08,
                          width: height * 0.08,
                          margin: EdgeInsets.only(left: width * 0.03),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: photos.length > 1 ? photos[1] : '',
                              fit: BoxFit.fill,
                              placeholder: (BuildContext context, String url) =>
                                  Container(
                                width: 50,
                                height: 50,
                                color: Colors.transparent,
                                child: Center(child: progressIndicator()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Image.asset(
                  noProofsIcon,
                  height: height * 0.08,
                  width: height * 0.12,
                  fit: BoxFit.contain,
                ),
            ],
          ),
  );
}

Widget showEmptyListText({required double height, required double width}) {
  return SizedBox(
    height: height,
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          logo,
          width: 100.h,
          height: 100.h,
        ),
        Text(
          'List is empty!',
          style: TextStyle(
              color: Colors.grey,
              fontFamily: 'roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

Widget uploadBattleResultDialog({
  required double width,
  required double height,
  required String resultTime,
  required VoidCallback onCancelTap,
  required VoidCallback onUploadTap,
  required VoidCallback onTimeTap,
  required VoidCallback onAddPhotoFirstTap,
  required VoidCallback onAddPhotoSecondTap,
  required File? imageFirst,
  required File? imageSecond,
  required bool isUploading,
}) {
  return Center(
    child: Container(
      height: height * 0.67,
      margin: EdgeInsets.all(width * 0.025),
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 200,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                interactIcon,
                height: 10.0,
                width: 10.0,
                fit: BoxFit.contain,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                'Upload result',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Time',
              style: TextStyle(
                  color: const Color(0xff838383),
                  fontSize: 13.sp,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            width: width,
            child: TextButton(
              onPressed: onTimeTap,
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    resultTime,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            'You can upload 1 or 2 photos',
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'roboto',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (imageFirst == null)
                SizedBox(
                  width: width * 0.35,
                  height: width * 0.35,
                  child: buttonWithIconAndTitleBelow(
                    buttonColor: const Color(0xffF4F4F4),
                    textColor: Colors.grey,
                    shadowColor: Colors.transparent,
                    textSize: 15.sp,
                    icon: addIcon,
                    width: width * 0.2,
                    height: width * 0.2,
                    text: 'Add photo',
                    onPressed: onAddPhotoFirstTap,
                  ),
                )
              else
                SizedBox(
                  width: width * 0.35,
                  height: width * 0.35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      imageFirst,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              if (imageSecond == null)
                SizedBox(
                  width: width * 0.35,
                  height: width * 0.35,
                  child: buttonWithIconAndTitleBelow(
                    buttonColor: const Color(0xffF4F4F4),
                    textColor: Colors.grey,
                    shadowColor: Colors.transparent,
                    textSize: 15.sp,
                    icon: addIcon,
                    width: width * 0.2,
                    height: width * 0.2,
                    text: 'Add photo',
                    onPressed: onAddPhotoFirstTap,
                  ),
                )
              else
                SizedBox(
                  width: width * 0.35,
                  height: width * 0.35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      imageSecond,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 100.0,
                height: 50.0,
                child: buttonNoIcon(
                  title: 'CANCEL',
                  color: Colors.transparent,
                  height: 40.h,
                  shadowColor: Colors.transparent,
                  textColor: Colors.black,
                  buttonTextSize: 13.sp,
                  onPressed: onCancelTap,
                ),
              ),
              Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
                child: Visibility(
                  visible: isUploading,
                  child: Center(child: progressIndicator()),
                ),
              ),
              SizedBox(
                width: 100.0,
                height: 50.0,
                child: buttonNoIcon(
                  title: 'UPLOAD',
                  color: Colors.transparent,
                  height: 40.h,
                  shadowColor: Colors.transparent,
                  textColor: redColor,
                  buttonTextSize: 13.sp,
                  onPressed: onUploadTap,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget userAvatarPhoto({required String? photoUrl}) {
  return photoUrl == null
      ? CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 80,
          backgroundImage: AssetImage(
            defaultProfileImage,
          ),
        )
      : CachedNetworkImage(
          placeholder: (BuildContext context, String url) => Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: Center(child: progressIndicator()),
          ),
          imageUrl: photoUrl,
          imageBuilder:
              (BuildContext context, ImageProvider<Object> imageProvider) {
            return CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 80,
              backgroundImage: imageProvider,
            );
          },
        );
}
