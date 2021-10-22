import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/pending_detail_page/pending_detail_page.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;
import 'package:one2one_run/utils/signal_r.dart';

class PendingTab extends StatelessWidget {
  const PendingTab({
    Key? key,
    required this.pendingList,
    required this.currentUserId,
    required this.onTapAccept,
    required this.onTapChange,
    required this.onTapDecline,
    required this.signalR,
  }) : super(key: key);

  final List<BattleRespondModel> pendingList;
  final String currentUserId;
  final Function(String id, bool isNegotiate) onTapAccept;
  final Function(String id, BattleRespondModel model) onTapChange;
  final Function(String id) onTapDecline;
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
                      heightPercentage: 0.43,
            /*          heightPercentage: getIfOpponentCreatedTheBattle(
                              model: pendingList[index],
                              currentUserId: currentUserId)
                          ? 0.43
                          : 0.35,*/
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
                      isNeedButtons:true,
                    /*  isNeedButtons: getIfOpponentCreatedTheBattle(
                          model: pendingList[index],
                          currentUserId: currentUserId),*/
                      onTapAccept: onTapAccept,
                      onTapChange: onTapChange,
                      onTapDecline: onTapDecline,
                      statusCodeNum: pendingList[index].status.toInt(),
                      onTapCard: () async {
                        await Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    PendingDetailPage(
                                      pendingModel: pendingList[index],
                                      signalR: signalR,
                                      currentUserId: currentUserId,
                                    )));
                      },
                    );
                  }),
            )
          : showEmptyListText(height: height, width: width),
    );
  }
}
