import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/change_password_api.dart';
import 'package:one2one_run/data/models/change_pass_email_model.dart';
import 'package:one2one_run/data/models/code_verification_model.dart';
import 'package:one2one_run/data/models/update_password_model.dart';
import 'package:one2one_run/presentation/password_screen/password_bloc/bloc.dart'
    as password_bloc;
import 'package:one2one_run/presentation/password_screen/password_bloc/password_bloc.dart';
import 'package:one2one_run/presentation/password_screen/password_bloc/password_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:one2one_run/utils/extension.dart' show EmailValidator;
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/password'
class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final PageController _pageController = PageController();
  final RoundedLoadingButtonController _verifyNameController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _checkCodeController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _applyNewPassController =
      RoundedLoadingButtonController();

  String? emailError;
  String? passwordError;
  String codeError = 'Digit code is wrong';

  bool isSecureText = true;
  bool isCodeError = false;
  bool isPasswordChangedPage = false;
  bool isLoading = false;

  final ChangePasswordApi _changePasswordApi = ChangePasswordApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> title = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<PasswordBloc>(
      create: (final BuildContext context) => PasswordBloc(),
      child: BlocListener<PasswordBloc, PasswordState>(
        listener:
            (final BuildContext context, final PasswordState state) async {
          if (state is PassIsShownOrHidden) {
            isSecureText = !isSecureText;
          } else if (state is FieldsChecked) {
            if (isFieldsChecked()) {
              isLoading = true;
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.NavigateToEnterCodePage());
            } else {
              _verifyNameController.reset();
            }
          } else if (state is NavigatedToEnterCodePage) {
            await _changePasswordApi
                .sendUserEmailToGetCode(
                    ChangePassEmailModel(email: _emailController.text))
                .then((String value) async {
              if (value.isEmpty) {
                await _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
                _verifyNameController.success();
              } else {
                await Fluttertoast.showToast(
                    msg: value, fontSize: 16.0, gravity: ToastGravity.CENTER);
                _verifyNameController.reset();
              }
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.ShowHideLoading());
            });
          } else if (state is ResentCode) {
            await _changePasswordApi
                .sendUserEmailToGetCode(
                    ChangePassEmailModel(email: _emailController.text))
                .then((String value) async {
              if (value.isEmpty) {
                await Fluttertoast.showToast(
                    msg: 'Verification code has been sent to your Email',
                    fontSize: 16.0,
                    gravity: ToastGravity.CENTER);
              } else {
                await Fluttertoast.showToast(
                    msg: value, fontSize: 16.0, gravity: ToastGravity.CENTER);
              }
            });
          } else if (state is CodeIsChecked) {
            if (_isCodeChecked()) {
              isCodeError = false;
              isLoading = true;
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.NavigateToCreateNewPassword());
            } else {
              isCodeError = true;
              _checkCodeController.reset();
            }
          } else if (state is NavigatedToCreateNewPassword) {
            await _changePasswordApi
                .sendCodeVerification(CodeVerificationModel(
              email: _emailController.text,
              confirmationCode: _codeController.text,
            ))
                .then((String value) async {
              if (value.isEmpty) {
                _checkCodeController.success();
                await _pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              } else {
                BlocProvider.of<PasswordBloc>(context)
                    .add(password_bloc.ShowCodeError());
                _checkCodeController.reset();
              }
            });
            BlocProvider.of<PasswordBloc>(context)
                .add(password_bloc.ShowHideLoading());
          } else if (state is IsShownHiddenLoading) {
            isLoading = false;
          } else if (state is IsShownCodeError) {
            isCodeError = true;
            codeError = 'Digit code is wrong';
          } else if (state is FieldsNewPasswordsChecked) {
            if (isFieldsNewPasswordsChecked()) {
              isLoading = true;
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.NavigateToPasswordChangedPage());
            } else {
              _applyNewPassController.reset();
            }
          } else if (state is NavigatedToPasswordChangedPage) {
            await _changePasswordApi
                .updatePassword(UpdatePasswordModel(
              email: _emailController.text,
              newPassword: _passwordController.text,
              confirmationCode: _codeController.text,
            ))
                .then((String value) async {
              if (value.isEmpty) {
                _applyNewPassController.success();
                await _pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
                BlocProvider.of<PasswordBloc>(context)
                    .add(password_bloc.HideAppBar());
              } else {
                _applyNewPassController.reset();
                await Fluttertoast.showToast(
                    msg: value, fontSize: 16.0, gravity: ToastGravity.CENTER);
              }
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.ShowHideLoading());
            });
          } else if (state is AppBarIsHidden) {
            isPasswordChangedPage = true;
            Timer(const Duration(seconds: 2), () {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.NavigateToLogInPage());
            });
          } else if (state is NavigatedToLogInPage) {
            await Navigator.of(context)
                .pushReplacementNamed(Constants.loginRoute);
          }

          BlocProvider.of<PasswordBloc>(context)
              .add(password_bloc.UpdateState());
        },
        child: BlocBuilder<PasswordBloc, PasswordState>(
            builder: (final BuildContext context, final PasswordState state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: isPasswordChangedPage
                ? null
                : AppBar(
                    title: Text(
                      title['title'] ?? 'Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'roboto',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    actions: <Widget>[
                      if (isLoading)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: progressIndicator(),
                        )
                      else
                        Container(),
                    ],
                    backgroundColor: const Color(0xff2B2B2B),
                  ),
            body: SafeArea(
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: width,
                    height: height - 100,
                    color: Colors.white,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        _enterEmail(context: context, width: width),
                        _enterVerificationCode(
                          context: context,
                          width: width,
                        ),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            height: height - 100,
                            child: _createNewPassword(
                              context: context,
                              width: width,
                            ),
                          ),
                        ),
                        _passwordChanged(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _enterEmail({required BuildContext context, required double width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Align(
            child: Image.asset(
              passwordBackground,
              width: 339.w,
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter your email',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            width: width - 16,
            alignment: Alignment.centerLeft,
            child: Text(
              'Please enter your email address to receive '
              'a verification code',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          inputTextField(
            controller: _emailController,
            errorText: emailError,
            hintText: 'E-mail address',
            icon: Icons.email,
          ),
          SizedBox(
            height: 40.h,
          ),
          buildRoundedButton(
            label: 'Verify',
            width: width,
            height: 40.h,
            controller: _verifyNameController,
            textColor: Colors.white,
            backColor: redColor,
            onTap: () async {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.CheckFields());
            },
          ),
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.maxFinite, 40.h),
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent),
              child: Text(
                'Cancel'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'roboto',
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _enterVerificationCode(
      {required BuildContext context, required double width}) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            verificationCodeBackground,
            width: 339.w,
          ),
        ),
        SizedBox(
          height: 35.h,
        ),
        const Spacer(),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Enter Code',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: width,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Please enter the 6 digit code sent to email@gmail.com',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextButton(
            onPressed: () async {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.ResendCode());
            },
            child: Text(
              'Resend code',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'roboto',
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PinPut(
            fieldsCount: 6,
            eachFieldHeight: 44.h,
            eachFieldWidth: 30.w,
            controller: _codeController,
            fieldsAlignment: MainAxisAlignment.center,
            eachFieldMargin: const EdgeInsets.symmetric(horizontal: 10.0),
            textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.normal,
                fontFamily: 'roboto',
                color: isCodeError ? Colors.red : Colors.black),
            submittedFieldDecoration: codeDecoration.copyWith(
              border: Border.all(
                  color: isCodeError
                      ? Colors.red.withAlpha(80)
                      : Colors.grey.withAlpha(80),
                  width: isCodeError ? 2.0 : 0.5),
            ),
            selectedFieldDecoration: codeDecoration,
            followingFieldDecoration: codeDecoration,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          height: 15.h,
          child: Visibility(
            visible: isCodeError,
            child: Text(
              codeError,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'roboto',
                  color: Colors.red),
            ),
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: buildRoundedButton(
            label: 'Verify',
            width: width,
            height: 40.h,
            controller: _checkCodeController,
            textColor: Colors.white,
            backColor: redColor,
            onTap: () async {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.CheckCode());
            },
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(double.maxFinite, 40.h),
                primary: Colors.transparent,
                shadowColor: Colors.transparent),
            child: Text(
              'Cancel'.toUpperCase(),
              style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'roboto',
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createNewPassword(
      {required BuildContext context, required double width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Image.asset(
              newPasswordBackground,
              width: 339.w,
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Create new password',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: width - 16,
            alignment: Alignment.centerLeft,
            child: Text(
              'Your new password must be different from previously '
              'used password',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          inputTextField(
            controller: _passwordController,
            errorText: passwordError,
            hintText: 'New password',
            icon: Icons.lock_rounded,
            obscureTextOnTap: () {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.ShowOrHidePass());
            },
            obscureText: isSecureText,
          ),
          SizedBox(
            height: 20.h,
          ),
          inputTextField(
            controller: _confirmPasswordController,
            errorText: passwordError,
            hintText: 'Repeat new password',
            icon: Icons.lock_rounded,
            obscureTextOnTap: () {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.ShowOrHidePass());
            },
            obscureText: isSecureText,
          ),
          SizedBox(
            height: 40.h,
          ),
          buildRoundedButton(
            label: 'Apply',
            width: width,
            height: 40.h,
            controller: _applyNewPassController,
            textColor: Colors.white,
            backColor: redColor,
            onTap: () async {
              BlocProvider.of<PasswordBloc>(context)
                  .add(password_bloc.CheckNewPasswordsFields());
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.maxFinite, 40.h),
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent),
              child: Text(
                'Cancel'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'roboto',
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordChanged() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            passwordChangedBackground,
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  bool isFieldsChecked() {
    if (_emailController.text.isNotEmpty &&
        _emailController.text.isValidEmailInput()) {
      emailError = null;
    } else {
      emailError = 'Wrong email address';
    }

    return emailError == null;
  }

  bool isFieldsNewPasswordsChecked() {
    if (_confirmPasswordController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text == _passwordController.text) {
      passwordError = null;
    } else {
      passwordError = 'Empty fields or passwords not matches';
    }

    return passwordError == null;
  }

  bool _isCodeChecked() {
    if (_codeController.text.isEmpty) {
      codeError = 'Fill the field!';
      return false;
    } else if (_codeController.text.length < 6) {
      codeError = 'Should be 6 digits!';
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _codeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
