import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' show Response;
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/register_api.dart';
import 'package:one2one_run/data/models/access_user_model.dart';
import 'package:one2one_run/data/models/access_user_response_model.dart';
import 'package:one2one_run/data/models/register_google_appple_model.dart';
import 'package:one2one_run/data/models/register_response_google_appple_model.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/bloc.dart'
    as register_bloc;
import 'package:one2one_run/presentation/register_screen/register_bloc/register_bloc.dart';
import 'package:one2one_run/presentation/register_screen/register_bloc/register_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/resources/strings.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/extension.dart' show EmailValidator;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//NOte:'/register'
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController continueController =
      RoundedLoadingButtonController();

  String? emailError;
  String? passwordError;

  bool isSecureText = true;
  bool isTermsAccepted = false;

  RegisterApi registerApi = RegisterApi();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final RegisterBloc _registerBloc = RegisterBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
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
          create: (final BuildContext context) => _registerBloc,
          child: BlocListener<RegisterBloc, RegisterState>(
            listener:
                (final BuildContext context, final RegisterState state) async {
              if (state is PassIsShownOrHidden) {
                isSecureText = !isSecureText;
              } else if (state is NavigatedToRunnersData) {
                await registerApi
                    .registerEmail(AccessUserModel(
                  email: emailController.text.trim(),
                  password: passwordController.text,
                ))
                    .then((Response value) async {
                  if (value.statusCode == 200) {
                    continueController.success();
                    await PreferenceUtils.setUserToken(
                            AccessUserResponseModel.fromJson(json
                                    .decode(value.body) as Map<String, dynamic>)
                                .token)
                        .then((_) async {
                      await PreferenceUtils.setPageRout('Nickname').then((_) =>
                          Navigator.of(context).pushReplacementNamed(
                              Constants.runnersDataRoute));
                    });
                  } else {
                    continueController.reset();
                    await Fluttertoast.showToast(
                        //   msg: ErrorModel.fromJson(json.decode(value.body)).title.toString(),
                        msg: value.body.toString(),
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
                } else {
                  continueController.reset();
                }
              }

              if (!_registerBloc.isClosed) {
                BlocProvider.of<RegisterBloc>(context).add(
                                register_bloc.UpdateState(),
                              );
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(builder:
                (final BuildContext context, final RegisterState state) {
              return SafeArea(
                child: Container(
                  height: height,
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
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
                        inputTextField(
                          controller: emailController,
                          errorText: emailError,
                          hintText: 'E-mail address',
                          icon: Icons.email,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        inputTextField(
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
                          children: <Widget>[
                            Checkbox(
                              value: isTermsAccepted,
                              onChanged: (_) {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(register_bloc.AcceptTerms());
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(register_bloc.ShowOrHideTerms());
                              },
                              child: SizedBox(
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
                        buildRoundedButton(
                          label: 'Continue',
                          width: width,
                          height: 40.h,
                          controller: continueController,
                          textColor: Colors.white,
                          backColor: redColor,
                          onTap: () async {
                            BlocProvider.of<RegisterBloc>(context)
                                .add(register_bloc.CheckFields());
                          },
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
                          height: 40.h,
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
                          height: 40.h,
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
      await PreferenceUtils.setUserToken(value).then((_) {
        PreferenceUtils.setPageRout('Nickname');
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
    showModalBottomSheet<dynamic>(
        context: context,
        enableDrag: false,
        builder: (BuildContext builder) {
          return Container(
            color: Colors.white,
            height: height / 2,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
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

    if (!passwordController.text.isValidPasswordInput() ||
        passwordController.text.length < 7) {
      passwordError = 'Min 7 chars and at least one lower case letter!';
    }

    if (passwordController.text.isEmpty) {
      passwordError = 'Password is empty';
    }

    if (passwordController.text.isNotEmpty &&
        passwordController.text.length >= 7 &&
        passwordController.text.isValidPasswordInput()) {
      passwordError = null;
    }

    return emailError == null && passwordError == null;
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    await _googleSignIn.signIn().then((GoogleSignInAccount? result) {
      result?.authentication.then((GoogleSignInAuthentication googleKey) async {
        print(googleKey.accessToken);
        print(_googleSignIn.currentUser?.displayName);
        final String? token = googleKey.accessToken;
        if (token != null) {
          final RegisterResponseGoogleAppleModel? userToken =
              await registerApi.registerGoogle(RegisterGoogleAppleModel(
            accessToken: token,
          ));

          BlocProvider.of<RegisterBloc>(context)
              .add(register_bloc.SignInGoogle(token: userToken!.token));
        }
      }).catchError((Object err) {
        print('inner error');
      });
    }).catchError((Object err) async {
      print('error occurred');
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
    });
  }

  Future<String?> signInWithApple({required BuildContext context}) async {
    await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    ).then((AuthorizationCredentialAppleID value) async {
      final String? token = value.identityToken;
      if (token != null) {
        final RegisterResponseGoogleAppleModel? userToken =
            await registerApi.registerApple(RegisterGoogleAppleModel(
          accessToken: token,
        ));

        BlocProvider.of<RegisterBloc>(context)
            .add(register_bloc.SignInApple(token: userToken!.token));
      }
    }).catchError((Object err) async {
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
      return null;
    });
  }

  @override
  void dispose() {
    _registerBloc.close();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
