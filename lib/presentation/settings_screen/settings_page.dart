import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/settings_screen/settings_bloc/bloc.dart'
    as settings_bloc;
import 'package:one2one_run/presentation/settings_screen/settings_bloc/settings_bloc.dart';
import 'package:one2one_run/presentation/settings_screen/settings_bloc/settings_state.dart';

//NOte:'/settings'
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
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
          if (state is StateUpdated) {}
          BlocProvider.of<SettingsBloc>(context)
              .add(settings_bloc.UpdateState());
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (final BuildContext context, final SettingsState state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'roboto',
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
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
