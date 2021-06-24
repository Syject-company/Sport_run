import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/_screen/_bloc/e_bloc.dart';
import 'package:one2one_run/_screen/_bloc/e_state.dart';

import 'package:one2one_run/_screen/_bloc/bloc.dart'
    as e_bloc;

import 'package:flutter_screenutil/flutter_screenutil.dart';


//NOte:'/e'
class EPage extends StatefulWidget {
  EPage({Key? key}) : super(key: key);

  @override
  _EPageState createState() => _EPageState();
}

class _EPageState extends State<EPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;

    return BlocProvider<EBloc>(
      create: (final context) => EBloc(),
      child: BlocListener<EBloc, EState>(
        listener: (final context, final state) async {
          if (state is StateUpdated) {}
          BlocProvider.of<EBloc>(context).add(e_bloc.UpdateState());
        },
        child: BlocBuilder<EBloc, EState>(
            builder: (final context, final state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Enjoy',
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
