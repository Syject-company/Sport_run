import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/profile_screen/profile_bloc/bloc.dart'
    as profile_bloc;
import 'package:one2one_run/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:one2one_run/presentation/profile_screen/profile_bloc/profile_state.dart';
import 'package:one2one_run/resources/images.dart';

//NOte:'/profile'
class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _imagePicker = ImagePicker();
  File? _imageFile;

  HomeApi homeApi = HomeApi();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider<ProfileBloc>(
      create: (final context) => ProfileBloc(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (final context, final state) async {
          if (state is StateUpdated) {}
          BlocProvider.of<ProfileBloc>(context).add(profile_bloc.UpdateState());
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (final context, final state) {
          return Container(
            height: height,
            width: width,
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FutureBuilder(
                  future: homeApi.getUserModel(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      //TODO;
                      _nameController.text = 'Issa Mirage';
                      _emailController.text =
                          (snapshot.data as UserModel).email!;
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              width: width,
                              child: Stack(
                                children: [
                                  Container(
                                    height: height * 0.09,
                                    width: width - 20,
                                    color: const Color(0xffF2F2F2),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      top: (height * 0.12) / 7,
                                      left: 10.0,
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: height * 0.12),
                                      child: Text(
                                        'Lorem ipsum dolor sit amet,'
                                        'consectetur adipiscing elit,'
                                        'sed do eiusmod tempor',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'roboto',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _pickImage();
                                    },
                                    child: SizedBox(
                                      height: height * 0.12,
                                      width: height * 0.12,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 80,
                                        backgroundImage: _imageFile == null
                                            ? AssetImage(
                                                defaultProfileBackground,
                                              )
                                            : FileImage(_imageFile!)
                                                as ImageProvider,
                                        // : NetworkImage(imageLink),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: height * 0.09,
                                        left: height * 0.08),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      editImageIcon,
                                      width: height * 0.032,
                                      height: height * 0.032,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              margin: EdgeInsets.only(top: height * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  inputTextFieldRounded(
                                      controller: _nameController,
                                      errorText: null,
                                      isReadOnly: true,
                                      hintText: 'Name',
                                      fontSize: 17.0),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  inputTextFieldRounded(
                                    controller: _emailController,
                                    errorText: null,
                                    hintText: 'E-mail address',
                                    icon: Icons.email,
                                    isReadOnly: true,
                                    fontSize: 17.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.05,
                                  ),
                                  const Divider(
                                    height: 3,
                                    endIndent: 10.0,
                                    indent: 10.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      _userPaceDistance(
                                        title: 'Pace',
                                        value: '05:00 min/km',
                                      ),
                                      SizedBox(
                                        width: width * 0.2,
                                      ),
                                      _userPaceDistance(
                                        title: 'Weekly Distance',
                                        value: '02:00 min/km',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  _userPaceDistance(
                                    title: 'Running frequency',
                                    value: '3 times per week',
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  const Divider(
                                    height: 3,
                                    endIndent: 10.0,
                                    indent: 10.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _userWonLoss(
                                          title: 'Won',
                                          value: '14',
                                          colorValue: Colors.red),
                                      _userWonLoss(
                                        title: 'Loss',
                                        value: '14',
                                      ),
                                      _userWonLoss(
                                        title: 'Discarded',
                                        value: '0',
                                      ),
                                      _userWonLoss(
                                        title: 'My score',
                                        value: '14',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  const Divider(
                                    height: 3,
                                    endIndent: 10.0,
                                    indent: 10.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  _userBio(
                                    value: 'Lorem ipsum dolor sit amet, '
                                        'consectetur'
                                        ' adipiscing elit, sed do eiusmod '
                                        'tempor incididunt ut labore et '
                                        'dolore magna aliqua. Ut enim ad '
                                        'minim veniam, quis nostrud '
                                        'exercitation ullamco laboris '
                                        'nisi ut aliquip ex ea commodo '
                                        'consequat. Duis aute irure dolor '
                                        'in reprehenderit in voluptate '
                                        'velit esse cillum dolore eu fugiat'
                                        ' nulla pariatur.',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Align(
                          child: progressIndicator(),
                        ),
                      );
                    }
                  }),
            ),
          );
        }),
      ),
    );
  }

  Widget _userPaceDistance({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xff838383),
              fontFamily: 'roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xff2B2B2B),
              fontFamily: 'roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _userWonLoss(
      {required String title,
      required String value,
      Color colorValue = Colors.black}) {
    return Row(
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xff838383),
              fontFamily: 'roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: colorValue,
              fontFamily: 'roboto',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _userBio({required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: const Color(0xff2B2B2B),
              fontFamily: 'roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: const Color(0xff455A64),
            fontFamily: 'roboto',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            wordSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    await _imagePicker
        .getImage(source: ImageSource.gallery)
        .then((value) async {
      if (value != null) {
        _imageFile = File(value.path);
        setState(() {});
      } else {
        await Fluttertoast.showToast(
            msg: 'No image selected.',
            fontSize: 16.0,
            gravity: ToastGravity.CENTER);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
