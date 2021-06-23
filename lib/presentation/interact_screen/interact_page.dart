import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:one2one_run/presentation/interact_screen/interact_bloc/bloc.dart'
    as interact_bloc;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_state.dart';

//NOte:'/interact'
class InteractPage extends StatefulWidget {
  InteractPage({Key? key}) : super(key: key);

  @override
  _InteractPageState createState() => _InteractPageState();
}

class _InteractPageState extends State<InteractPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;

    return BlocProvider<InteractBloc>(
      create: (final context) => InteractBloc(),
      child: BlocListener<InteractBloc, InteractState>(
        listener: (final context, final state) async {
          if (state is StateUpdated) {}
          BlocProvider.of<InteractBloc>(context)
              .add(interact_bloc.UpdateState());
        },
        child: BlocBuilder<InteractBloc, InteractState>(
            builder: (final context, final state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Interact',
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
