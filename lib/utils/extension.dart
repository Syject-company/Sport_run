import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'constants.dart';

extension EmailValidator on String {
  bool isValidEmailInput() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPasswordInput() {
    return RegExp(r'^(?=.*[a-z])').hasMatch(this);
  }
}

extension DateTimeExtension on void {
  String getFormattedDate({
    required DateTime date,
    required TimeOfDay time,
  }) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
        DateTime(date.year, date.month, date.day, time.hour, time.minute)
            .toLocal());
  }

  String getFormattedDateForUser({
    required DateTime date,
    /* required TimeOfDay time,*/
  }) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime(date.year, date.month, date.day).toLocal());
  }

//0001-01-01T00:00:00
  String getFormattedTimeForServer({
    required String time,
  }) {
    return '0001-01-01T$time';
  }

//00:00
  String getFormattedTimeForUser({
    required TimeOfDay time,
  }) {
    return DateFormat('HH:mm').format(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, time.hour, time.minute)
        .toLocal());
  }

  String getFormattedResultTime({
    required Duration time,
  }) {
    final String _timeChanged =
        time.toString().substring(0, time.toString().indexOf('.'));
    if (_timeChanged.length == 7) {
      return '0$_timeChanged';
    }

    return _timeChanged;
  }

  String getFormattedPaceTime({
    required double pace,
  }) {
    final String _paceText = double.parse(getTimeStringFromDouble(pace))
        .toStringAsFixed(1)
        .replaceAll('.', ':');
    final String _paceTextFormatted =
        _paceText.length == 3 ? '0${_paceText}0' : '${_paceText}0';
    return _paceTextFormatted;
  }

  String getTimeStringFromDouble(double value) {
    final int flooredValue = value.floor();
    final double decimalValue = value - flooredValue;
    final String hourValue = getHourString(flooredValue);
    final String minuteString = getMinuteString(decimalValue);

    return '$hourValue.$minuteString';
  }

  String getTimeStringFromDoubleProfile(double value) {
    final int flooredValue = value.floor();
    final double decimalValue = value - flooredValue;
    final String hourValue = getHourString(flooredValue);
    final String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }
}

extension ToastExtension on void {
  Future<void> toastUnexpectedError() {
    return Fluttertoast.showToast(
        msg: 'Unexpected error happened',
        fontSize: 16.0,
        gravity: ToastGravity.CENTER);
  }
}

extension UserData on void {
  num getDistance({required num distance}) {
    if (PreferenceUtils.getIsUserUnitInKM()) {
      if (distance > 150) {
        return 150;
      }
      if (distance < 3) {
        return 4.0;
      }
    } else {
      if (distance > 94) {
        return 94.0;
      }
      if (distance < 2.5) {
        return 2.5;
      }
    }

    return distance;
  }

  String distance({required num distance}) {
    return '$distance ${PreferenceUtils.getIsUserUnitInKM() ? 'km' : 'mile'}';
  }

  String getOpponentName({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.nickName;
    }

    return model.battleUsers[1].applicationUser.nickName;
  }

  String? getOpponentPhoto({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.photoLink;
    }

    return model.battleUsers[1].applicationUser.photoLink;
  }

  String getOpponentRank({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.rank.toString();
    }

    return model.battleUsers[1].applicationUser.rank.toString();
  }

  int? getMyBattleStatus({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return model.battleUsers[0].batlleStatus?.toInt();
    }

    return model.battleUsers[1].batlleStatus?.toInt();
  }

//0001-01-01T00:00:00
  String getMyProofTime({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return getTimeWithOutDate(time: model.battleUsers[0].time);
    }

    return getTimeWithOutDate(time: model.battleUsers[1].time);
  }

  List<dynamic> getMyProofPhotos({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return model.battleUsers[0].photos;
    }

    return model.battleUsers[1].photos;
  }

  String getOpponentProofTime({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return getTimeWithOutDate(time: model.battleUsers[0].time);
    }

    return getTimeWithOutDate(time: model.battleUsers[1].time);
  }

  List<dynamic> getOpponentProofPhotos({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].photos;
    }

    return model.battleUsers[1].photos;
  }

  bool isNeedToCheckOpponentResults({required BattleUsers model}) =>
      model.photos != null &&
      model.photos.isNotEmpty &&
      !model.resultIsRejected &&
      !model.resultIsConfirmed;

  BattleUsers getOpponentBattleModel({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0];
    }

    return model.battleUsers[1];
  }

  BattleUsers getMyBattleModel({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return model.battleUsers[0];
    }

    return model.battleUsers[1];
  }

  //0001-01-01T00:00:00
  String getTimeWithOutDate({required String time}) {
    return time.substring(11, 19);
  }

  String getDateWithOutTime({required String date}) {
    return date.substring(0, 10);
  }

  String getOpponentId({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.id;
    }

    return model.battleUsers[1].applicationUser.id;
  }

  Messages? getChatMessageData({required List<Object> arguments}) {
    final Object data = arguments[0];
    if (data != null) {
      final Map<dynamic, dynamic> dataMessage = data as Map<dynamic, dynamic>;
      final Messages model =
          Messages.fromJson(dataMessage as Map<String, dynamic>);
      return model;
    }
    return null;
  }

  bool getIfOpponentCreatedTheBattle({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].isCreater;
    }

    return model.battleUsers[1].isCreater;
  }

  double getCreateBattleDistanceMenuValue(
      {required String value, required double customValue}) {
    if (Constants.filterMenuThree == value) {
      return 3.0;
    } else if (Constants.filterMenuFive == value) {
      return 5.0;
    } else if (Constants.filterMenuTen == value) {
      return 10.0;
    } else if (Constants.filterMenuHalfMarathon == value) {
      return 21;
    } else if (Constants.filterMenuMarathon == value) {
      return 42;
    } else if (Constants.filterMenuCustom == value) {
      return customValue;
    }
    return 3.0;
  }
}

extension Authorization on void {
  Future<void> signInWithApple(
      {required BuildContext context,
      required Function(String token) onSuccess}) async {
    await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Constants.clientAppleServiceId,
          redirectUri: Uri.parse(Constants.redirectAppleUri),
        )).then((AuthorizationCredentialAppleID value) async {
      final String? token = value.identityToken;
      if (token != null) {
        onSuccess(token);
      }
    }).catchError((Object err) async {
      print('SignInWithApple: $err');
      await Fluttertoast.showToast(
          msg: 'Login error', fontSize: 16.0, gravity: ToastGravity.CENTER);
    });
  }

  Future<void> signInWithGoogle(
      {required BuildContext context,
      required Function(String token) onSuccess}) async {
    final  GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect().whenComplete(()  =>
     googleSignIn.signIn().then((GoogleSignInAccount? result) {
      result?.authentication.then((GoogleSignInAuthentication googleKey) async {
        print(googleKey.accessToken);
        final String? token = googleKey.accessToken;
        if (token != null) {
          onSuccess(token);
        }
      }).catchError((Object err) {
        print('inner error');
      });
    }).catchError((Object err) async {
      print('error occurred');
      await Fluttertoast.showToast(
          msg: 'Registration error: $err',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
    })
    );

  }
}

extension ScreenUtils on void {
  bool isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      final Size size = mediaQuery.size;
      if (size.height == 812.0 || size.width == 812.0) {
        return true;
      }
    }
    return false;
  }
}
