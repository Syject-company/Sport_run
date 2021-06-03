import 'package:flutter/material.dart';

TextStyle get hintTextStyle => const TextStyle(
      color: Color(0xff8E8E93),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

TextStyle get labelTextStyle => const TextStyle(
      color: Colors.black87,
      fontSize: 15,
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

Widget inputTextFieldRounded({
  required TextEditingController controller,
  required String hintText,
  required String? errorText,
  bool obscureText = false,
  bool isCounterShown = false,
  bool isNumbers = false,
  VoidCallback? obscureTextOnTap,
  IconData? icon,
}) {
  return TextFormField(
    controller: controller,
    style: labelTextStyle,
    obscureText: obscureText,
    cursorColor: const Color(0xffFF1744),
    maxLength: isCounterShown ? 6 : null,
    keyboardType: isNumbers ? TextInputType.number : null,
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
      suffixIcon: GestureDetector(
        onTap: obscureTextOnTap,
        child: Icon(
          icon,
          color: icon != null ? Colors.redAccent : null,
        ),
      ),
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
    required double size,
    required String icon,
    required String title}) {
  return Center(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(double.maxFinite, size),
        primary: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 24,
            width: 24,
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            title,
            style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ],
      ),
    ),
  );
}
