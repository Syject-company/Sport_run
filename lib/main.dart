// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/configuration_screen/configuration_page.dart';
import 'package:one2one_run/presentation/home_screen/home_page.dart';
import 'package:one2one_run/presentation/login_screen/login_page.dart';
import 'package:one2one_run/presentation/password_screen/password_page.dart';
import 'package:one2one_run/presentation/register_screen/register_page.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_page.dart';
import 'package:one2one_run/presentation/splash_screen/splash_screen.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/app_string_res.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('Main Background message ${message.notification.body}');
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: redColor));
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    await PreferenceUtils.init();
    runApp(const OneTwoOne());
  });
}

class OneTwoOne extends StatelessWidget {
  const OneTwoOne({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(Colors.redAccent),
            radius: const Radius.circular(50.0),
            thickness: MaterialStateProperty.all(2.2),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }),
        ),
        title: AppStringRes.appTitle,
        routes: <String, WidgetBuilder>{
          Constants.loginRoute: (BuildContext context) => const LoginPage(),
          Constants.registerRoute: (BuildContext context) =>
              const RegisterPage(),
          Constants.runnersDataRoute: (BuildContext context) =>
              const RunnerDataPage(),
          Constants.homeRoute: (BuildContext context) => const HomePage(),
          Constants.passwordRoute: (BuildContext context) =>
              const PasswordPage(),
          Constants.configurationRoute: (BuildContext context) =>
              const ConfigurationPage(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}
