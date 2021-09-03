import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/finished_discarded_detail_page/finished_discarded_detail_page.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;
import 'package:one2one_run/utils/signal_r.dart';

class FinishedTab extends StatelessWidget {
  const FinishedTab({
    Key? key,
    required this.finishedList,
    required this.currentUserId,
    required this.signalR,
  }) : super(key: key);

  final List<BattleRespondModel> finishedList;
  final String currentUserId;
  final SignalR signalR;

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
                      heightPercentage: finishedList[index].status.toInt() == 3
                          ? 0.29
                          : 0.245,
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
                      onTapCard: () async {
                        if (finishedList[index].status.toInt() == 6) {
                          await Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      FinishedDiscardedDetailPage(
                                        finishedModel: finishedList[index],
                                        signalR: signalR,
                                        currentUserId: currentUserId,
                                      )));
                        }
                      },
                    );
                  }),
            )
          : showEmptyListText(height: height, width: width),
    );
  }
}
