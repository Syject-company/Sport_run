import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/settings_api.dart';
import 'package:one2one_run/data/models/settings_notification_model.dart';
import 'package:one2one_run/presentation/configuration_screen/configuration_bloc/bloc.dart'
    as configuration_bloc;
import 'package:one2one_run/presentation/configuration_screen/configuration_bloc/configuration_bloc.dart';
import 'package:one2one_run/presentation/configuration_screen/configuration_bloc/configuration_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/utils/extension.dart' show ToastExtension;
import 'package:rounded_loading_button/rounded_loading_button.dart';

//NOte:'/configuration'
class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  ConfigurationPageState createState() => ConfigurationPageState();
}

class ConfigurationPageState extends State<ConfigurationPage> {
  final RoundedLoadingButtonController _saveController =
      RoundedLoadingButtonController();

  bool _isNeedBattleUpdate = true;
  bool _isNeedChatMessage = true;

  final SettingsApi _settingsApi = SettingsApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: FutureBuilder<SettingsNotificationModel?>(
          future: _settingsApi.getNotificationsState(),
          builder: (BuildContext context,
              AsyncSnapshot<SettingsNotificationModel?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              _isNeedBattleUpdate = !snapshot.data!.disableButtlesNotifications;
              _isNeedChatMessage = !snapshot.data!.disableChatsNotifications;

              return BlocProvider<ConfigurationBloc>(
                create: (final BuildContext context) => ConfigurationBloc(),
                child: BlocListener<ConfigurationBloc, ConfigurationState>(
                  listener: (final BuildContext context,
                      final ConfigurationState state) async {
                    if (state is SwitchedIsNeedBattleUpdate) {
                      _isNeedBattleUpdate = state.isNeedBattleUpdate;
                    } else if (state is SwitchedIsNeedChatMessage) {
                      _isNeedChatMessage = state.isNeedChatMessage;
                    } else if (state is NotificationEnabled) {
                      await _settingsApi
                          .enableNotifications(SettingsNotificationModel(
                        disableButtlesNotifications: !state.enableBattleUpdate,
                        disableChatsNotifications: !state.enableChatMessage,
                      ))
                          .then((bool value) async {
                        if (value) {
                          _saveController.success();
                        } else {
                          _saveController.error();
                          await toastUnexpectedError();
                        }
                        Timer(const Duration(seconds: 2), () {
                          _saveController.reset();
                        });
                      });
                    }
                    BlocProvider.of<ConfigurationBloc>(context)
                        .add(configuration_bloc.UpdateState());
                  },
                  child: BlocBuilder<ConfigurationBloc, ConfigurationState>(
                      builder: (final BuildContext context,
                          final ConfigurationState state) {
                    return Scaffold(
                      appBar: AppBar(
                        shadowColor: Colors.transparent,
                        title: Text(
                          'Configuration',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'roboto',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: colorPrimary,
                      ),
                      body: Container(
                          width: width,
                          height: height,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.07,
                              vertical: height * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Push notifications',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'roboto',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Battle updates',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    value: _isNeedBattleUpdate,
                                    activeColor: const Color(0xffc1ff9b),
                                    onChanged: (bool value) {
                                      BlocProvider.of<ConfigurationBloc>(
                                              context)
                                          .add(configuration_bloc
                                              .SwitchIsNeedBattleUpdate(
                                                  isNeedBattleUpdate: value));
                                    },
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                endIndent: 3.0,
                                indent: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Chat messages',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    value: _isNeedChatMessage,
                                    activeColor: const Color(0xffc1ff9b),
                                    onChanged: (bool value) {
                                      BlocProvider.of<ConfigurationBloc>(
                                              context)
                                          .add(configuration_bloc
                                              .SwitchIsNeedChatMessage(
                                                  isNeedChatMessage: value));
                                    },
                                  ),
                                ],
                              ),
                              const Spacer(),
                              buildRoundedButton(
                                label: 'SAVE CHANGES',
                                width: width,
                                height: 40.h,
                                buttonTextSize: 14.0,
                                controller: _saveController,
                                textColor: Colors.white,
                                backColor: redColor,
                                onTap: () {
                                  BlocProvider.of<ConfigurationBloc>(context)
                                      .add(
                                          configuration_bloc.EnableNotification(
                                    enableBattleUpdate: _isNeedBattleUpdate,
                                    enableChatMessage: _isNeedChatMessage,
                                  ));
                                },
                              ),
                            ],
                          )),
                    );
                  }),
                ),
              );
            } else {
              return SizedBox(
                width: width,
                height: height,
                child: Center(
                  child: Align(
                    child: progressIndicator(),
                  ),
                ),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
