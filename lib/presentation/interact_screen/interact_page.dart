import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/bloc.dart'
    as interact_bloc;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_bloc.dart';
import 'package:one2one_run/presentation/interact_screen/interact_bloc/interact_state.dart';
import 'package:one2one_run/resources/colors.dart';

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
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: colorPrimary,
              appBar: TabBar(
                indicatorColor: Colors.red,
                tabs: [
                  interactTab(title: 'Active'),
                  interactTab(title: 'Pending'),
                  interactTab(title: 'Finished'),
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xffF5F5F5),
                    child: const Center(
                      child: Text('Active Page'),
                    ),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xffF5F5F5),
                    child: const Center(
                      child: Text('Pending Page'),
                    ),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xffF5F5F5),
                    child: const Center(
                      child: Text('Finished Page'),
                    ),
                  ),
                ],
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
