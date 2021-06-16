import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:one2one_run/presentation/connect_screen/connect_bloc/bloc.dart'
    as connect_bloc;
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_bloc.dart';
import 'package:one2one_run/presentation/connect_screen/connect_bloc/connect_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//NOte:'/connect'
class ConnectPage extends StatefulWidget {
  ConnectPage({Key? key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<ConnectBloc>(
        create: (final context) => ConnectBloc(),
        child: BlocListener<ConnectBloc, ConnectState>(
          listener: (final context, final state) async {
            if (state is StateUpdated) {}
            BlocProvider.of<ConnectBloc>(context)
                .add(connect_bloc.UpdateState());
          },
          child: BlocBuilder<ConnectBloc, ConnectState>(
              builder: (final context, final state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: width,
                height: height,
                child: Center(
                  child: Text(
                    'Connect',
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
