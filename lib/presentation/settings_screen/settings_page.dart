import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/faq_helper.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/profile_screen/profile_page.dart';
import 'package:one2one_run/presentation/settings_screen/settings_bloc/bloc.dart'
    as settings_bloc;
import 'package:one2one_run/presentation/settings_screen/settings_bloc/settings_bloc.dart';
import 'package:one2one_run/presentation/settings_screen/settings_bloc/settings_state.dart';
import 'package:one2one_run/resources/app_string_res.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/settings'
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.userDataListener})
      : super(key: key);

  final VoidCallback userDataListener;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final RoundedLoadingButtonController _logOutController =
      RoundedLoadingButtonController();

  late Future<UserModel?> _userModel;

  final HomeApi _homeApi = HomeApi();

  @override
  void initState() {
    super.initState();
    _userModel = _homeApi.getUserModel();
    _userModel.then((UserModel? value) {
      if (value != null) {
        PreferenceUtils.setCurrentUserModel(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;
    return BlocProvider<SettingsBloc>(
      create: (final BuildContext context) => SettingsBloc(),
      child: BlocListener<SettingsBloc, SettingsState>(
        listener:
            (final BuildContext context, final SettingsState state) async {
          if (state is UserDataUpdated) {
            _userModel = _homeApi.getUserModel();
          }
          BlocProvider.of<SettingsBloc>(context)
              .add(settings_bloc.UpdateState());
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (final BuildContext context, final SettingsState state) {
          return Container(
            width: width,
            height: height,
            color: Colors.white,
            child: FutureBuilder<UserModel?>(
                future: _userModel,
                builder:
                    (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 190.h,
                          width: width,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 90.h,
                                width: width,
                                alignment: Alignment.center,
                                color: const Color(0xff717171).withOpacity(0.7),
                                child: ClipRRect(
                                  child: ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: snapshot.data!.photoLink != null
                                        ? Image.network(
                                            snapshot.data!.photoLink!,
                                            height: 90.h,
                                            width: width,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            defaultProfileImage,
                                            height: 90.h,
                                            width: width,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 90.h / 1.5,
                                left: 0,
                                right: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 74.h,
                                        width: 74.h,
                                        child: userAvatarPhoto(
                                          photoUrl: snapshot.data!.photoLink,
                                          height: height,
                                          width: width,
                                          context: context,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 0.03,
                                          top: height * 0.01),
                                      child: Text(
                                        snapshot.data!.nickName ??
                                            AppStringRes.nickname,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'roboto',
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 0.03, top: 5),
                                      child: Text(
                                        snapshot.data!.email ??
                                            'email@gmail.com',
                                        style: TextStyle(
                                            color: Colors.grey,
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
                          height: height * 0.01,
                        ),
                        buttonWithIconWithOutShadow(
                          onPressed: () async {
                            await Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      ProfilePage(
                                    userDataListener: () {
                                      widget.userDataListener();
                                    },
                                  ),
                                ));
                          },
                          title: 'Profile',
                          icon: profileIcon,
                          height: height * 0.05,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        buttonWithIconWithOutShadow(
                          onPressed: () {
                            WidgetsBinding.instance?.addPostFrameCallback((_) {
                              Navigator.push<dynamic>(context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext con) {
                                return const FAQHelperPage(
                                  faqHelperState: FAQHelperState.HelpState,
                                );
                              }));
                            });
                          },
                          title: 'Help',
                          icon: helpIcon,
                          height: height * 0.05,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        buttonWithIconWithOutShadow(
                          onPressed: () async {
                            await Navigator.of(context)
                                .pushNamed(Constants.configurationRoute);
                          },
                          title: 'Configuration',
                          icon: configurationIcon,
                          height: height * 0.05,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: buildRoundedButton(
                            label: 'LOG OUT',
                            width: width,
                            height: 40.h,
                            buttonTextSize: 14.0,
                            controller: _logOutController,
                            textColor: Colors.white,
                            backColor: redColor,
                            onTap: () {
                              _logOutController.reset();
                              dialog(
                                  context: context,
                                  //title: 'Logout',
                                  text: AppStringRes.areYouSureWantLogout,
                                  applyButtonText: 'Logout',
                                  cancelButtonText: AppStringRes.cancel,
                                  onApplyPressed: () async {
                                    await PreferenceUtils
                                            .setIsUserAuthenticated(false)
                                        .then((_) {
                                      PreferenceUtils.setPageRout('Register');
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              Constants.registerRoute,
                                              (Route<dynamic> route) => false);
                                    });
                                  });
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
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
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
