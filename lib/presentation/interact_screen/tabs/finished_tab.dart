import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;

class FinishedTab extends StatelessWidget {
  const FinishedTab({
    Key? key,
    required this.finishedList,
    required this.currentUserId,
  }) : super(key: key);

  final List<BattleRespondModel> finishedList;
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
      child: finishedList.isNotEmpty
          ? Scrollbar(
              child: ListView.builder(
                  itemCount: finishedList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext con, int index) {
                    return interactListItem(
                      context: context,
                      width: width,
                      height: height,
                      //heightPercentage: 0.245,
                      heightPercentage: 0.4,
                      model: finishedList[index],
                      distance:
                          distance(distance: finishedList[index].distance),
                      opponentName: getOpponentName(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ),
                      opponentPhoto: getOpponentPhoto(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ),
                      isNeedButtons: false,
                      isFinishedTab: true,
                      statusCodeNum: finishedList[index].status.toInt(),
                      myStatusCodeNum: getMyBattleStatus(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ),
                      myProofTime: getMyProofTime(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ),
                      myProofPhotos: getMyProofPhotos(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ).cast<String>(),
                      opponentProofTime: getOpponentProofTime(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ),
                      opponentProofPhotos: getOpponentProofPhotos(
                        model: finishedList[index],
                        currentUserId: currentUserId,
                      ).cast<String>(),
                      onTapCard: (){
                        // TODO(Issa): action.
                      },
                    );
                  }),
            )
          : showEmptyListText(height: height, width: width),
    );
  }
}
