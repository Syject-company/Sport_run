import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/home_api.dart';
import 'package:one2one_run/data/apis/profile_api.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/presentation/edit_profile_screen/edit_profile_page.dart';
import 'package:one2one_run/presentation/profile_screen/profile_bloc/bloc.dart'
    as profile_bloc;
import 'package:one2one_run/presentation/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:one2one_run/presentation/profile_screen/profile_bloc/profile_state.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/extension.dart'
    show DateTimeExtension, ToastExtension, UserData;
import 'package:one2one_run/utils/preference_utils.dart';

//NOte:'/profile'
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userDataListener})
      : super(key: key);

  final VoidCallback userDataListener;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  final HomeApi _homeApi = HomeApi();
  ProfileApi profileApi = ProfileApi();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocProvider<ProfileBloc>(
      create: (final BuildContext context) => ProfileBloc(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (final BuildContext context, final ProfileState state) async {
          if (state is GalleryIsOpened) {
            Navigator.pop(context);
            await _pickImage(context: context);
          } else if (state is UserPhotoUploaded) {
            await profileApi
                .uploadImageProfile(_imageFile)
                .then((bool value) async {
              if (value) {
                widget.userDataListener();
                setState(() {});
              } else {
                await toastUnexpectedError();
              }
            });
          }
          BlocProvider.of<ProfileBloc>(context).add(profile_bloc.UpdateState());
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (final BuildContext context, final ProfileState state) {
          return Container(
            height: height,
            width: width,
            color: Colors.white,
            child: Scaffold(
              appBar: AppBar(
                shadowColor: Colors.transparent,
                title: Text(
                  'Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'roboto',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: colorPrimary,
                actions: appBarButtons(
                  isNeedSecondButton: true,
                  firstButtonIcon: const Icon(Icons.edit),
                  onTapFirstButton: () async {
                    await navigateToEditProfile(context: context);
                  },
                  secondButtonIcon: const Icon(Icons.logout),
                  onTapSecondButton: () {
                    dialog(
                        context: context,
                        //title: 'Logout',
                        text: 'Are you sure you want to logout?',
                        applyButtonText: 'Logout',
                        cancelButtonText: 'Cancel',
                        onApplyPressed: () async {
                          await PreferenceUtils.setIsUserAuthenticated(false)
                              .then((_) {
                            PreferenceUtils.setPageRout('Register');
                            Navigator.of(context)
                                .pushReplacementNamed(Constants.registerRoute);
                          });
                        });
                  },
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FutureBuilder<UserModel?>(
                    future: _homeApi.getUserModel(),
                    builder:
                        (BuildContext ctx, AsyncSnapshot<UserModel?> snapshot) {
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
                            children: <Widget>[
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                width: width,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: height * 0.09,
                                      width: width - 20,
                                      color: const Color(0xffF2F2F2),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        top: (height * 0.12) / 7,
                                        left: height * 0.12 / 2,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: (height * 0.12) / 2),
                                        child: Text(
                                          snapshot.data!.moto ??
                                              'Here will be your Motto.',
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
                                            //title: 'Profile picture',
                                            text: 'Profile picture',
                                            applyButtonText: 'Change',
                                            cancelButtonText: 'Cancel',
                                            onApplyPressed: () {
                                              BlocProvider.of<ProfileBloc>(
                                                      context)
                                                  .add(profile_bloc
                                                      .OpenGallery());
                                            });
                                      },
                                      child: SizedBox(
                                        height: height * 0.12,
                                        width: height * 0.12,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 80,
                                          backgroundImage: snapshot
                                                      .data!.photoLink ==
                                                  null
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        boxShadow: <BoxShadow>[
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
                                  children: <Widget>[
                                    inputTextField(
                                        controller: _nameController,
                                        errorText: null,
                                        isReadOnly: true,
                                        hintText: 'Name',
                                        fontSize: 16.0),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    inputTextField(
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
                                      children: <Widget>[
                                        _userPaceDistance(
                                          title: 'Pace',
                                          value: snapshot.data!.isMetric
                                              ? '${getTimeStringFromDouble(snapshot.data!.pace.toDouble())} min/km'
                                              : '${(snapshot.data!.pace).toStringAsFixed(2)} min/mile',
                                          /*   value:
                                              '${snapshot.data!.pace.floor() */ /*~/ 60*/ /*}:00 min/${snapshot.data!.isMetric ? 'km' : 'mile'}',*/
                                        ),
                                        SizedBox(
                                          width: width * 0.2,
                                        ),
                                        _userPaceDistance(
                                          title: 'Weekly Distance',

                                          value:   '${snapshot.data!.weeklyDistance.toStringAsFixed(snapshot.data!.isMetric ? 0 : 1)} ${snapshot.data!.isMetric ? 'km' : 'mile'}',

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
                                      children: <Widget>[
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
                                        value: snapshot.data!.description ??
                                            'Here will be your Biography.'),
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
            ),
          );
        }),
      ),
    );
  }

  Widget _userPaceDistance({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
      children: <Widget>[
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
      children: <Widget>[
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
        .pickImage(source: ImageSource.gallery)
        .then((XFile? value) async {
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

  Future<void> navigateToEditProfile({required BuildContext context}) async {
    await _homeApi.getUserModel().then((UserModel? userModel) async {
      if (userModel != null) {
        await Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => EditProfilePage(
                    userModel: userModel,
                    userDataListener: () {
                      setState(() {});
                      widget.userDataListener();
                    },
                  )),
        );
      } else {
        await toastUnexpectedError();
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
