import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/_screen/login_bloc/bloc.dart' as runner_data_bloc;
import 'package:one2one_run/_screen/login_bloc/login_bloc.dart';
import 'package:one2one_run/_screen/login_bloc/login_state.dart';
import 'package:one2one_run/resources/images.dart';

//NOte:'/runnersData'
class RunnerDataPage extends StatefulWidget {
  RunnerDataPage({Key? key}) : super(key: key);

  @override
  _RunnerDataPageState createState() => _RunnerDataPageState();
}

class _RunnerDataPageState extends State<RunnerDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            backGround,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocProvider<LoginBloc>(
          create: (final context) => LoginBloc(),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (final context, final state) async {
              if (state is StateUpdated) {}
              BlocProvider.of<LoginBloc>(context)
                  .add(runner_data_bloc.UpdateState());
            },
            child: BlocBuilder<LoginBloc, LoginState>(
                builder: (final context, final state) {
              return SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      child: const Text(
                        'RunnerData',
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
