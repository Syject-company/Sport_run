import 'package:flutter/material.dart';
import 'package:one2one_run/splash/splash_screen.dart';

void main() {
  runApp(RunTwoRun());
}

class RunTwoRun extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'One2OneApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}


