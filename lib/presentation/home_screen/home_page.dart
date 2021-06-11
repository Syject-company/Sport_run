import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/bloc.dart'
    as home_bloc;
import 'package:one2one_run/presentation/home_screen/home_bloc/home_bloc.dart';
import 'package:one2one_run/presentation/home_screen/home_bloc/home_state.dart';
import 'package:one2one_run/resources/images.dart';

//NOte:'/home'
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: BlocProvider<HomeBloc>(
          create: (final context) => HomeBloc(),
          child: BlocListener<HomeBloc, HomeState>(
            listener: (final context, final state) async {
              if (state is StateUpdated) {}
              BlocProvider.of<HomeBloc>(context).add(home_bloc.UpdateState());
            },
            child: BlocBuilder<HomeBloc, HomeState>(
                builder: (final context, final state) {
              return SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Container(
                        child: const Text('Home Page'),
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
