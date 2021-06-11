import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      //TODO: issa to home
/*      PreferenceUtils.getIsUserAuthenticated()
          ? Navigator.of(context)
              .pushReplacementNamed(Constants.home)
          : Navigator.of(context).pushReplacementNamed(Constants.registerRoute);*/
    });
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
