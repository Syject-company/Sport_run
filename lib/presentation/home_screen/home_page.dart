import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/utils/extension.dart' show DateTimeExtension;
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/apis.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/connect_screen/connect_page.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_page.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_page.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/bloc.dart'
    as home_bloc;
import 'package:one2one_run/presentation/home_screen/home_bloc/home_bloc.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/home_state.dart';
import 'package:one2one_run/presentation/interact_screen/interact_page.dart';
import 'package:one2one_run/presentation/profile_screen/profile_page.dart';
import 'package:one2one_run/presentation/settings_screen/settings_page.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/resources/strings.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:one2one_run/utils/no_glow_scroll_behavior.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/home'
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _keyScaffold = GlobalKey<ScaffoldState>();

  final _pageController = PageController();
  final _applyController = RoundedLoadingButtonController();
  final _refreshController = RoundedLoadingButtonController();
  final _applyBattleController = RoundedLoadingButtonController();
  final _battleNameController = TextEditingController();
  final _messageController = TextEditingController();

  DrawerItems selectedDrawerItem = DrawerItems.Connect;
  DrawersType selectedDrawersType = DrawersType.FilterDrawer;

  HomeApi homeApi = HomeApi();
  ConnectApi connectApi = ConnectApi();

  String pageTitle = 'Connect';
  String messageToOpponent = 'It will be a piece of cake!';
  String dateAndTime = '';
  late String dateAndTimeForUser;

  late Future<UserModel?> _userModel;
  late FirebaseMessaging messaging;
  late Future<List<ConnectUsersModel>?> _users;
  late RangeValues _currentRangeValuesPace;
  late RangeValues _currentRangeValuesWeekly;

  ConnectUsersModel? userBattleModel;

  bool _isNeedFilter = false;
  bool _isNeedToOpenMessageDrawer = false;
  bool isNeedToOpenBattleDrawer = false;
  late bool isKM;

  int _countOfRuns = 1;

  double _currentDistanceValue = 300;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('Firebase token: $value');
    });
    dateAndTimeForUser =
        getFormattedDateForUser(date: DateTime.now(), time: TimeOfDay.now());
    updateRangeValuesAndUnit();
    _userModel = homeApi.getUserModel();
    _users = getUsers(isFilterIncluded: _isNeedFilter);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;
    return BlocProvider<HomeBloc>(
      create: (final context) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (final context, final state) async {
          if (state is NavigatedToPage) {
            if (_keyScaffold.currentState != null &&
                _keyScaffold.currentState!.isDrawerOpen) {
              Navigator.of(context).pop();
            }
            await _pageController
                .animateToPage(state.pageIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn)
                .then(
                  (value) => BlocProvider.of<HomeBloc>(context)
                      .add(home_bloc.SwitchIsNeedFilter(isNeedFilter: false)),
                );
          } else if (state is UserDataUpdated) {
            updateRangeValuesAndUnit();
            _userModel = homeApi.getUserModel();
          } else if (state is SwitchedIsNeedFilter) {
            _isNeedFilter = state.isNeedFilter;
            if (!_isNeedFilter) {
              _users = getUsers(isFilterIncluded: _isNeedFilter);
            }
          } else if (state is BattleDrawerIsOpen) {
            dateAndTimeForUser = getFormattedDateForUser(
                date: DateTime.now(), time: TimeOfDay.now());
            userBattleModel = state.userModel;
            selectedDrawersType = DrawersType.BattleDrawer;
            if (_keyScaffold.currentState != null &&
                !_keyScaffold.currentState!.isEndDrawerOpen) {
              _keyScaffold.currentState!.openEndDrawer();
            }
          } else if (state is TimesPerWeekIsSelected) {
            _countOfRuns = state.timesPerWeek;
          } else if (state is SelectedConnectFilters) {
            _users = getUsers(
              isFilterIncluded: state.isFilterIncluded,
              paceFrom: state.paceFrom / 60,
              paceTo: state.paceTo / 60,
              weeklyDistanceFrom: isKM
                  ? double.parse(state.weeklyDistanceFrom.toStringAsFixed(0))
                  : double.parse(state.weeklyDistanceFrom.toStringAsFixed(1)),
              weeklyDistanceTo: isKM
                  ? double.parse(state.weeklyDistanceTo.toStringAsFixed(0))
                  : double.parse(state.weeklyDistanceTo.toStringAsFixed(1)),
              workoutsPerWeek: state.workoutsPerWeek,
            );
            if (_keyScaffold.currentState != null &&
                _keyScaffold.currentState!.isEndDrawerOpen) {
              Navigator.of(context).pop();
            }
          } else if (state is FilterDrawerIsOpen) {
            selectedDrawersType = DrawersType.FilterDrawer;
          } else if (state is GotDatePicker) {
            await getDate(context: context).then((date) async {
              if (date != null) {
                final time = await getTime(context: context);
                if (time != null) {
                  dateAndTime = getFormattedDate(date: date, time: time);
                  dateAndTimeForUser =
                      getFormattedDateForUser(date: date, time: time);
                  print('Date: $dateAndTime');
                }
              }
            });
          } else if (state is MessageDrawerIsOpenOrClose) {
            _isNeedToOpenMessageDrawer = !_isNeedToOpenMessageDrawer;
          } else if (state is MessageToOpponentDrawerIsSent) {
            messageToOpponent = state.message;
          }
          BlocProvider.of<HomeBloc>(context).add(home_bloc.UpdateState());
        },
        child: BlocBuilder<HomeBloc, HomeState>(
            builder: (final context, final state) {
          return Scaffold(
            key: _keyScaffold,
            backgroundColor: homeBackground,
            onEndDrawerChanged: (value) {
              if (!value && selectedDrawersType != DrawersType.FilterDrawer) {
                Timer(const Duration(milliseconds: 300), () {
                  BlocProvider.of<HomeBloc>(context)
                      .add(home_bloc.OpenFilterDrawer());
                });
              }
            },
            appBar: AppBar(
              title: Text(
                pageTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
              backgroundColor: colorPrimary,
              actions: selectedDrawerItem == DrawerItems.Profile
                  ? appBarButtons(
                      isNeedSecondButton: true,
                      firstButtonIcon: const Icon(Icons.edit),
                      onTapFirstButton: () async {
                        await navigateToEditProfile(context: context);
                      },
                      secondButtonIcon: const Icon(Icons.logout),
                      onTapSecondButton: () {
                        dialog(
                            context: context,
                            Title: 'Logout',
                            text: 'Are you sure you want to logout?',
                            applyButtonText: 'Logout',
                            cancelButtonText: 'Cancel',
                            onApplyPressed: () async {
                              await PreferenceUtils.setIsUserAuthenticated(
                                      false)
                                  .then((value) {
                                PreferenceUtils.setPageRout('Register');
                                Navigator.of(context).pushReplacementNamed(
                                    Constants.registerRoute);
                              });
                            });
                      },
                    )
                  : selectedDrawerItem == DrawerItems.Connect
                      ? appBarButtons(
                          isNeedSecondButton: false,
                          firstButtonIcon:
                              const Icon(Icons.filter_alt_outlined),
                          onTapFirstButton: () async {
                            if (_keyScaffold.currentState != null &&
                                !_keyScaffold.currentState!.isEndDrawerOpen) {
                              _keyScaffold.currentState!.openEndDrawer();
                            }
                          },
                          secondButtonIcon: const Icon(Icons.search),
                          onTapSecondButton: () {},
                        )
                      : null,
            ),
            drawer: _drawer(
              context: context,
              width: width,
              height: height,
            ),
            endDrawer: selectedDrawerItem == DrawerItems.Connect
                ? ConditionalSwitch.single<DrawersType>(
                    context: context,
                    valueBuilder: (context) => selectedDrawersType,
                    caseBuilders: {
                      DrawersType.FilterDrawer: (context) => _filterDrawer(
                            context: context,
                            width: width,
                            height: height,
                          ),
                      DrawersType.BattleDrawer: (context) {
                        return _createBattleDrawer(
                          context: context,
                          model: userBattleModel,
                          width: width,
                          height: height,
                        );
                      },
                    },
                    fallbackBuilder: (context) => _filterDrawer(
                      context: context,
                      width: width,
                      height: height,
                    ),
                  )
                : null,
            body: SafeArea(
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      FutureBuilder<List<ConnectUsersModel>?>(
                          future: _users,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return snapshot.data!.isNotEmpty
                                  ? ConnectPage(
                                      users: snapshot.data!,
                                      onBattleTap: (userModel) {
                                        BlocProvider.of<HomeBloc>(context).add(
                                            home_bloc.OpenBattleDrawer(
                                                userModel));
                                      },
                                    )
                                  : Container(
                                      height: height,
                                      width: width,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            noFiltersBackground,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildRoundedButton(
                                              label: 'Refresh'.toUpperCase(),
                                              width: width,
                                              height: 40.h,
                                              buttonTextSize: 14.0,
                                              controller: _refreshController,
                                              textColor: Colors.white,
                                              backColor: redColor,
                                              onTap: () async {
                                                BlocProvider.of<HomeBloc>(
                                                        context)
                                                    .add(home_bloc
                                                        .SelectConnectFilters(
                                                  _isNeedFilter,
                                                  _currentRangeValuesPace.start,
                                                  _currentRangeValuesPace.end,
                                                  _currentRangeValuesWeekly
                                                      .start,
                                                  _currentRangeValuesWeekly.end,
                                                  _countOfRuns,
                                                ));
                                                _refreshController.reset();
                                              },
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            buttonNoIcon(
                                              title: 'Disable filters'
                                                  .toUpperCase(),
                                              color: Colors.transparent,
                                              height: 40.h,
                                              textColor: Colors.black,
                                              buttonTextSize: 14.0,
                                              shadowColor: Colors.transparent,
                                              onPressed: () {
                                                BlocProvider.of<HomeBloc>(
                                                        context)
                                                    .add(home_bloc
                                                        .SwitchIsNeedFilter(
                                                            isNeedFilter:
                                                                false));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            } else {
                              return Container(
                                color: Colors.white,
                                width: width,
                                height: height,
                                child: progressIndicator(),
                              );
                            }
                          }),
                      InteractPage(),
                      EnjoyPage(),
                      ProfilePage(
                        userDataListener: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.UpdateUserData());
                        },
                      ),
                      SettingsPage(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> navigateToEditProfile({required BuildContext context}) async {
    await homeApi.getUserModel().then((userModel) async {
      if (userModel != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EditProfilePage(
                    userModel: userModel,
                    userDataListener: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(home_bloc.UpdateUserData());
                    },
                  )),
        );
      } else {
        await Fluttertoast.showToast(
            msg: 'Unexpected error happened',
            fontSize: 16.0,
            gravity: ToastGravity.CENTER);
      }
    });
  }

  List<Widget> appBarButtons({
    required Widget firstButtonIcon,
    required Widget secondButtonIcon,
    required VoidCallback onTapFirstButton,
    required VoidCallback onTapSecondButton,
    required bool isNeedSecondButton,
  }) {
    return [
      IconButton(
        icon: firstButtonIcon,
        onPressed: onTapFirstButton,
        iconSize: 20,
      ),
      isNeedSecondButton
          ? IconButton(
              icon: secondButtonIcon,
              onPressed: onTapSecondButton,
              iconSize: 20,
            )
          : Container(),
    ];
  }

  Widget _drawer(
      {required BuildContext context,
      required double height,
      required double width}) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: width * 0.15),
      child: Drawer(
        child: Container(
          height: height,
          color: Colors.white,
          child: FutureBuilder<UserModel?>(
              future: _userModel,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 172.h,
                        width: width,
                        color: const Color(0xff717171).withOpacity(0.7),
                        child: Stack(
                          children: [
                            ClipRRect(
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: snapshot.data!.photoLink != null
                                    ? Image.network(
                                        snapshot.data!.photoLink!,
                                        height: 172.h,
                                        width: width,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        defaultProfileImage,
                                        height: 172.h,
                                        width: width,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.05, left: width * 0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      height: 64.h,
                                      width: 64.h,
                                      child: CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: snapshot
                                                    .data!.photoLink !=
                                                null
                                            ? NetworkImage(
                                                    snapshot.data!.photoLink!)
                                                as ImageProvider
                                            : AssetImage(
                                                defaultProfileImage,
                                              ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.03, top: height * 0.01),
                                    child: Text(
                                      snapshot.data!.nickName ?? 'Nickname',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'roboto',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.03, top: 5),
                                    child: Text(
                                      snapshot.data!.email ?? 'email@gmail.com',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'roboto',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      _drawerItem(
                        label: 'Connect',
                        icon: connectIcon,
                        iconColor: selectedDrawerItem == DrawerItems.Connect
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            selectedDrawerItem == DrawerItems.Connect
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          selectedDrawerItem = DrawerItems.Connect;
                          pageTitle = 'Connect';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 0));
                        },
                      ),
                      _drawerItem(
                        label: 'Interact',
                        icon: interactIcon,
                        iconColor: selectedDrawerItem == DrawerItems.Interact
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            selectedDrawerItem == DrawerItems.Interact
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          selectedDrawerItem = DrawerItems.Interact;
                          pageTitle = 'Interact';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 1));
                        },
                      ),
                      _drawerItem(
                        label: 'Enjoy',
                        icon: enjoyIcon,
                        width: 24.0,
                        height: 24.0,
                        iconColor: selectedDrawerItem == DrawerItems.Enjoy
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            selectedDrawerItem == DrawerItems.Enjoy
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          selectedDrawerItem = DrawerItems.Enjoy;
                          pageTitle = 'Enjoy';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 2));
                        },
                      ),
                      _drawerItem(
                        label: 'Profile',
                        icon: profileIcon,
                        iconColor: selectedDrawerItem == DrawerItems.Profile
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            selectedDrawerItem == DrawerItems.Profile
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          pageTitle = 'Profile';
                          selectedDrawerItem = DrawerItems.Profile;
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 3));
                        },
                      ),
                      _drawerItem(
                        label: 'Settings',
                        icon: settingsIcon,
                        iconColor: selectedDrawerItem == DrawerItems.Settings
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            selectedDrawerItem == DrawerItems.Settings
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          selectedDrawerItem = DrawerItems.Settings;
                          pageTitle = 'Settings';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 4));
                        },
                      ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    width: width,
                    height: height,
                    child: progressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required String label,
    required String icon,
    required VoidCallback onPressed,
    double height = 22.0,
    double width = 22.0,
    Color iconColor = const Color(0xff9F9F9F),
    Color selectedItemColor = Colors.transparent,
  }) {
    return Container(
      color: selectedItemColor,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: EdgeInsets.only(left: width * 0.04),
        child: TextButton(
          onPressed: onPressed,
          child: Container(
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: height,
                  width: width,
                  fit: BoxFit.fill,
                  color: iconColor,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterDrawer(
      {required BuildContext context,
      required double height,
      required double width}) {
    return Container(
      width: width,
      margin: EdgeInsets.only(left: width * 0.15),
      color: Colors.white,
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Text(
                  'Filters',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${!_isNeedFilter ? 'Enable' : 'Disable'} filters',
                      style: TextStyle(
                          color: const Color(0xff838383),
                          fontSize: 13.sp,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: _isNeedFilter,
                      activeColor: const Color(0xffc1ff9b),
                      onChanged: (val) {
                        BlocProvider.of<HomeBloc>(context).add(
                            home_bloc.SwitchIsNeedFilter(isNeedFilter: val));
                      },
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      rangeSeekBarPace(
                        title: 'Pace',
                        context: context,
                        dialogTitle: 'Pace',
                        dialogText: paceText,
                        startTimePerKM: _currentRangeValuesPace.start,
                        endTimePerKM: _currentRangeValuesPace.end,
                        unit: isKM ? 'km' : 'mile',
                        kmPerHour: (60 * 60) / _currentRangeValuesPace.end,
                        minValue: (isKM ? 2 : 3) * 60,
                        maxValue: (isKM ? 11 : 18) * 60,
                        rangeValue: _currentRangeValuesPace,
                        onRangeChanged: (value) {
                          setState(() {
                            _currentRangeValuesPace = value;
                          });
                        },
                      ),
                      rangeSeekBarWeekly(
                        title: 'Weekly distance',
                        context: context,
                        dialogTitle: 'Weekly distance',
                        dialogText: weeklyDistanceText,
                        endTimePerKM: _currentRangeValuesWeekly.end,
                        startTimePerKM: _currentRangeValuesWeekly.start,
                        unit: isKM ? 'km' : 'mile',
                        minValue: isKM ? 4 : 2.5,
                        maxValue: isKM ? 150 : 94,
                        rangeValue: _currentRangeValuesWeekly,
                        onChanged: (value) {
                          setState(() {
                            _currentRangeValuesWeekly = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
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
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buttonNoIcon(
                              title: '-',
                              color: grayColor,
                              textColor: Colors.black,
                              width: width * 0.17,
                              height: 30.h,
                              onPressed: () async {
                                if (_countOfRuns > 1) {
                                  BlocProvider.of<HomeBloc>(context).add(
                                      home_bloc.SelectTimesPerWeek(
                                          _countOfRuns -= 1));
                                }
                              },
                            ),
                            Container(
                              width: 80.w,
                              height: 50.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              width: width * 0.17,
                              height: 30.h,
                              onPressed: () async {
                                if (_countOfRuns < 7) {
                                  BlocProvider.of<HomeBloc>(context).add(
                                      home_bloc.SelectTimesPerWeek(
                                          _countOfRuns += 1));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                        margin: EdgeInsets.only(top: height * 0.25),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: buildRoundedButton(
                                label: 'APPLY',
                                width: width,
                                height: 40.h,
                                buttonTextSize: 14.0,
                                controller: _applyController,
                                textColor: Colors.white,
                                backColor: redColor,
                                onTap: () async {
                                  BlocProvider.of<HomeBloc>(context)
                                      .add(home_bloc.SelectConnectFilters(
                                    _isNeedFilter,
                                    _currentRangeValuesPace.start,
                                    _currentRangeValuesPace.end,
                                    _currentRangeValuesWeekly.start,
                                    _currentRangeValuesWeekly.end,
                                    _countOfRuns,
                                  ));
                                  _applyController.reset();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: buttonNoIcon(
                                title: 'Cancel',
                                color: Colors.transparent,
                                height: 40.h,
                                textColor: Colors.black,
                                buttonTextSize: 14.0,
                                shadowColor: Colors.transparent,
                                onPressed: () {
                                  if (_keyScaffold.currentState != null &&
                                      _keyScaffold
                                          .currentState!.isEndDrawerOpen) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !_isNeedFilter,
                    child: Container(
                      width: width,
                      height: height - (height * 0.07),
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createBattleDrawer(
      {required BuildContext context,
      required ConnectUsersModel? model,
      required double height,
      required double width}) {
    return Container(
      width: width,
      margin: EdgeInsets.only(left: width * 0.15),
      color: Colors.white,
      child: !_isNeedToOpenMessageDrawer
          ? Drawer(
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Row(
                        children: [
                          Image.asset(
                            interactIcon,
                            height: 12.0,
                            width: 12.0,
                            fit: BoxFit.contain,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Battle',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.sp,
                                fontFamily: 'roboto',
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Text(
                        'Opponent',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      height: height * 0.12,
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xffCDCDCD).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: height * 0.08,
                            width: height * 0.08,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 80,
                              backgroundImage: model?.photoLink == null
                                  ? AssetImage(
                                      defaultProfileImage,
                                    ) as ImageProvider
                                  : NetworkImage(model!.photoLink!),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model?.nickName ?? 'NickName',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    rankIcon,
                                    height: height * 0.015,
                                    width: height * 0.015,
                                    fit: BoxFit.fill,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 7.0,
                                  ),
                                  Text(
                                    'Rank ${model?.rank}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                      ),
                      child: inputTextField(
                        controller: _battleNameController,
                        errorText: null,
                        maxLength: 25,
                        isCounterShown: true,
                        hintText: 'Battle vs ${model?.nickName}',
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    seekBarPace(
                      title: 'Distance',
                      context: context,
                      dialogTitle: 'Distance',
                      dialogText: distanceText,
                      timePerKM: _currentDistanceValue,
                      unit: isKM ? 'km' : 'mile',
                      kmPerHour: (60 * 60) / _currentDistanceValue,
                      minValue: (isKM ? 2 : 3) * 60,
                      maxValue: (isKM ? 11 : 18) * 60,
                      sliderValue: _currentDistanceValue,
                      onChanged: (value) {
                        setState(() {
                          _currentDistanceValue = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: Text(
                        'Deadline date',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, right: width * 0.03),
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.GetDatePicker());
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateAndTimeForUser,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500),
                              ),
                              Image.asset(
                                calendarIcon,
                                height: height * 0.02,
                                width: height * 0.02,
                                fit: BoxFit.contain,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: height * 0.02),
                      child: Text(
                        'Message to opponent',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, right: width * 0.03),
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.OpenCloseMessageDrawer());
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  messageToOpponent,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[400],
                                  size: 24.0,
                                ),
                              ],
                            ),
                            const Divider(
                              height: 5,
                              thickness: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      margin: EdgeInsets.only(top: height * 0.12),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: buildRoundedButton(
                              label: 'APPLY',
                              width: width,
                              height: 40.h,
                              buttonTextSize: 14.0,
                              controller: _applyBattleController,
                              textColor: Colors.white,
                              backColor: redColor,
                              onTap: () async {},
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: buttonNoIcon(
                              title: 'Cancel',
                              color: Colors.transparent,
                              height: 40.h,
                              textColor: Colors.black,
                              buttonTextSize: 14.0,
                              shadowColor: Colors.transparent,
                              onPressed: () {
                                if (_keyScaffold.currentState != null &&
                                    _keyScaffold
                                        .currentState!.isEndDrawerOpen) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _getMessageToOpponentDrawer(
              context: context, width: width, height: height),
    );
  }

  Widget _getMessageToOpponentDrawer(
      {required BuildContext context,
      required double height,
      required double width}) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(home_bloc.OpenCloseMessageDrawer());
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'Message to opponent',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              child: inputTextField(
                controller: _messageController,
                errorText: null,
                maxLength: 30,
                isCounterShown: true,
                hintText: 'My variant',
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.65,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              child: ListView.builder(
                  itemCount: messagesToOpponent.length,
                  itemBuilder: (BuildContext con, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      child: InkWell(
                        onTap: (){

                        },

                        child: Text(
                          messagesToOpponent[index],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ConnectUsersModel>?> getUsers({
    required bool isFilterIncluded,
    double? paceFrom,
    double? paceTo,
    double? weeklyDistanceFrom,
    double? weeklyDistanceTo,
    int? workoutsPerWeek,
  }) async {
    return await connectApi.getUsersConnect(
      isFilterIncluded: isFilterIncluded,
      paceFrom: paceFrom,
      paceTo: paceTo,
      weeklyDistanceFrom: weeklyDistanceFrom,
      weeklyDistanceTo: weeklyDistanceTo,
      workoutsPerWeek: workoutsPerWeek,
    );
  }

  void updateRangeValuesAndUnit() {
    isKM = PreferenceUtils.getIsUserUnitInKM();
    _currentRangeValuesPace =
        RangeValues((isKM ? 2 : 3) * 60, (isKM ? 11 : 18) * 60);
    _currentRangeValuesWeekly =
        RangeValues((isKM ? 4 : 2.5), (isKM ? 150 : 94));
  }

  Future<DateTime?> getDate({required BuildContext context}) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      confirmText: 'APPLY',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> getTime({required BuildContext context}) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      confirmText: 'APPLY',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _battleNameController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
