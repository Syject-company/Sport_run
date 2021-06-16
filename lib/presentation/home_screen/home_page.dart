import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/connect_screen/connect_page.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/bloc.dart'
    as home_bloc;
import 'package:one2one_run/presentation/home_screen/home_bloc/home_bloc.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/home_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/utils/enums.dart';

//NOte:'/home'
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _keyScaffold = GlobalKey<ScaffoldState>();

  final _pageController = PageController();

  DrawerItems selectedDrawerItem = DrawerItems.Connect;

  HomeApi homeApi = HomeApi();

  @override
  void initState() {
    super.initState();
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
          if (state is StateUpdated) {}
          BlocProvider.of<HomeBloc>(context).add(home_bloc.UpdateState());
        },
        child: BlocBuilder<HomeBloc, HomeState>(
            builder: (final context, final state) {
          return FutureBuilder(
              future: homeApi.getUserModel(),
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data != null
                    ? Scaffold(
                        key: _keyScaffold,
                        backgroundColor: homeBackground,
                        appBar: AppBar(
                          title: Text(
                            //TODO: when change page
                            'Connect',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'roboto',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: colorPrimary,
                        ),
                        drawer: _drawer(
                          context: context,
                          userName: (snapshot.data as UserModel).nickName ??
                              'Nickname',
                          userImage: (snapshot.data as UserModel).photoLink ??
                              defaultProfileBackground,
                          userEmail: (snapshot.data as UserModel).email ??
                              'email@gmail.com',
                          width: width,
                          height: height,
                        ),
                        body: SafeArea(
                          child: Container(
                            width: width,
                            height: height,
                            color: Colors.white,
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ConnectPage(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        width: width,
                        height: height,
                        child: progressIndicator(),
                      );
              });
        }),
      ),
    );
  }

  Widget _drawer(
      {required BuildContext context,
      required String userImage,
      required String userName,
      required String userEmail,
      required double height,
      required double width}) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: width * 0.15),
      child: Drawer(
        child: Container(
          height: height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 172.h,
                width: width,
                color: const Color(0xff717171).withOpacity(0.7),
                child: Stack(
                  children: [
                    Positioned(
                      height: 172.h,
                      width: 172.h,
                      right: 15,
                      child: ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Image.asset(
                            userImage,
                            height: 172.h,
                            width: 172.h,
                            fit: BoxFit.fill,
                          ),
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
                                backgroundImage: AssetImage(
                                  defaultProfileBackground,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.03, top: height * 0.01),
                            child: Text(
                              userName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'roboto',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: width * 0.03, top: 5),
                            child: Text(
                              userEmail,
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
                selectedItemColor: selectedDrawerItem == DrawerItems.Connect
                    ? const Color(0xfffef0f0)
                    : Colors.transparent,
                onPressed: () {},
              ),
              _drawerItem(
                label: 'Interact',
                icon: interactIcon,
                iconColor: selectedDrawerItem == DrawerItems.Interact
                    ? Colors.red
                    : const Color(0xff9F9F9F),
                selectedItemColor: selectedDrawerItem == DrawerItems.Interact
                    ? const Color(0xfffef0f0)
                    : Colors.transparent,
                onPressed: () {},
              ),
              _drawerItem(
                label: 'Enjoy',
                icon: enjoyIcon,
                iconColor: selectedDrawerItem == DrawerItems.Enjoy
                    ? Colors.red
                    : const Color(0xff9F9F9F),
                selectedItemColor: selectedDrawerItem == DrawerItems.Enjoy
                    ? const Color(0xfffef0f0)
                    : Colors.transparent,
                onPressed: () {},
              ),
              _drawerItem(
                label: 'Profile',
                icon: profileIcon,
                iconColor: selectedDrawerItem == DrawerItems.Profile
                    ? Colors.red
                    : const Color(0xff9F9F9F),
                selectedItemColor: selectedDrawerItem == DrawerItems.Profile
                    ? const Color(0xfffef0f0)
                    : Colors.transparent,
                onPressed: () {},
              ),
              _drawerItem(
                label: 'Settings',
                icon: settingsIcon,
                iconColor: selectedDrawerItem == DrawerItems.Settings
                    ? Colors.red
                    : const Color(0xff9F9F9F),
                selectedItemColor: selectedDrawerItem == DrawerItems.Settings
                    ? const Color(0xfffef0f0)
                    : Colors.transparent,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required String label,
    required String icon,
    required VoidCallback onPressed,
    double height = 46.0,
    double width = 46.0,
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
