import 'package:flutter/material.dart';
import 'package:one2one_run/presentation/login_screen/login_page.dart';
import 'package:one2one_run/presentation/register_screen/register_page.dart';
import 'package:one2one_run/presentation/splash/splash_screen.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

Future<void> main() async {
  await PreferenceUtils.init().then((value) => runApp(RunTwoRun()));
}

class RunTwoRun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'One2OneApp',
      routes: {
        Constants.loginRoute: (context) => LoginPage(),
        Constants.registerRoute: (context) => RegisterPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
