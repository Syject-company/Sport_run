import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/resources/strings.dart';
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
        children: [
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
    children: [
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
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
                    showDialog(
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
                          actions: [
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
              children: [
                Text(
                  '${timePerKM ~/ 60} min/$unit',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${(kmPerHour.toStringAsFixed(2))} $unit/h',
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
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
                    showDialog(
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
                          actions: [
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
              children: [
                Text(
                  '${startTimePerKM ~/ 60} - ${endTimePerKM ~/ 60} min/$unit',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${(kmPerHour.toStringAsFixed(2))} $unit/h',
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
  required String Title,
  required String text,
  required String cancelButtonText,
  required String applyButtonText,
  required VoidCallback onApplyPressed,
}) {
  showDialog(
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
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
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
              Container(
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
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
                    showDialog(
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
                          actions: [
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
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
                    showDialog(
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
                          actions: [
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
    boxShadow: [
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
            contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            insetPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                children: [
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
    turns: const AlwaysStoppedAnimation(-5 / 360),
    child: Container(
      child: Column(
        children: [
          Container(
            height: height * 0.07,
            width: height * 0.07,
            margin: EdgeInsets.only(bottom: height * 0.01),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 80,
              backgroundImage: userPhoto == null
                  ? AssetImage(
                      defaultProfileImage,
                    ) as ImageProvider
                  : NetworkImage(userPhoto),
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
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: [
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
                  'Message to opponent',
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
              hintText: 'My variant',
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Container(
            height: height * 0.7,
            child: ListView.builder(
                itemCount: messagesToOpponent.length,
                itemBuilder: (BuildContext con, int index) {
                  return Container(
                    color: index == selectedMessageIndex
                        ? const Color(0xfff8d2d2)
                        : Colors.white,
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
                          child: Text(
                            messagesToOpponent[index],
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
              label: 'APPLY',
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

Widget battleDrawer({
  required double height,
  required double width,
  required ConnectUsersModel? model,
  required TextEditingController battleNameController,
  required BuildContext context,
  required double currentDistanceValue,
  required bool isKM,
  required Function(double value) onSeekChanged,
  required VoidCallback onTapGetDatePicker,
  required String dateAndTimeForUser,
  required VoidCallback onTapOpenCloseMessageDrawer,
  required String messageToOpponent,
  required RoundedLoadingButtonController applyBattleController,
  required VoidCallback onTapApplyBattle,
  required VoidCallback onTapCancelBattle,
}) {
  return Drawer(
    child: Padding(
      padding: EdgeInsets.only(top: height * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: [
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
                  'Battle',
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
              'Opponent',
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
              children: [
                Container(
                  height: height * 0.08,
                  width: height * 0.08,
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 80,
                    backgroundImage: model?.photoLink == null
                        ? AssetImage(
                            defaultProfileImage,
                          ) as ImageProvider
                        : NetworkImage(model!.photoLink!),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model?.nickName ?? 'NickName',
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
                      children: [
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
                          'Rank ${model?.rank}',
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
          seekBarPace(
            title: 'Distance',
            context: context,
            dialogTitle: 'Distance',
            dialogText: distanceText,
            timePerKM: currentDistanceValue,
            unit: isKM ? 'km' : 'mile',
            kmPerHour: (60 * 60) / currentDistanceValue,
            minValue: (isKM ? 2 : 3) * 60,
            maxValue: (isKM ? 11 : 18) * 60,
            sliderValue: currentDistanceValue,
            onChanged: onSeekChanged,
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Text(
              'Deadline date',
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
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
              'Message to opponent',
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            margin: EdgeInsets.only(top: height * 0.12),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildRoundedButton(
                    label: 'APPLY',
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
                    title: 'Cancel',
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

Widget filterDrawer({
  required BuildContext context,
  required double height,
  required double width,
  required bool isNeedFilter,
  required Function(bool value) onSwitchFilter,
  required double valuePaceStart,
  required double valuePaceEnd,
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
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Text(
                'Filters',
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
                children: [
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
              children: [
                Column(
                  children: [
                    rangeSeekBarPace(
                      title: 'Pace',
                      context: context,
                      dialogTitle: 'Pace',
                      dialogText: paceText,
                      startTimePerKM: valuePaceStart,
                      endTimePerKM: valuePaceEnd,
                      unit: isKM ? 'km' : 'mile',
                      kmPerHour: (60 * 60) / valuePaceEnd,
                      minValue: (isKM ? 2 : 3) * 60,
                      maxValue: (isKM ? 11 : 18) * 60,
                      rangeValue: currentRangeValuesPace,
                      onRangeChanged: onRangePaceChanged,
                    ),
                    rangeSeekBarWeekly(
                      title: 'Weekly distance',
                      context: context,
                      dialogTitle: 'Weekly distance',
                      dialogText: weeklyDistanceText,
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
                        'How often do you run?',
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
                        children: [
                          buttonNoIcon(
                            title: '-',
                            color: grayColor,
                            textColor: Colors.black,
                            width: width * 0.17,
                            height: 30.h,
                            onPressed: onTapMinusRuns,
                          ),
                          Container(
                            width: 80.w,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                  'times per week',
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
                      margin: EdgeInsets.only(top: height * 0.25),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: buildRoundedButton(
                              label: 'APPLY',
                              width: width,
                              height: 40.h,
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
                              title: 'Cancel',
                              color: Colors.transparent,
                              height: 40.h,
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
                    height: height - (height * 0.07),
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
