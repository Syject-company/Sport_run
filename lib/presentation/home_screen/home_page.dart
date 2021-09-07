import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/components/widgets_drawers.dart';
import 'package:one2one_run/data/apis/connect_api.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/models/battle_request_model.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/change_battle_conditions_model.dart';
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
import 'package:one2one_run/resources/strings.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/signal_r.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:one2one_run/utils/extension.dart'
    show DateTimeExtension, ToastExtension, UserData;
import 'package:one2one_run/utils/no_glow_scroll_behavior.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/home'
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController();
  final RoundedLoadingButtonController _applyController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _refreshController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _applyMessageController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _applyBattleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _applyChangeBattleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _acceptBattleController =
      RoundedLoadingButtonController();
  final TextEditingController _battleNameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  DrawerItems _selectedDrawerItem = DrawerItems.Connect;
  DrawersType _selectedDrawersType = DrawersType.FilterDrawer;

  final HomeApi _homeApi = HomeApi();
  final ConnectApi _connectApi = ConnectApi();

  String _pageTitle = 'Connect';
  String _changeBattleDrawerTitle = 'Offer new conditions';
  String _messageToOpponent = 'Come as you are, join the run!';
  String _dateAndTime = '';
  String _battleId = '';
  String _token = '';
  late String _dateAndTimeForUser;
  late String _currentUserId;

  ConnectUsersModel? _userBattleModel;
  late Future<UserModel?> _userModel;
  late Future<List<ConnectUsersModel>?> _users;
  late FirebaseMessaging _messaging;
  late RangeValues _currentRangeValuesPace;
  late RangeValues _currentRangeValuesWeekly;
  late BattleRespondModel _battleRespondModel;

  bool _isNeedFilter = false;
  bool _isNeedToOpenMessageDrawer = false;
  bool _isNeedToOpenChangeBattleDrawer = false;
  late bool _isKM;
  bool _isAppInForeground = true;

  int _countOfRuns = 1;
  int _selectedMessageIndex = 1000;

  double _currentDistanceValue = 5;

  late SignalR _signalR;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    prepareData();
  }

  void prepareData() {
    _token = PreferenceUtils.getUserToken();
    _signalR = SignalR();
    _signalR.initSocketConnection(
        token: _token.replaceFirst(RegExp('Bearer '), ''));
    _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((String? token) {
      _homeApi.sendFireBaseToken(tokenFireBase: token ?? '');
      print('Firebase token: $token');
    });
    _dateAndTimeForUser =
        getFormattedDateForUser(date: DateTime.now(), time: TimeOfDay.now());
    _dateAndTime =
        getFormattedDate(date: DateTime.now(), time: TimeOfDay.now());
    updateRangeValuesAndUnit();
    _userModel = _homeApi.getUserModel();
    _userModel.then((UserModel? value) {
      if (value != null) {
        PreferenceUtils.setCurrentUserModel(value);
        _currentUserId = value.id;
      }
    });
    _users = getUsers(isFilterIncluded: _isNeedFilter);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;
    return BlocProvider<HomeBloc>(
      create: (final BuildContext context) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (final BuildContext context, final HomeState state) async {
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
                  (_) => BlocProvider.of<HomeBloc>(context)
                      .add(home_bloc.SwitchIsNeedFilter(isNeedFilter: false)),
                );
          } else if (state is UserDataUpdated) {
            updateRangeValuesAndUnit();
            _userModel = _homeApi.getUserModel();
          } else if (state is SwitchedIsNeedFilter) {
            _isNeedFilter = state.isNeedFilter;
            if (!_isNeedFilter) {
              _users = getUsers(isFilterIncluded: _isNeedFilter);
            }
          } else if (state is BattleDrawerIsOpen) {
            _dateAndTimeForUser = getFormattedDateForUser(
                date: DateTime.now(), time: TimeOfDay.now());
            _userBattleModel = state.userModel;
            _selectedDrawersType = DrawersType.BattleDrawer;
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
              weeklyDistanceFrom: _isKM
                  ? double.parse(state.weeklyDistanceFrom.toStringAsFixed(0))
                  : double.parse(state.weeklyDistanceFrom.toStringAsFixed(1)),
              weeklyDistanceTo: _isKM
                  ? double.parse(state.weeklyDistanceTo.toStringAsFixed(0))
                  : double.parse(state.weeklyDistanceTo.toStringAsFixed(1)),
              workoutsPerWeek: state.workoutsPerWeek,
            );
            if (_keyScaffold.currentState != null &&
                _keyScaffold.currentState!.isEndDrawerOpen) {
              Navigator.of(context).pop();
            }
          } else if (state is FilterDrawerIsOpen) {
            _selectedDrawersType = DrawersType.FilterDrawer;
          } else if (state is GotDatePicker) {
            await getDate(context: context).then((DateTime? date) async {
              if (date != null) {
                final TimeOfDay? time = await getTime(context: context);
                if (time != null) {
                  _dateAndTime = getFormattedDate(date: date, time: time);
                  _dateAndTimeForUser =
                      getFormattedDateForUser(date: date, time: time);
                  print('Date: $_dateAndTime');
                }
              }
            });
          } else if (state is MessageDrawerIsOpenOrClose) {
            _isNeedToOpenMessageDrawer = !_isNeedToOpenMessageDrawer;
            _selectedMessageIndex = 1000;
            _messageController.text = '';
          } else if (state is MessageToOpponentDrawerIsSent) {
            _applyMessageController.reset();
            _messageToOpponent = state.message;
            BlocProvider.of<HomeBloc>(context)
                .add(home_bloc.OpenCloseMessageDrawer());
          } else if (state is SelectedMessageToOpponent) {
            _selectedMessageIndex = state.messageIndex;
          } else if (state is BattleCreated) {
            await _homeApi
                .createBattle(
                    model: BattleRequestModel(
              dateTime: _dateAndTime,
              battleName: _battleNameController.text.isNotEmpty
                  ? _battleNameController.text
                  : null,
              distance: _isKM
                  ? double.parse(_currentDistanceValue.toStringAsFixed(0))
                  : double.parse(_currentDistanceValue.toStringAsFixed(1)),
              message: _messageToOpponent,
              opponentId: _userBattleModel!.id,
            ))
                .then((bool value) async {
              if (value) {
                final UserModel currentUserModel =
                    PreferenceUtils.getCurrentUserModel();
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
                await toastUnexpectedError();
              }
            });
            _applyBattleController.reset();
          } else if (state is BattleOnNotificationDrawerIsOpen) {
            _battleRespondModel = state.model;
            if (_keyScaffold.currentState != null &&
                !_keyScaffold.currentState!.isEndDrawerOpen) {
              _keyScaffold.currentState!.openEndDrawer();
            }
          } else if (state is NewConditionsBattleDrawerIsOpenClose) {
            _isNeedToOpenChangeBattleDrawer = !_isNeedToOpenChangeBattleDrawer;
            _changeBattleDrawerTitle = 'Offer new conditions';
          } else if (state is BattleOnNotificationIsAccepted) {
            _acceptBattleController.success();
            await _homeApi
                .acceptBattle(battleId: state.battleId)
                .then((bool value) async {
              if (value) {
                if (_keyScaffold.currentState != null &&
                    _keyScaffold.currentState!.isEndDrawerOpen) {
                  Navigator.of(context).pop();
                }
              } else {
                await toastUnexpectedError();
              }
            });
            _acceptBattleController.reset();
          } else if (state is ApplyBattleIsChanged) {
            // _isNeedToOpenChangeBattleDrawer = false;
            await _homeApi
                .applyBattleChanges(
                    model: ChangeBattleConditionsModel(
                      dateTime: _dateAndTime,
                      distance: _isKM
                          ? double.parse(
                              _currentDistanceValue.toStringAsFixed(0))
                          : double.parse(
                              _currentDistanceValue.toStringAsFixed(1)),
                    ),
                    battleId: state.battleId)
                .then((bool value) async {
              if (value) {
                if (_keyScaffold.currentState != null &&
                    _keyScaffold.currentState!.isEndDrawerOpen) {
                  Navigator.of(context).pop();
                }
              } else {
                await toastUnexpectedError();
              }
            });
            _isNeedToOpenChangeBattleDrawer = false;
          } else if (state is ChangeBattleDrawerIsOpened) {
            _battleId = state.battleId;
            _battleRespondModel = state.model;
            _currentDistanceValue =
                getDistance(distance: state.model.distance).toDouble();
            _changeBattleDrawerTitle = 'Change battle';
            _dateAndTimeForUser = getFormattedDateForUser(
                date: DateTime.now(), time: TimeOfDay.now());
            _selectedDrawersType = DrawersType.ChangeBattleDrawer;
            if (_keyScaffold.currentState != null &&
                !_keyScaffold.currentState!.isEndDrawerOpen) {
              _keyScaffold.currentState!.openEndDrawer();
            }
          }

          BlocProvider.of<HomeBloc>(context).add(home_bloc.UpdateState());
        },
        child: BlocBuilder<HomeBloc, HomeState>(
            builder: (final BuildContext context, final HomeState state) {
          getBattleDataFromFirebaseMessaging(context: context);

          startWebSockets(context: context);

          return Scaffold(
            key: _keyScaffold,
            backgroundColor: homeBackground,
            onEndDrawerChanged: (bool value) {
              if (!value && _selectedDrawersType != DrawersType.FilterDrawer) {
                _isNeedToOpenMessageDrawer = false;
                _isNeedToOpenChangeBattleDrawer = false;
                _currentDistanceValue = 5;
                _battleNameController.text = '';
                Timer(const Duration(milliseconds: 300), () {
                  BlocProvider.of<HomeBloc>(context)
                      .add(home_bloc.OpenFilterDrawer());
                });
              }
            },
            appBar: AppBar(
              shadowColor: Colors.transparent,
              title: Text(
                _pageTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              backgroundColor: colorPrimary,
              actions: _selectedDrawerItem == DrawerItems.Profile
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
                            //title: 'Logout',
                            text: 'Are you sure you want to logout?',
                            applyButtonText: 'Logout',
                            cancelButtonText: 'Cancel',
                            onApplyPressed: () async {
                              await PreferenceUtils.setIsUserAuthenticated(
                                      false)
                                  .then((_) {
                                PreferenceUtils.setPageRout('Register');
                                Navigator.of(context).pushReplacementNamed(
                                    Constants.registerRoute);
                              });
                            });
                      },
                    )
                  : _selectedDrawerItem == DrawerItems.Connect
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
                      : _selectedDrawerItem == DrawerItems.Interact
                          ? <Widget>[Container()]
                          : null,
            ),
            drawer: _homeDrawer(
              context: context,
              width: width,
              height: height,
            ),
            endDrawer: _selectedDrawerItem == DrawerItems.Connect ||
                    _selectedDrawerItem == DrawerItems.Interact
                ? ConditionalSwitch.single<DrawersType>(
                    context: context,
                    valueBuilder: (BuildContext context) =>
                        _selectedDrawersType,
                    caseBuilders: <DrawersType, Widget Function(BuildContext)>{
                      DrawersType.FilterDrawer: (BuildContext context) =>
                          _connectFilterDrawer(
                              context: context, width: width, height: height),
                      DrawersType.BattleDrawer: (BuildContext context) {
                        return _createBattleDrawer(
                          context: context,
                          model: _userBattleModel,
                          width: width,
                          height: height,
                        );
                      },
                      DrawersType.BattleOnNotificationDrawer:
                          (BuildContext context) {
                        return _battleOfferOnNotification(
                          context: context,
                          model: _battleRespondModel,
                          width: width,
                          height: height,
                        );
                      },
                      DrawersType.ChangeBattleDrawer: (BuildContext context) {
                        return _changeBattle(
                          context: context,
                          width: width,
                          height: height,
                          onTapCancelBattle: () {
                            if (_keyScaffold.currentState != null &&
                                _keyScaffold.currentState!.isEndDrawerOpen) {
                              Navigator.of(context).pop();
                            }
                          },
                          userName: getOpponentName(
                            model: _battleRespondModel,
                            currentUserId: _currentUserId,
                          ),
                          userPhoto: getOpponentPhoto(
                            model: _battleRespondModel,
                            currentUserId: _currentUserId,
                          ),
                          userRank: getOpponentRank(
                            model: _battleRespondModel,
                            currentUserId: _currentUserId,
                          ),
                        );
                      },
                    },
                    fallbackBuilder: (BuildContext context) =>
                        _connectFilterDrawer(
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
                    children: <Widget>[
                      FutureBuilder<List<ConnectUsersModel>?>(
                          future: _users,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ConnectUsersModel>?>
                                  snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return snapshot.data!.isNotEmpty
                                  ? ConnectPage(
                                      users: snapshot.data!,
                                      onBattleTap:
                                          (ConnectUsersModel userModel) {
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
                                          children: <Widget>[
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
                      SizedBox(
                        width: width,
                        height: height,
                        child: InteractPage(
                          signalR: _signalR,
                          onTapChange: (String id, BattleRespondModel model) {
                            BlocProvider.of<HomeBloc>(context).add(
                                home_bloc.OpenChangeBattleDrawer(id, model));
                          },
                        ),
                      ),
                      EnjoyPage(),
                      ProfilePage(
                        userDataListener: () {
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.UpdateUserData());
                        },
                      ),
                      const SettingsPage(),
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
      onSwitchFilter: (bool value) {
        BlocProvider.of<HomeBloc>(context)
            .add(home_bloc.SwitchIsNeedFilter(isNeedFilter: value));
      },
      valuePaceStart: _currentRangeValuesPace.start,
      valuePaceEnd: _currentRangeValuesPace.end,
      isKM: _isKM,
      currentRangeValuesPace: _currentRangeValuesPace,
      onRangePaceChanged: (RangeValues values) {
        setState(() {
          _currentRangeValuesPace = values;
        });
      },
      valueWeeklyStart: _currentRangeValuesWeekly.start,
      valueWeeklyEnd: _currentRangeValuesWeekly.end,
      currentRangeValuesWeekly: _currentRangeValuesWeekly,
      onRangeWeeklyChanged: (RangeValues values) {
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
    await _homeApi.getUserModel().then((UserModel? userModel) async {
      if (userModel != null) {
        await Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => EditProfilePage(
                    userModel: userModel,
                    userDataListener: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(home_bloc.UpdateUserData());
                    },
                  )),
        );
      } else {
        await toastUnexpectedError();
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
    return <Widget>[
      IconButton(
        icon: firstButtonIcon,
        onPressed: onTapFirstButton,
        iconSize: 20,
      ),
      if (isNeedSecondButton)
        IconButton(
          icon: secondButtonIcon,
          onPressed: onTapSecondButton,
          iconSize: 20,
        )
      else
        Container(),
    ];
  }

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
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 172.h,
                        width: width,
                        color: const Color(0xff717171).withOpacity(0.7),
                        child: Stack(
                          children: <Widget>[
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
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      height: 64.h,
                                      width: 64.h,
                                      child: userAvatarPhoto(
                                          photoUrl: snapshot.data!.photoLink),
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
                        iconColor: _selectedDrawerItem == DrawerItems.Connect
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            _selectedDrawerItem == DrawerItems.Connect
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          _selectedDrawerItem = DrawerItems.Connect;
                          _pageTitle = 'Connect';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 0));
                        },
                      ),
                      _drawerItem(
                        label: 'Interact',
                        icon: interactIcon,
                        iconColor: _selectedDrawerItem == DrawerItems.Interact
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            _selectedDrawerItem == DrawerItems.Interact
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          _selectedDrawerItem = DrawerItems.Interact;
                          _pageTitle = 'Interact';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 1));
                        },
                      ),
                      _drawerItem(
                        label: 'Enjoy',
                        icon: enjoyIcon,
                        width: 24.0,
                        height: 24.0,
                        iconColor: _selectedDrawerItem == DrawerItems.Enjoy
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            _selectedDrawerItem == DrawerItems.Enjoy
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          _selectedDrawerItem = DrawerItems.Enjoy;
                          _pageTitle = 'Enjoy';
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 2));
                        },
                      ),
                      _drawerItem(
                        label: 'Profile',
                        icon: profileIcon,
                        iconColor: _selectedDrawerItem == DrawerItems.Profile
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            _selectedDrawerItem == DrawerItems.Profile
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          _pageTitle = 'Profile';
                          _selectedDrawerItem = DrawerItems.Profile;
                          BlocProvider.of<HomeBloc>(context)
                              .add(home_bloc.NavigateToPage(pageIndex: 3));
                        },
                      ),
                      _drawerItem(
                        label: 'Settings',
                        icon: settingsIcon,
                        iconColor: _selectedDrawerItem == DrawerItems.Settings
                            ? Colors.red
                            : const Color(0xff9F9F9F),
                        selectedItemColor:
                            _selectedDrawerItem == DrawerItems.Settings
                                ? const Color(0xfffef0f0)
                                : Colors.transparent,
                        onPressed: () {
                          _selectedDrawerItem = DrawerItems.Settings;
                          _pageTitle = 'Settings';
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
          child: SizedBox(
            child: Row(
              children: <Widget>[
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

  Widget _battleOfferOnNotification(
      {required BuildContext context,
      required BattleRespondModel model,
      required double height,
      required double width}) {
    return _isNeedToOpenChangeBattleDrawer
        ? _changeBattle(
            context: context,
            width: width,
            height: height,
            userName: model.battleUsers[0].applicationUser.id != _currentUserId
                ? model.battleUsers[0].applicationUser.nickName
                : model.battleUsers[1].applicationUser.nickName,
            userPhoto: model.battleUsers[0].applicationUser.id != _currentUserId
                ? model.battleUsers[0].applicationUser.photoLink
                : model.battleUsers[1].applicationUser.photoLink,
            userRank: model.battleUsers[0].applicationUser.id != _currentUserId
                ? model.battleUsers[0].applicationUser.rank.toString()
                : model.battleUsers[1].applicationUser.rank.toString(),
            onTapCancelBattle: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(home_bloc.OpenCloseNewConditionsBattleDrawer());
            },
          )
        : battleOfferOnNotificationDrawer(
            height: height,
            width: width,
            context: context,
            distance: model.distance,
            deadLineDate: model.deadlineTime.replaceFirst(RegExp('T'), '  '),
            battleMessage: model.message,
            currentUserModel:
                model.battleUsers[0].applicationUser.id == _currentUserId
                    ? model.battleUsers[0].applicationUser
                    : model.battleUsers[1].applicationUser,
            secondUserModel:
                model.battleUsers[0].applicationUser.id != _currentUserId
                    ? model.battleUsers[0].applicationUser
                    : model.battleUsers[1].applicationUser,
            acceptBattleController: _acceptBattleController,
            onTapAcceptBattle: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(home_bloc.AcceptBattleOnNotification(_battleId));
            },
            onTapChangeConditions: () {
              _currentDistanceValue =
                  getDistance(distance: model.distance).toDouble();
              BlocProvider.of<HomeBloc>(context)
                  .add(home_bloc.OpenCloseNewConditionsBattleDrawer());
            },
            onTapCancelBattle: () {
              if (_keyScaffold.currentState != null &&
                  _keyScaffold.currentState!.isEndDrawerOpen) {
                Navigator.of(context).pop();
              }
            },
          );
  }

  Widget _changeBattle({
    required BuildContext context,
    required String? userPhoto,
    required String userName,
    required String userRank,
    required double height,
    required double width,
    required VoidCallback onTapCancelBattle,
  }) {
    return changeBattleDrawer(
      height: height,
      width: width,
      context: context,
      userName: userName,
      userPhoto: userPhoto,
      userRank: userRank,
      titleDrawer: _changeBattleDrawerTitle,
      applyChangeBattleController: _applyChangeBattleController,
      dateAndTimeForUser: _dateAndTimeForUser,
      isKM: _isKM,
      currentDistanceValue: _currentDistanceValue,
      onSeekChanged: (double value) {
        setState(() {
          _currentDistanceValue = value;
        });
      },
      onTapApplyBattle: () {
        BlocProvider.of<HomeBloc>(context)
            .add(home_bloc.ApplyBattleChanges(_battleId));
      },
      onTapGetDatePicker: () {
        BlocProvider.of<HomeBloc>(context).add(home_bloc.GetDatePicker());
      },
      onTapCancelBattle: onTapCancelBattle,
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
          ? battleDrawer(
              height: height,
              width: width,
              model: model,
              battleNameController: _battleNameController,
              context: context,
              currentDistanceValue: _currentDistanceValue,
              isKM: _isKM,
              onSeekChanged: (double value) {
                setState(() {
                  _currentDistanceValue = value;
                });
              },
              onTapGetDatePicker: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(home_bloc.GetDatePicker());
              },
              dateAndTimeForUser: _dateAndTimeForUser,
              onTapOpenCloseMessageDrawer: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(home_bloc.OpenCloseMessageDrawer());
              },
              messageToOpponent: _messageToOpponent,
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
              onTapSelectMessageToOpponent: (int index) {
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
    return _connectApi.getUsersConnect(
      isFilterIncluded: isFilterIncluded,
      paceFrom: paceFrom,
      paceTo: paceTo,
      weeklyDistanceFrom: weeklyDistanceFrom,
      weeklyDistanceTo: weeklyDistanceTo,
      workoutsPerWeek: workoutsPerWeek,
    );
  }

  void updateRangeValuesAndUnit() {
    _isKM = PreferenceUtils.getIsUserUnitInKM();
    _currentRangeValuesPace =
        RangeValues((_isKM ? 2 : 3) * 60, (_isKM ? 11 : 18) * 60);
    _currentRangeValuesWeekly = RangeValues(_isKM ? 4 : 2.5, _isKM ? 150 : 94);
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
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
  }

  void getBattleDataFromFirebaseMessaging({required BuildContext context}) {
    //NOte: when app is Terminated
    _messaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null &&
          message.data['notificationType'] == 'CreatedBattle' &&
          _selectedDrawersType != DrawersType.BattleOnNotificationDrawer) {
        final String id = message.data['battleId'] as String;
        _battleId = id;
        await getBattleById(context: context, battleId: id);
      }
    });

    //NOte: when app is in Background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) async {
      final String id = event.data['battleId'] as String;
      final String type = event.data['notificationType'] as String;
      if (type == 'CreatedBattle' &&
          _selectedDrawersType != DrawersType.BattleOnNotificationDrawer) {
        _battleId = id;
        print('onMessageOpenedAppId: $id');
        await getBattleById(context: context, battleId: id);
      }
    });
  }

  //NOte: when app is Active
  Future<void> startWebSockets({required BuildContext context}) async {
    await _signalR.startConnection().whenComplete(() async {
      await _signalR.receiveBattleNotification(
          onReceiveNotification: (List<Object> arguments) async {
        if (_isAppInForeground) {
          final Object data = arguments[0];
          if (data != null &&
              _selectedDrawersType != DrawersType.BattleOnNotificationDrawer) {
            final Map<dynamic, dynamic> dataNotification =
                data as Map<dynamic, dynamic>;
            final num messageType = dataNotification['messageType'] as num;
            if (messageType == 1) {
              final String id = dataNotification['battleId'] as String;
              _battleId = id;
              await getBattleById(context: context, battleId: id);
            }
          }
          print(
              'SignalR_BattleId: ${(data as Map<dynamic, dynamic>)['battleId']} ');
        }
      });
    });
  }

  Future<void> getBattleById(
      {required BuildContext context, required String battleId}) async {
    await _homeApi
        .getBattleById(battleId: battleId)
        .then((BattleRespondModel? model) {
      if (model != null) {
        _selectedDrawersType = DrawersType.BattleOnNotificationDrawer;
        BlocProvider.of<HomeBloc>(context)
            .add(home_bloc.OpenBattleOnNotificationDrawer(model));
      } else {
        Fluttertoast.showToast(
            msg: 'Unexpected error happened',
            fontSize: 16.0,
            gravity: ToastGravity.CENTER);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _pageController.dispose();
    _battleNameController.dispose();
    _messageController.dispose();
    if (_signalR != null) {
      _signalR.stopConnection();
    }
    super.dispose();
  }
}
