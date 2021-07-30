import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/bloc.dart'
    as enjoy_bloc;
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/enjoy_bloc.dart';
import 'package:one2one_run/presentation/enjoy_screen/enjoy_bloc/enjoy_state.dart';

//NOte:'/enjoy'
class EnjoyPage extends StatefulWidget {
  const EnjoyPage({Key? key}) : super(key: key);

  @override
  _EnjoyPageState createState() => _EnjoyPageState();
}

class _EnjoyPageState extends State<EnjoyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<EnjoyBloc>(
      create: (final BuildContext context) => EnjoyBloc(),
      child: BlocListener<EnjoyBloc, EnjoyState>(
        listener: (final BuildContext context, final EnjoyState state) async {
          if (state is StateUpdated) {}
          BlocProvider.of<EnjoyBloc>(context).add(enjoy_bloc.UpdateState());
        },
        child: BlocBuilder<EnjoyBloc, EnjoyState>(
            builder: (final BuildContext context, final EnjoyState state) {
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
