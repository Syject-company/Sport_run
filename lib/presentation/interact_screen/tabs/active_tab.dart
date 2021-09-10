import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/presentation/interact_screen/battle_state_cards/active_detail_page/active_detail_page.dart';
import 'package:one2one_run/utils/extension.dart' show UserData;
import 'package:one2one_run/utils/signal_r.dart';

class ActiveTab extends StatelessWidget {
  const ActiveTab({
    Key? key,
    required this.activeList,
    required this.currentUserId,
    required this.onNeedToRefreshActivePage,
    required this.signalR,
  }) : super(key: key);

  final List<BattleRespondModel> activeList;
  final String currentUserId;
  final VoidCallback onNeedToRefreshActivePage;
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
      child: activeList.isNotEmpty
          ? Scrollbar(
              child: ListView.builder(
                  itemCount: activeList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext con, int index) {
                    return interactListItem(
                      context: context,
                      width: width,
                      height: height,
                      heightPercentage: 0.34,
                      model: activeList[index],
                      distance: distance(distance: activeList[index].distance),
                      opponentName: getOpponentName(
                        model: activeList[index],
                        currentUserId: currentUserId,
                      ),
                      opponentPhoto: getOpponentPhoto(
                        model: activeList[index],
                        currentUserId: currentUserId,
                      ),
                      isNeedButtons: false,
                      statusCodeNum: activeList[index].status.toInt(),
                      onTapCard: () async {
                        await Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    ActiveDetailPage(
                                      activeModel: activeList[index],
                                      signalR: signalR,
                                      currentUserId: currentUserId,
                                      onNeedToRefreshActivePage:
                                          onNeedToRefreshActivePage,
                                    )));
                      },
                    );
                  }),
            )
          : showEmptyListText(height: height, width: width),
    );
  }
}
