import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/access_user_model.dart';
import 'package:one2one_run/data/models/access_user_response_model.dart';
import 'package:one2one_run/data/models/error_model.dart';
import 'package:one2one_run/data/models/register_google_appple_model.dart';
import 'package:one2one_run/presentation/login_screen/login_bloc/login_bloc.dart';
import 'package:one2one_run/presentation/login_screen/login_bloc/login_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/extension.dart' show EmailValidator;
import 'package:one2one_run/presentation/login_screen/login_bloc/bloc.dart'
    as login_bloc;
import 'package:one2one_run/data/apis/login_api.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//NOte:'/login'
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInController = RoundedLoadingButtonController();

  String? emailError;
  String? passwordError;

  bool isSecureText = true;

  LoginApi loginApi = LoginApi();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            backGround,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocProvider<LoginBloc>(
          create: (final context) => LoginBloc(),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (final context, final state) async {
              if (state is PassIsShownOrHidden) {
                isSecureText = !isSecureText;
              } else if (state is NavigatedToHome) {
                await loginApi
                    .loginEmail(AccessUserModel(
                  email: emailController.text,
                  password: passwordController.text,
                ))
                    .then((value) async {
                  if (value.statusCode == 200) {
                    await PreferenceUtils.setUserToken(
                            AccessUserResponseModel.fromJson(
                                    json.decode(value.body))
                                .token)
                        .then((value) async {
                      signInController.success();
                      await PreferenceUtils.setIsUserAuthenticated(true).then(
                          (value) => Navigator.of(context)
                              .pushReplacementNamed(Constants.homeRoute));
                    });
                  } else {
                    signInController.reset();
                    await Fluttertoast.showToast(
                        msg: ErrorModel.fromJson(json.decode(value.body))
                            .title
                            .toString(),
                        fontSize: 16.0,
                        gravity: ToastGravity.CENTER);
                  }
                });
              } else if (state is NavigatedToRegister) {
                await Navigator.of(context)
                    .pushReplacementNamed(Constants.registerRoute);
              } else if (state is NavigatedToForgotPassword) {
                await Navigator.of(context).pushNamed(Constants.passwordRoute,
                    arguments: {'title': 'Forgot password'});
              } else if (state is SignInedGoogle) {
                await saveToken(value: state.token, context: context);
              } else if (state is SignInedApple) {
                await saveToken(value: state.token, context: context);
              } else if (state is FieldsChecked) {
                if (isFieldsChecked()) {
                  BlocProvider.of<LoginBloc>(context)
                      .add(login_bloc.NavigateToHome());
                } else {
                  signInController.reset();
                }
              }
              BlocProvider.of<LoginBloc>(context).add(
                login_bloc.UpdateState(),
              );
            },
            child: BlocBuilder<LoginBloc, LoginState>(
                builder: (final context, final state) {
              return SafeArea(
                child: Container(
                  height: height,
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Image.asset(
                          logo,
                          width: 204.w,
                          height: 204.h,
                        ),
                        Text(
                          'Sign In',
                          style: TextStyle(
                              color: redColor,
                              fontFamily: 'roboto',
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Nice to see you again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        inputTextFieldRounded(
                          controller: emailController,
                          errorText: emailError,
                          hintText: 'E-mail address',
                          icon: Icons.email,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        inputTextFieldRounded(
                          controller: passwordController,
                          errorText: passwordError,
                          hintText: 'Password',
                          icon: Icons.lock_rounded,
                          obscureTextOnTap: () {
                            BlocProvider.of<LoginBloc>(context)
                                .add(login_bloc.ShowOrHidePass());
                          },
                          obscureText: isSecureText,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(login_bloc.NavigateToForgotPassword());
                            },
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'roboto',
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        buildRoundedButton(
                          label: 'Sign in',
                          width: width,
                          height: 40.h,
                          controller: signInController,
                          textColor: Colors.white,
                          backColor: redColor,
                          onTap: () async {
                            BlocProvider.of<LoginBloc>(context)
                                .add(login_bloc.CheckFields());
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(login_bloc.NavigateToRegister());
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(double.maxFinite, 40.h),
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Register'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'roboto',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        buttonWithIcon(
                          title: 'Sign in with Apple',
                          icon: appleIcon,
                          size: 40.h,
                          onPressed: () async {
                            await signInWithApple(context: context);
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        buttonWithIcon(
                          title: 'Sign in with Google',
                          icon: googleIcon,
                          size: 40.h,
                          onPressed: () async {
                            await signInWithGoogle(context: context);
                          },
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> saveToken(
      {required String? value, required BuildContext context}) async {
    if (value != null) {
      await PreferenceUtils.setUserToken(value).then((value) {
        PreferenceUtils.setIsUserAuthenticated(true);
        Navigator.of(context).pushReplacementNamed(Constants.homeRoute);
      });
    } else {
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
    }
  }

  bool isFieldsChecked() {
    if (emailController.text.isNotEmpty &&
        emailController.text.isValidEmailInput()) {
      emailError = null;
    } else {
      emailError = 'Check your email format';
    }

    if (passwordController.text.isNotEmpty) {
      passwordError = null;
    } else {
      passwordError = 'Password is empty';
    }
    return emailError == null && passwordError == null;
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    await _googleSignIn.signIn().then((result) {
      result?.authentication.then((googleKey) async {
        print(googleKey.accessToken);
        print(_googleSignIn.currentUser?.displayName);
        final token = googleKey.accessToken;
        if (token != null) {
          final userToken =
              await loginApi.registerGoogle(RegisterGoogleAppleModel(
            accessToken: token,
          ));

          BlocProvider.of<LoginBloc>(context)
              .add(login_bloc.SignInGoogle(token: userToken?.token));
        }
      }).catchError((err) {
        print('inner error');
      });
    }).catchError((err) async {
      print('error occurred');
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
    });
  }

  Future<String?> signInWithApple({required BuildContext context}) async {
    await SignInWithApple.getAppleIDCredential(
      scopes: [],
    ).then((value) async {
      final token = value.identityToken;
      if (token != null) {
        final userToken = await loginApi.registerApple(RegisterGoogleAppleModel(
          accessToken: token,
        ));

        BlocProvider.of<LoginBloc>(context)
            .add(login_bloc.SignInApple(token: userToken?.token));
      }
    }).catchError((err) async {
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
      return null;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
