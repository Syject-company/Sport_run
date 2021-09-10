import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/utils/preference_utils.dart';

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
    required TimeOfDay time,
  }) {
    return DateFormat('yyyy-MM-dd HH:mm').format(
        DateTime(date.year, date.month, date.day, time.hour, time.minute)
            .toLocal());
  }

//0001-01-01T00:00:00
  String getFormattedTimeForServer({
    required TimeOfDay time,
  }) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss")
        .format(DateTime(1, 1, 1, time.hour, time.minute).toLocal());
  }

//00:00
  String getFormattedTimeForUser({
    required TimeOfDay time,
  }) {
    return DateFormat('HH:mm').format(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, time.hour, time.minute)
        .toLocal());
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
      if (distance > 11) {
        return 11.0;
      }
      if (distance < 2) {
        return 2.0;
      }
    } else {
      if (distance > 18) {
        return 18.0;
      }
      if (distance < 3) {
        return 3.0;
      }
    }

    return distance;
  }

  String distance({required num distance}) {
    return PreferenceUtils.getIsUserUnitInKM()
        ? '${getDistance(distance: distance).toStringAsFixed(0)} km'
        : '${getDistance(distance: distance).toStringAsFixed(1)} mile';
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

  String getTimeWithOutDate({required String time}) {
    return time.substring(11, 16);
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

}
