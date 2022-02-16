import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/faq_helper.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/runner_data_api.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/bloc.dart'
    as runner_data_bloc;
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/runner_data_bloc.dart';
import 'package:one2one_run/presentation/runner_data_screen/runner_data_bloc/runner_data_state.dart';
import 'package:one2one_run/resources/app_string_res.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:one2one_run/utils/extension.dart'
    show DateTimeExtension, ToastExtension;
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/runnersData'
class RunnerDataPage extends StatefulWidget {
  const RunnerDataPage({Key? key, this.pageIndex = 0}) : super(key: key);

  final int pageIndex;

  @override
  RunnerDataPageState createState() => RunnerDataPageState();
}

class RunnerDataPageState extends State<RunnerDataPage> {
  final RunnerDataApi _runnerDataApi = RunnerDataApi();
  final RunnerDataBloc _runnerDataBloc = RunnerDataBloc();

  late PageController _pageController;
  final TextEditingController _nickNameController = TextEditingController();
  final RoundedLoadingButtonController continueController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController goController =
      RoundedLoadingButtonController();

  String? _nickNameError;

  int _countOfRuns = 1;

  double _currentPaceValue = 300;
  double _currentWeeklyDistanceValue = 30;

  bool isKM = true;
  bool _isUserBeginnerSelected = false;
  bool _isUserHaveRunSelected = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: BlocProvider<RunnerDataBloc>(
          create: (final BuildContext context) => _runnerDataBloc,
          child: BlocListener<RunnerDataBloc, RunnerDataState>(
            listener: (final BuildContext context,
                final RunnerDataState state) async {
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
                await PreferenceUtils.setIsUserUnitInKM(isKM);
                isKM ? _currentPaceValue = 300 : _currentPaceValue = 480;
                isKM
                    ? _currentWeeklyDistanceValue = 30
                    : _currentWeeklyDistanceValue = 18.6;
              } else if (state is TimesPerWeekIsSelected) {
                _countOfRuns = state.timesPerWeek;
              } else if (state is ToHomeIsNavigated) {
                await _runnerDataApi
                    .sendRunnerData(state.runnerDataModel)
                    .then((bool value) async {
                  if (value) {
                    await _pageController
                        .animateToPage(3,
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeIn)
                        .then((_) {
                      Timer(const Duration(seconds: 1), () async {
                        await PreferenceUtils.setIsUserAuthenticated(true);
                        if (!PreferenceUtils.getIsLoginFAQHelperShown()) {
                          PreferenceUtils.setIsLoginFAQHelperShown(true);
                          Navigator.pushReplacement<dynamic, dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const FAQHelperPage(
                                  faqHelperState: FAQHelperState.LoginState,
                                ),
                              ));
                        } else {
                          await Navigator.of(context)
                              .pushReplacementNamed(Constants.homeRoute);
                        }
                      });
                    });
                  } else {
                    await toastUnexpectedError();
                  }
                });
              } else if (state is RunnerTypeIsSelected) {
                _isUserBeginnerSelected = state.isUserBeginnerSelected;
                _isUserHaveRunSelected = state.isUserHaveRunSelected;
              }

              if (!_runnerDataBloc.isClosed) {
                BlocProvider.of<RunnerDataBloc>(context)
                    .add(runner_data_bloc.UpdateState());
              }
            },
            child: BlocBuilder<RunnerDataBloc, RunnerDataState>(builder:
                (final BuildContext context, final RunnerDataState state) {
              return Container(
                width: width,
                height: height,
                color: Colors.white,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    _nickNameInput(context: context, width: width),
                    _newRunning(
                      context: context,
                      height: height,
                      width: width,
                    ),
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
        children: <Widget>[
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
              maxLength: 18,
              isCounterShown: true,
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

  Widget _newRunning({
    required BuildContext context,
    required double height,
    required double width,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 300.h,
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
            margin: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              AppStringRes.newWithRunning,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'roboto',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900),
            ),
          ),
          buttonSquareNoIcon(
            height: height,
            width: width,
            onPressed: () {
              BlocProvider.of<RunnerDataBloc>(context)
                  .add(runner_data_bloc.SelectRunnerType(true, false));
            },
            color: _isUserBeginnerSelected ? redColor : Colors.white,
            title: AppStringRes.yesIamNewbie,
            underButtonTitle: AppStringRes.averagePaceAndWeeklyDistance,
            textColor: _isUserBeginnerSelected ? Colors.white : Colors.black,
          ),
          buttonSquareNoIcon(
            height: height,
            width: width,
            onPressed: () {
              BlocProvider.of<RunnerDataBloc>(context)
                  .add(runner_data_bloc.SelectRunnerType(false, true));
            },
            color: _isUserHaveRunSelected ? redColor : Colors.white,
            title: AppStringRes.nopeIRun,
            underButtonTitle: AppStringRes.pleaseProvideYourRunningMetrics,
            textColor: _isUserHaveRunSelected ? Colors.white : Colors.black,
          ),
          SizedBox(
            height: height * 0.1,
            child: Visibility(
              visible: _isUserBeginnerSelected || _isUserHaveRunSelected,
              child: buttonSquareNoIcon(
                height: height,
                width: width * 0.2,
                onPressed: () async {
                  if (_isUserBeginnerSelected) {
                    await PreferenceUtils.setIsUserUnitInKM(isKM);
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
                  } else if (_isUserHaveRunSelected) {
                    await PreferenceUtils.setPageRout('NewRunner');
                    await _pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.ease);
                  }
                },
                color: redColor,
                title: 'NEXT   ->',
                underButtonTitle: '',
                textColor: Colors.white,
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
          children: <Widget>[
            const SizedBox(
              height: 15.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppStringRes.provideAdditionalInformation,
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
              title: AppStringRes.pace,
              context: context,
              dialogTitle: AppStringRes.pace,
              dialogText: AppStringRes.paceText,
              timePerKM: '${getFormattedPaceTime(pace:_currentPaceValue / 60)} ${isKM ? 'min/km' : 'min/mile'}',
              unit: isKM ? 'km' : 'mile',
              kmPerHour: (60 * 60) / _currentPaceValue,
              minValue: (isKM ? 2.01 : 3) * 60,
              maxValue: (isKM ? 11 : 18) * 60,
              sliderValue: _currentPaceValue,
              onChanged: (double value) {
                setState(() {
                  _currentPaceValue = value;
                });
              },
            ),
            seekBarWeekly(
              title: AppStringRes.weeklyDistance,
              context: context,
              dialogTitle: AppStringRes.weeklyDistance,
              dialogText: AppStringRes.weeklyDistanceText,
              timePerKM: _currentWeeklyDistanceValue,
              unit: isKM ? 'km' : 'mile',
              minValue: isKM ? 4 : 2.5,
              maxValue: isKM ? 150 : 94,
              sliderValue: _currentWeeklyDistanceValue,
              onChanged: (double value) {
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
                AppStringRes.showPaceAndDistancesIn,
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
                children: <Widget>[
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
                AppStringRes.howOftenDoYouRun,
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
                children: <Widget>[
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
                  SizedBox(
                    width: 80.w,
                    height: 50.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                          AppStringRes.timesPerWeek,
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
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildRoundedButton(
                      label: AppStringRes.letRun,
                      width: width,
                      height: 40.h,
                      controller: goController,
                      textColor: Colors.white,
                      backColor: redColor,
                      onTap: () async {
                        goController.reset();
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
    _runnerDataBloc.close();
    _pageController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }
}
