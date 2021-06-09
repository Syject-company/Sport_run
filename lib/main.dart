import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/login_screen/login_page.dart';
import 'package:one2one_run/presentation/register_screen/register_page.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_page.dart';
import 'package:one2one_run/presentation/splash/splash_screen.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: redColor));
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
        },
        home: SplashScreen(),
      ),
    );
  }
}
