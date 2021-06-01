import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/_screen/login_bloc/login_bloc.dart';
import 'package:one2one_run/_screen/login_bloc/login_state.dart';
import 'package:one2one_run/_screen/login_bloc/bloc.dart' as register_bloc;

//NOte:'/register'
class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'backGround',
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
              BlocProvider.of<LoginBloc>(context).add(
                register_bloc.UpdateState(),
              );
            },
            child: BlocBuilder<LoginBloc, LoginState>(
                builder: (final context, final state) {
              return SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Container(),
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
