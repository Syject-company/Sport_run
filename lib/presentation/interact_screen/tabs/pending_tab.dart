import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/utils/extension.dart' show DistanceValue;
import 'package:one2one_run/utils/preference_utils.dart';

class PendingTab extends StatelessWidget {
  const PendingTab({
    Key? key,
    required this.pendingList,
    required this.currentUserId,
    required this.onTapAccept,
    required this.onTapChange,
    required this.onTapDecline,
  }) : super(key: key);

  final List<BattleRespondModel>? pendingList;
  final String currentUserId;
  final Function(String id) onTapAccept;
  final Function(String id, BattleRespondModel model) onTapChange;
  final Function(String id) onTapDecline;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: const Color(0xffF5F5F5),
      child: ListView.builder(
          itemCount: pendingList?.length,
          itemBuilder: (BuildContext con, int index) {
            return interactListItem(
              context: context,
              width: width,
              height: height,
              model: pendingList![index],
              distance: distance(distance: pendingList![index].distance),
              opponentName: getOpponentName(model: pendingList![index]),
              opponentPhoto: getOpponentPhoto(model: pendingList![index]),
              isNeedButtons: true,
              onTapAccept: onTapAccept,
              onTapChange: onTapChange,
              onTapDecline: onTapDecline,
              statusNum: 0,

            );
          }),
    );
  }

  String distance({required num distance}) {
    return PreferenceUtils.getIsUserUnitInKM()
        ? '${getDistance(distance: distance).toStringAsFixed(0)} km'
        : '${getDistance(distance: distance).toStringAsFixed(1)} mile';
  }

  String getOpponentName({required BattleRespondModel model}) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.nickName;
    }

    return model.battleUsers[1].applicationUser.nickName;
  }

  String? getOpponentPhoto({required BattleRespondModel model}) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.photoLink;
    }

    return model.battleUsers[1].applicationUser.photoLink;
  }
}
