import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/data/apis/runner_data_api.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/bloc.dart'
    as runner_data_bloc;
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/runner_data_bloc.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/runner_data_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/resources/strings.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/runnersData'
class RunnerDataPage extends StatefulWidget {
  RunnerDataPage({Key? key, this.pageIndex = 0}) : super(key: key);

  final int pageIndex;

  @override
  _RunnerDataPageState createState() =>
      _RunnerDataPageState(pageIndex: pageIndex);
}

class _RunnerDataPageState extends State<RunnerDataPage> {
  _RunnerDataPageState({this.pageIndex = 0});

  var pageIndex;

  final _runnerDataApi = RunnerDataApi();

  late PageController _pageController;
  final _nickNameController = TextEditingController();
  final continueController = RoundedLoadingButtonController();
  final goController = RoundedLoadingButtonController();

  String? _nickNameError;

  int _countOfRuns = 1;

  double _currentPaceValue = 300;
  double _currentWeeklyDistanceValue = 30;

  bool isKM = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: BlocProvider<RunnerDataBloc>(
          create: (final context) => RunnerDataBloc(),
          child: BlocListener<RunnerDataBloc, RunnerDataState>(
            listener: (final context, final state) async {
              if (state is FieldsChecked) {
                if (isFieldsChecked()) {
                  await PreferenceUtils.setUserNickName(
                      _nickNameController.text);
                  await PreferenceUtils.setPageRout('NewRunner');
                  await _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                }
                continueController.reset();
              } else if (state is KmOrMileIsSelected) {
                isKM = state.isKM;
                isKM ? _currentPaceValue = 300 : _currentPaceValue = 480;
                isKM
                    ? _currentWeeklyDistanceValue = 30
                    : _currentWeeklyDistanceValue = 18.6;
              } else if (state is TimesPerWeekIsSelected) {
                _countOfRuns = state.timesPerWeek;
              } else if (state is ToHomeIsNavigated) {
                await _runnerDataApi
                    .sendRunnerData(state.runnerDataModel)
                    .then((value) async {
                  if (value) {
                    await _pageController
                        .animateToPage(3,
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeIn)
                        .then((_) {
                      Timer(const Duration(seconds: 3), () async {
                        await PreferenceUtils.setIsUserAuthenticated(true);
                        await Navigator.of(context)
                            .pushReplacementNamed(Constants.homeRoute);
                      });
                    });
                  } else {
                    await Fluttertoast.showToast(
                        msg: 'Unexpected error happened',
                        fontSize: 16.0,
                        gravity: ToastGravity.CENTER);
                  }
                  goController.reset();
                });
              }

              BlocProvider.of<RunnerDataBloc>(context)
                  .add(runner_data_bloc.UpdateState());
            },
            child: BlocBuilder<RunnerDataBloc, RunnerDataState>(
                builder: (final context, final state) {
              return Container(
                width: width,
                height: height,
                color: Colors.white,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _nickNameInput(context: context, width: width),
                    _newRunning(context: context),
                    _additionalInformation(
                      context: context,
                      height: height,
                      width: width,
                    ),
                    _profileCreated(),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _nickNameInput(
      {required BuildContext context, required double width}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Enter your nickname',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: inputTextField(
              controller: _nickNameController,
              errorText: _nickNameError,
              hintText: 'Nick Name',
            ),
          ),
          Container(
            height: 400.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  nickNameBackground,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: buildRoundedButton(
              label: 'Continue',
              width: width,
              height: 40.h,
              controller: continueController,
              textColor: Colors.white,
              backColor: redColor,
              onTap: () async {
                BlocProvider.of<RunnerDataBloc>(context)
                    .add(runner_data_bloc.CheckFields());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _newRunning({required BuildContext context}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 400.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  newRunnerBackground,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Are you new to running?',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonSquareNoIcon(
                    onPressed: () async {
                      BlocProvider.of<RunnerDataBloc>(context)
                          .add(runner_data_bloc.NavigateToHome(
                        RunnerDataModel(
                          nickName: _nickNameController.text.isNotEmpty
                              ? _nickNameController.text
                              : PreferenceUtils.getUserNickName(),
                          isMetric: isKM,
                          pace: 8.0,
                          weeklyDistance: 5.0,
                          workoutsPerWeek: 2,
                        ),
                      ));
                    },
                    color: redColor,
                    title: 'Yes, I am a\nbeginner',
                    underButtonTitle: 'All the required data will be\n'
                        'filled for you. It can be changed\n'
                        'later in your profile',
                    textColor: Colors.white,
                  ),
                  buttonSquareNoIcon(
                    onPressed: () async {
                      await PreferenceUtils.setPageRout('NewRunner');
                      await _pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 1),
                          curve: Curves.ease);
                    },
                    color: grayColor,
                    title: 'Nope, I have run\nbefore',
                    underButtonTitle:
                        'You will be asked to provide\nsome running data\n',
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _additionalInformation(
      {required BuildContext context,
      required double height,
      required double width}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            backGround,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Please provide additional\ninformation',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            seekBarPace(
              title: 'Pace',
              context: context,
              dialogTitle: 'Pace',
              dialogText: paceText,
              timePerKM: _currentPaceValue,
              unit: isKM ? 'km' : 'mile',
              kmPerHour: (60 * 60) / _currentPaceValue,
              minValue: (isKM ? 2 : 3) * 60,
              maxValue: (isKM ? 11 : 18) * 60,
              sliderValue: _currentPaceValue,
              onChanged: (value) {
                setState(() {
                  _currentPaceValue = value;
                });
              },
            ),
            seekBarWeekly(
              title: 'Weekly distance',
              context: context,
              dialogTitle: 'Weekly distance',
              dialogText: weeklyDistanceText,
              timePerKM: _currentWeeklyDistanceValue,
              unit: isKM ? 'km' : 'mile',
              minValue: isKM ? 4 : 2.5,
              maxValue: isKM ? 150 : 94,
              sliderValue: _currentWeeklyDistanceValue,
              onChanged: (value) {
                setState(() {
                  _currentWeeklyDistanceValue = value;
                });
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Show pace and distances in',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonNoIcon(
                    title: 'KM',
                    color: isKM ? redColor : grayColor,
                    textColor: isKM ? Colors.white : Colors.black,
                    width: width * 0.35,
                    height: height * 0.07,
                    onPressed: () async {
                      BlocProvider.of<RunnerDataBloc>(context)
                          .add(runner_data_bloc.SelectKmOrMile(true));
                    },
                  ),
                  buttonNoIcon(
                    title: 'MI',
                    color: isKM ? grayColor : redColor,
                    textColor: isKM ? Colors.black : Colors.white,
                    width: width * 0.35,
                    height: height * 0.07,
                    onPressed: () async {
                      BlocProvider.of<RunnerDataBloc>(context)
                          .add(runner_data_bloc.SelectKmOrMile(false));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'How often do you run?',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'roboto',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonNoIcon(
                    title: '-',
                    color: grayColor,
                    textColor: Colors.black,
                    width: 100.w,
                    height: 30.h,
                    onPressed: () async {
                      if (_countOfRuns > 1) {
                        BlocProvider.of<RunnerDataBloc>(context).add(
                            runner_data_bloc.SelectTimesPerWeek(
                                _countOfRuns -= 1));
                      }
                    },
                  ),
                  Container(
                    width: 80.w,
                    height: 50.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _countOfRuns.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        const Divider(
                          height: 3,
                          thickness: 2,
                        ),
                        Text(
                          'times per week',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  buttonNoIcon(
                    title: '+',
                    color: redColor,
                    width: 100.w,
                    height: 30.h,
                    onPressed: () async {
                      if (_countOfRuns < 7) {
                        BlocProvider.of<RunnerDataBloc>(context).add(
                            runner_data_bloc.SelectTimesPerWeek(
                                _countOfRuns += 1));
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin: EdgeInsets.only(top: height * 0.18),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildRoundedButton(
                      label: 'Let\'s go!',
                      width: width,
                      height: 40.h,
                      controller: goController,
                      textColor: Colors.white,
                      backColor: redColor,
                      onTap: () async {
                        BlocProvider.of<RunnerDataBloc>(context)
                            .add(runner_data_bloc.NavigateToHome(
                          RunnerDataModel(
                            nickName: _nickNameController.text.isNotEmpty
                                ? _nickNameController.text
                                : PreferenceUtils.getUserNickName(),
                            isMetric: isKM,
                            pace: _currentPaceValue / 60,
                            weeklyDistance: _currentWeeklyDistanceValue,
                            workoutsPerWeek: _countOfRuns,
                          ),
                        ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buttonNoIcon(
                      title: 'Go back',
                      color: Colors.transparent,
                      height: 40.h,
                      textColor: Colors.black,
                      shadowColor: Colors.transparent,
                      onPressed: () async {
                        await PreferenceUtils.setPageRout('NewRunner');
                        await _pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCreated() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            profileCreatedBackground,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  bool isFieldsChecked() {
    if (_nickNameController.text.isNotEmpty) {
      _nickNameError = null;
    } else {
      _nickNameError = 'Fill the nickname field!';
    }

    return _nickNameError == null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }
}
