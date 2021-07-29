import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_page.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      navigateTo();
    });
  }

  void navigateTo() {
    if (PreferenceUtils.getIsUserAuthenticated()) {
      Navigator.of(context).pushReplacementNamed(Constants.homeRoute);
    } else {
      switch (PreferenceUtils.getPageRout()) {
        case 'Register':
          {
            Navigator.of(context).pushReplacementNamed(Constants.registerRoute);
            break;
          }

        case 'Nickname':
          {
            Navigator.of(context)
                .pushReplacementNamed(Constants.runnersDataRoute);
            break;
          }

        case 'NewRunner':
          {
            Navigator.pushReplacement<dynamic, dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const RunnerDataPage(
                          pageIndex: 1,
                        )));
            break;
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backGround),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Image.asset(logo),
      ),
    );
  }
}
