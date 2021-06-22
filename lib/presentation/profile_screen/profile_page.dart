import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/data/apis/profile_api.dart';
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
  ProfileApi profileApi = ProfileApi();

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
          if (state is GalleryIsOpened) {
            Navigator.pop(context);
            await _pickImage(context: context);
          } else if (state is UserPhotoUploaded) {
            await profileApi.uploadImageProfile(_imageFile).then((value) async {
              if (value) {
                setState(() {});
              } else {
                await Fluttertoast.showToast(
                    msg: 'Unexpected error happened',
                    fontSize: 16.0,
                    gravity: ToastGravity.CENTER);
              }
            });
          }
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
              child: FutureBuilder<UserModel>(
                  future: homeApi.getUserModel(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      _nameController.text =
                          snapshot.data!.nickName ?? 'NickName';
                      _emailController.text =
                          snapshot.data!.email ?? 'email@gmail.com';
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
                                        '${snapshot.data!.moto ?? 'Here will be your Motto.'}',
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
                                      dialog(
                                          context: context,
                                          Title: 'Profile picture',
                                          text: 'Profile picture',
                                          applyButtonText: 'Change',
                                          cancelButtonText: 'Cancel',
                                          onApplyPressed: () {
                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .add(
                                                    profile_bloc.OpenGallery());
                                          });
                                    },
                                    child: SizedBox(
                                      height: height * 0.12,
                                      width: height * 0.12,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 80,
                                        backgroundImage:
                                            snapshot.data!.photoLink == null
                                                ? _imageFile == null
                                                    ? AssetImage(
                                                        defaultProfileImage,
                                                      )
                                                    : FileImage(_imageFile!)
                                                        as ImageProvider
                                                : NetworkImage(
                                                    snapshot.data!.photoLink!),
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
                                      fontSize: 16.0),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  inputTextFieldRounded(
                                    controller: _emailController,
                                    errorText: null,
                                    hintText: 'E-mail address',
                                    icon: Icons.email,
                                    isReadOnly: true,
                                    fontSize: 16.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.05,
                                  ),
                                  const Divider(
                                    height: 3,
                                    endIndent: 3.0,
                                    indent: 3.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      _userPaceDistance(
                                        title: 'Pace',
                                        value:
                                            '${snapshot.data!.pace}:00 min/${snapshot.data!.isMetric ? 'km' : 'mile'}',
                                      ),
                                      SizedBox(
                                        width: width * 0.2,
                                      ),
                                      _userPaceDistance(
                                        title: 'Weekly Distance',
                                        value:
                                            '${snapshot.data!.weeklyDistance} ${snapshot.data!.isMetric ? 'km' : 'mile'}',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  _userPaceDistance(
                                    title: 'Running frequency',
                                    value:
                                        '${snapshot.data!.workoutsPerWeek} times per week',
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  const Divider(
                                    height: 3,
                                    endIndent: 3.0,
                                    indent: 3.0,
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
                                          value: '${snapshot.data!.wins}',
                                          colorValue: Colors.red),
                                      Container(
                                        color: Colors.grey,
                                        height: 10.h,
                                        width: 0.5,
                                      ),
                                      _userWonLoss(
                                        title: 'Loss',
                                        value: '${snapshot.data!.loses}',
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        height: 10.h,
                                        width: 0.5,
                                      ),
                                      _userWonLoss(
                                        title: 'Discarded',
                                        value: '${snapshot.data!.discarded}',
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        height: 10.h,
                                        width: 0.5,
                                      ),
                                      _userWonLoss(
                                        title: 'My score',
                                        value: '${snapshot.data!.score}',
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  const Divider(
                                    height: 3,
                                    endIndent: 3.0,
                                    indent: 3.0,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  _userBio(
                                      value:
                                          '${snapshot.data!.description ?? 'Here will be your Biography.'}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: width,
                        height: height,
                        child: Center(
                          child: Align(
                            child: progressIndicator(),
                          ),
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
          width: 5.0,
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

  Future<void> _pickImage({required BuildContext context}) async {
    await _imagePicker
        .getImage(source: ImageSource.gallery)
        .then((value) async {
      if (value != null) {
        _imageFile = File(value.path);
        BlocProvider.of<ProfileBloc>(context)
            .add(profile_bloc.UploadUserPhoto());
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
