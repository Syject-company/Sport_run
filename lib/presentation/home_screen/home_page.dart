import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/data/models/battle_request_model.dart';
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
  final _applyMessageController = RoundedLoadingButtonController();
  final _applyBattleController = RoundedLoadingButtonController();
  final _battleNameController = TextEditingController();
  final _messageController = TextEditingController();

  DrawerItems selectedDrawerItem = DrawerItems.Connect;
  DrawersType selectedDrawersType = DrawersType.FilterDrawer;

  HomeApi homeApi = HomeApi();
  ConnectApi connectApi = ConnectApi();

  String pageTitle = 'Connect';
  String messageToOpponent = 'Come as you are, join the run!';
  String dateAndTime = '';
  late String dateAndTimeForUser;

  late Future<UserModel?> _userModel;
  late Future<List<ConnectUsersModel>?> _users;
  ConnectUsersModel? _userBattleModel;
  late FirebaseMessaging _messaging;
  late RangeValues _currentRangeValuesPace;
  late RangeValues _currentRangeValuesWeekly;

  bool _isNeedFilter = false;
  bool _isNeedToOpenMessageDrawer = false;
  late bool isKM;

  int _countOfRuns = 1;
  int _selectedMessageIndex = 1000;

  double _currentDistanceValue = 300;

  @override
  void initState() {
    super.initState();
    prepareData();
  }

  void prepareData() {
    _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((token) {
      homeApi.sendFireBaseToken(tokenFireBase: token ?? '');
      print('Firebase token: $token');
    });

    //NOte: when app is terminated
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        var dd = message.data['title'];
      }
    });
    //TODO: to get the user model when battle is created
    //NOte: when app is in background state
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      var dd = event.data['title'];
      print('onMessageOpenedApp: $dd');
    });

    dateAndTimeForUser =
        getFormattedDateForUser(date: DateTime.now(), time: TimeOfDay.now());
    dateAndTime = getFormattedDate(date: DateTime.now(), time: TimeOfDay.now());
    updateRangeValuesAndUnit();
    _userModel = homeApi.getUserModel();
    _userModel.then((value) {
      if (value != null) {
        PreferenceUtils.setCurrentUserModel(value);
      }
    });
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
            _userBattleModel = state.userModel;
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
            _selectedMessageIndex = 1000;
            _messageController.text = '';
          } else if (state is MessageToOpponentDrawerIsSent) {
            _applyMessageController.reset();
            messageToOpponent = state.message;
            BlocProvider.of<HomeBloc>(context)
                .add(home_bloc.OpenCloseMessageDrawer());
          } else if (state is SelectedMessageToOpponent) {
            _selectedMessageIndex = state.messageIndex;
          } else if (state is BattleCreated) {
            await homeApi
                .createBattle(
                    model: BattleRequestModel(
              dateTime: dateAndTime,
              battleName: _battleNameController.text.isNotEmpty
                  ? _battleNameController.text
                  : null,
              distance: _currentDistanceValue / 60,
              message: messageToOpponent,
              opponentId: _userBattleModel!.id,
            ))
                .then((value) async {
              if (value) {
                final currentUserModel = PreferenceUtils.getCurrentUserModel();
                if (_keyScaffold.currentState != null &&
                    _keyScaffold.currentState!.isEndDrawerOpen) {
                  Navigator.of(context).pop();
                }
                battleCreated(
                  context: context,
                  height: height,
                  width: width,
                  currentUserName: currentUserModel.nickName ?? 'NickName',
                  currentUserPhoto: currentUserModel.photoLink,
                  opponentUserName: _userBattleModel?.nickName ?? 'NickName',
                  opponentUserPhoto: _userBattleModel?.photoLink,
                );

                Timer(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
              } else {
                await Fluttertoast.showToast(
                    msg: 'Unexpected error happened',
                    fontSize: 16.0,
                    gravity: ToastGravity.CENTER);
              }
            });
            _applyBattleController.reset();
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
                _isNeedToOpenMessageDrawer = false;
                _currentDistanceValue = 300;
                _battleNameController.text = '';
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
            drawer: _homeDrawer(
              context: context,
              width: width,
              height: height,
            ),
            endDrawer: selectedDrawerItem == DrawerItems.Connect
                ? ConditionalSwitch.single<DrawersType>(
                    context: context,
                    valueBuilder: (context) => selectedDrawersType,
                    caseBuilders: {
                      DrawersType.FilterDrawer: (context) =>
                          _connectFilterDrawer(
                              context: context, width: width, height: height),
                      DrawersType.BattleDrawer: (context) {
                        return _createBattleDrawer(
                          context: context,
                          model: _userBattleModel,
                          width: width,
                          height: height,
                        );
                      },
                    },
                    fallbackBuilder: (context) => _connectFilterDrawer(
                        context: context, width: width, height: height),
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

  Widget _connectFilterDrawer(
      {required BuildContext context,
      required double width,
      required double height}) {
    return filterDrawer(
      context: context,
      width: width,
      height: height,
      isNeedFilter: _isNeedFilter,
      onSwitchFilter: (value) {
        BlocProvider.of<HomeBloc>(context)
            .add(home_bloc.SwitchIsNeedFilter(isNeedFilter: value));
      },
      valuePaceStart: _currentRangeValuesPace.start,
      valuePaceEnd: _currentRangeValuesPace.end,
      isKM: isKM,
      currentRangeValuesPace: _currentRangeValuesPace,
      onRangePaceChanged: (values) {
        setState(() {
          _currentRangeValuesPace = values;
        });
      },
      valueWeeklyStart: _currentRangeValuesWeekly.start,
      valueWeeklyEnd: _currentRangeValuesWeekly.end,
      currentRangeValuesWeekly: _currentRangeValuesWeekly,
      onRangeWeeklyChanged: (values) {
        setState(() {
          _currentRangeValuesWeekly = values;
        });
      },
      onTapMinusRuns: () {
        if (_countOfRuns > 1) {
          BlocProvider.of<HomeBloc>(context)
              .add(home_bloc.SelectTimesPerWeek(_countOfRuns -= 1));
        }
      },
      countOfRuns: _countOfRuns,
      onTapPlusRuns: () {
        if (_countOfRuns < 7) {
          BlocProvider.of<HomeBloc>(context)
              .add(home_bloc.SelectTimesPerWeek(_countOfRuns += 1));
        }
      },
      applyController: _applyController,
      onTapApply: () {
        BlocProvider.of<HomeBloc>(context).add(home_bloc.SelectConnectFilters(
          _isNeedFilter,
          _currentRangeValuesPace.start,
          _currentRangeValuesPace.end,
          _currentRangeValuesWeekly.start,
          _currentRangeValuesWeekly.end,
          _countOfRuns,
        ));
        _applyController.reset();
      },
      onTapCancel: () {
        if (_keyScaffold.currentState != null &&
            _keyScaffold.currentState!.isEndDrawerOpen) {
          Navigator.of(context).pop();
        }
      },
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

////////////////////////////////////////////////////
  Widget _homeDrawer(
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

/////////////////////////////////
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
          ? battleDrawer(
              height: height,
              width: width,
              model: model,
              battleNameController: _battleNameController,
              context: context,
              currentDistanceValue: _currentDistanceValue,
              isKM: isKM,
              onSeekChanged: (value) {
                setState(() {
                  _currentDistanceValue = value;
                });
              },
              onTapGetDatePicker: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(home_bloc.GetDatePicker());
              },
              dateAndTimeForUser: dateAndTimeForUser,
              onTapOpenCloseMessageDrawer: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(home_bloc.OpenCloseMessageDrawer());
              },
              messageToOpponent: messageToOpponent,
              applyBattleController: _applyBattleController,
              onTapApplyBattle: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(home_bloc.CreateBattle());
              },
              onTapCancelBattle: () {
                if (_keyScaffold.currentState != null &&
                    _keyScaffold.currentState!.isEndDrawerOpen) {
                  Navigator.of(context).pop();
                }
              },
            )
          : messageToOpponentDrawer(
              context: context,
              width: width,
              height: height,
              onTapOpenCloseMessageDrawer: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(home_bloc.OpenCloseMessageDrawer());
              },
              onTapSelectMessageToOpponent: (index) {
                BlocProvider.of<HomeBloc>(context).add(
                  home_bloc.SelectMessageToOpponent(index),
                );
              },
              onTapApplyMessage: () async {
                if (_messageController.text.isNotEmpty ||
                    _selectedMessageIndex != 1000) {
                  BlocProvider.of<HomeBloc>(context).add(
                      home_bloc.SendMessageToOpponent(
                          _messageController.text.isNotEmpty
                              ? _messageController.text
                              : messagesToOpponent[_selectedMessageIndex]));
                } else {
                  _applyMessageController.reset();
                  await Fluttertoast.showToast(
                      msg: 'No message selected!',
                      fontSize: 16.0,
                      gravity: ToastGravity.CENTER);
                }
              },
              messageController: _messageController,
              selectedMessageIndex: _selectedMessageIndex,
              applyMessageController: _applyMessageController,
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
