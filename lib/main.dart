// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/connect_screen/user_info.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_page.dart';
import 'package:one2one_run/presentation/home_screen/home_page.dart';
import 'package:one2one_run/presentation/login_screen/login_page.dart';
import 'package:one2one_run/presentation/password_screen/password_page.dart';
import 'package:one2one_run/presentation/register_screen/register_page.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_page.dart';
import 'package:one2one_run/presentation/splash_screen/splash_screen.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('Main Background message ${message.notification.body}');
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: redColor));
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    await PreferenceUtils.init();
    runApp(OneTwoOne());
  });
}

class OneTwoOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'One2OneApp',
        routes: {
          Constants.loginRoute: (context) => LoginPage(),
          Constants.registerRoute: (context) => RegisterPage(),
          Constants.runnersDataRoute: (context) => RunnerDataPage(),
          Constants.homeRoute: (context) => HomePage(),
          Constants.passwordRoute: (context) => PasswordPage(),
        },
        home: SplashScreen(),
        // home: RegisterPage(),
      ),
    );
  }
}
