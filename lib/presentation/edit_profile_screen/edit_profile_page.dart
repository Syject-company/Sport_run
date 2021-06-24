import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/data/models/user_profile_request_model.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_bloc/bloc.dart'
    as edit_profile_bloc;
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_bloc/edit_profile_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/strings.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/editProfile'
class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key, this.userModel, required this.userDataListener})
      : super(key: key);

  final UserModel? userModel;
  final VoidCallback userDataListener;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _mottoController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _saveController = RoundedLoadingButtonController();

  final _homeApi = HomeApi();

  int _countOfRuns = 1;

  num _currentPaceValue = 300;
  num _currentWeeklyDistanceValue = 30;

  bool _isKM = true;

  @override
  void initState() {
    super.initState();
    _setUserData(data: widget.userModel!);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: BlocProvider<EditProfileBloc>(
        create: (final context) => EditProfileBloc(),
        child: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (final context, final state) async {
            if (state is KmOrMileIsSelected) {
              _isKM = state.isKM;
              _isKM ? _currentPaceValue = 300 : _currentPaceValue = 480;
              _isKM
                  ? _currentWeeklyDistanceValue = 30
                  : _currentWeeklyDistanceValue = 18.6;
            } else if (state is TimesPerWeekIsSelected) {
              _countOfRuns = state.timesPerWeek;
            } else if (state is UserDataSaved) {
              final model = UserProfileRequestModel(
                moto: _mottoController.text,
                nickName: _nameController.text,
                pace: _currentPaceValue,
                weeklyDistance: _currentWeeklyDistanceValue,
                isMetric: _isKM,
                workoutsPerWeek: _countOfRuns,
                description: _bioController.text,
              );
              await _homeApi.saveUserModel(model: model).then((value) async {
                if (value) {
                  _saveController.success();
                  widget.userDataListener();
                  Navigator.of(context).pop();
                } else {
                  _saveController.reset();
                  await Fluttertoast.showToast(
                      msg: 'Unexpected error happened',
                      fontSize: 16.0,
                      gravity: ToastGravity.CENTER);
                }
              });
            }
            BlocProvider.of<EditProfileBloc>(context)
                .add(edit_profile_bloc.UpdateState());
          },
          child: BlocBuilder<EditProfileBloc, EditProfileState>(
              builder: (final context, final state) {
            return Scaffold(
              body: Container(
                width: width,
                height: height,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: inputTextField(
                          controller: _mottoController,
                          errorText: null,
                          hintText: 'Motto',
                          isCounterShown: true,
                          maxLength: 35,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: inputTextField(
                          controller: _nameController,
                          errorText: null,
                          hintText: 'Name',
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: inputTextField(
                          controller: _emailController,
                          errorText: null,
                          hintText: 'E-mail address',
                          icon: Icons.email,
                          isReadOnly: true,
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      const Divider(
                        height: 5,
                        endIndent: 3.0,
                        indent: 3.0,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      _additionalInformation(
                        context: context,
                        height: height,
                        width: width,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      const Divider(
                        height: 5,
                        endIndent: 3.0,
                        indent: 3.0,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: inputTextField(
                          controller: _bioController,
                          errorText: null,
                          hintText: 'Bio',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: buildRoundedButton(
                          label: 'Save'.toUpperCase(),
                          width: width,
                          height: 40.h,
                          controller: _saveController,
                          textColor: Colors.white,
                          backColor: redColor,
                          onTap: () async {
                            BlocProvider.of<EditProfileBloc>(context)
                                .add(edit_profile_bloc.SaveUserData());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(double.maxFinite, 40.h),
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Text(
                              'Cancel'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'roboto',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _additionalInformation(
      {required BuildContext context,
      required double height,
      required double width}) {
    return Column(
      children: [
        seekBarPace(
          title: 'Pace',
          context: context,
          dialogTitle: 'Pace',
          dialogText: paceText,
          timePerKM: _currentPaceValue.toDouble(),
          unit: _isKM ? 'km' : 'mile',
          kmPerHour: (60 * 60) / _currentPaceValue,
          minValue: (_isKM ? 2 : 3) * 60,
          maxValue: (_isKM ? 11 : 18) * 60,
          sliderValue: _currentPaceValue.toDouble(),
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
          timePerKM: _currentWeeklyDistanceValue.toDouble(),
          unit: _isKM ? 'km' : 'mile',
          minValue: _isKM ? 4 : 2.5,
          maxValue: _isKM ? 150 : 94,
          sliderValue: _currentWeeklyDistanceValue.toDouble(),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonNoIcon(
                title: 'KM',
                color: _isKM ? redColor : grayColor,
                textColor: _isKM ? Colors.white : Colors.black,
                width: width * 0.35,
                height: height * 0.07,
                onPressed: () async {
                  BlocProvider.of<EditProfileBloc>(context)
                      .add(edit_profile_bloc.SelectKmOrMile(true));
                },
              ),
              buttonNoIcon(
                title: 'MI',
                color: _isKM ? grayColor : redColor,
                textColor: _isKM ? Colors.black : Colors.white,
                width: width * 0.35,
                height: height * 0.07,
                onPressed: () async {
                  BlocProvider.of<EditProfileBloc>(context)
                      .add(edit_profile_bloc.SelectKmOrMile(false));
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    BlocProvider.of<EditProfileBloc>(context).add(
                        edit_profile_bloc.SelectTimesPerWeek(
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
                    BlocProvider.of<EditProfileBloc>(context).add(
                        edit_profile_bloc.SelectTimesPerWeek(
                            _countOfRuns += 1));
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _setUserData({required UserModel data}) {
    _mottoController.text = data.moto ?? 'Here will be your Motto.';
    _nameController.text = data.nickName ?? 'NickName';
    _emailController.text = data.email ?? 'email@gmail.com';
    _bioController.text = data.description ?? 'Here will be your Biography.';
    _isKM = data.isMetric;
    _currentPaceValue = data.pace.toDouble();
    _currentWeeklyDistanceValue = data.weeklyDistance.toDouble();
    _countOfRuns = data.workoutsPerWeek.toInt();
  }

  @override
  void dispose() {
    _mottoController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
