import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one2one_run/data/apis/register_api.dart';
import 'package:one2one_run/data/models/register_google_appple_model.dart';
import 'package:one2one_run/data/models/register_model.dart';
import 'package:one2one_run/data/models/register_response_model.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/bloc.dart'
    as register_bloc;
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/register_bloc.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/register_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/resources/strings.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/extension.dart' show EmailValidator;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//NOte:'/register'
class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool isSecureText = true;
  bool isTermsAccepted = false;

  RegisterApi registerApi = RegisterApi();

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
        body: BlocProvider<RegisterBloc>(
          create: (final context) => RegisterBloc(),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (final context, final state) async {
              if (state is PassIsShownOrHidden) {
                isSecureText = !isSecureText;
              } else if (state is NavigatedToRunnersData) {
                await registerApi
                    .registerEmail(RegisterModel(
                  email: emailController.text,
                  password: passwordController.text,
                ))
                    .then((value) async {
                  if (value.statusCode == 200) {
                    await PreferenceUtils.setUserToken(
                            RegisterResponseModel.fromJson(
                                    json.decode(value.body))
                                .token)
                        .then((value) async {
                      await PreferenceUtils.setIsUserAuthenticated(true).then(
                          (value) => Navigator.of(context).pushReplacementNamed(
                              Constants.runnersDataRoute));
                    });
                  } else {
                    await Fluttertoast.showToast(
                        msg: value.body,
                        fontSize: 16.0,
                        gravity: ToastGravity.CENTER);
                  }
                });
              } else if (state is NavigatedToSignIn) {
                await Navigator.of(context)
                    .pushReplacementNamed(Constants.loginRoute);
              } else if (state is TermsIsAccepted) {
                isTermsAccepted = !isTermsAccepted;
              } else if (state is SignInedGoogle) {
                await saveToken(value: state.token, context: context);
              } else if (state is SignInedApple) {
                await saveToken(value: state.token, context: context);
              } else if (state is TermsIsShownOrHidden) {
                _modalBottomSheetMenu(context: context, height: height);
              } else if (state is FieldsChecked) {
                if (isFieldsChecked() && await isUserPassedToContinue()) {
                  BlocProvider.of<RegisterBloc>(context)
                      .add(register_bloc.NavigateToRunnersData());
                }
              }

              BlocProvider.of<RegisterBloc>(context).add(
                register_bloc.UpdateState(),
              );
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
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
                          'Register',
                          style: TextStyle(
                              color: redColor,
                              fontFamily: 'roboto',
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          height: 25.h,
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
                            BlocProvider.of<RegisterBloc>(context)
                                .add(register_bloc.ShowOrHidePass());
                          },
                          obscureText: isSecureText,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isTermsAccepted,
                              onChanged: (value) {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(register_bloc.AcceptTerms());
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(register_bloc.ShowOrHideTerms());
                              },
                              child: Container(
                                width: 250.w,
                                child: Text(
                                  termsButtonText,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                      color: Colors.grey),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<RegisterBloc>(context)
                                  .add(register_bloc.CheckFields());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(double.maxFinite, 40.h),
                              primary: redColor,
                            ),
                            child: Text(
                              'Continue'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              BlocProvider.of<RegisterBloc>(context)
                                  .add(register_bloc.NavigateToSignIn());
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(double.maxFinite, 40.h),
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Sign In'.toUpperCase(),
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
                          title: 'Register with Apple',
                          icon: appleIcon,
                          size: 40.h,
                          onPressed: () async {
                            if (await isUserPassedToContinue()) {
                              await signInWithApple(context: context);
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        buttonWithIcon(
                          title: 'Register with Google',
                          icon: googleIcon,
                          size: 40.h,
                          onPressed: () async {
                            if (await isUserPassedToContinue()) {
                              await signInWithGoogle(context: context);
                            }
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
        Navigator.of(context).pushReplacementNamed(Constants.runnersDataRoute);
      });
    } else {
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
    }
  }

  Future<bool> isUserPassedToContinue() async {
    if (!isTermsAccepted) {
      await Fluttertoast.showToast(
          msg: 'Please, accept the Terms of services and '
              'Privacy Policy!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return isTermsAccepted;
  }

  void _modalBottomSheetMenu({
    required BuildContext context,
    required double height,
  }) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (builder) {
          return Container(
            color: Colors.white,
            height: height / 2,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    'One2One Run',
                    style: TextStyle(
                      color: redColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    termsText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
              await registerApi.registerGoogle(RegisterGoogleAppleModel(
            accessToken: token,
          ));

          BlocProvider.of<RegisterBloc>(context)
              .add(register_bloc.SignInGoogle(token: userToken?.token));
        }
      }).catchError((err) {
        print('inner error');
      });
    }).catchError((err) async {
      print('error occured');
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
        final userToken =
            await registerApi.registerApple(RegisterGoogleAppleModel(
          accessToken: token,
        ));

        BlocProvider.of<RegisterBloc>(context)
            .add(register_bloc.SignInApple(token: userToken?.token));
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
