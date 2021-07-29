import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;

class FinishedTab extends StatelessWidget {
  const FinishedTab({
    Key? key,
    required this.pendingList,
    required this.currentUserId,
  }) : super(key: key);

  final List<BattleRespondModel> pendingList;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: const Color(0xffF5F5F5),
      child: pendingList.isNotEmpty
          ? Scrollbar(
              child: ListView.builder(
                  itemCount: pendingList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext con, int index) {
                    return interactListItem(
                      context: context,
                      width: width,
                      height: height,
                      heightPercentage: 0.245,
                      model: pendingList[index],
                      distance: distance(distance: pendingList[index].distance),
                      opponentName: getOpponentName(
                        model: pendingList[index],
                        currentUserId: currentUserId,
                      ),
                      opponentPhoto: getOpponentPhoto(
                        model: pendingList[index],
                        currentUserId: currentUserId,
                      ),
                      isNeedButtons: false,
                      isFinishedTab: true,
                      statusCodeNum: pendingList[index].status.toInt(),
                      myStatusCodeNum: getMyBattleStatus(
                        model: pendingList[index],
                        currentUserId: currentUserId,
                      ),
                    );
                  }),
            )
          : showEmptyListText(height: height, width: width),
    );
  }
}
