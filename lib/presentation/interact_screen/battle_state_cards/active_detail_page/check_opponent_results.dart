import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/models/check_opponent_results_model.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CheckOpponentResultsPage extends StatelessWidget {
  CheckOpponentResultsPage(
      {Key? key, required this.model, required this.onTapResults})
      : super(key: key);

  final CheckOpponentResultsModel model;
  final Function(bool isAccepted) onTapResults;

  final RoundedLoadingButtonController _acceptBattleController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Center(
          child: Container(
            height: height - (height * 0.05),
            margin: EdgeInsets.symmetric(horizontal: width * 0.025),
            padding: EdgeInsets.all(width * 0.05),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 200,
                  blurRadius: 7,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Opponent',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: height * 0.12,
                    margin: EdgeInsets.symmetric(vertical: height * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffCDCDCD).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: height * 0.08,
                          width: height * 0.08,
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: userAvatarPhoto(photoUrl: model.userPhoto),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              model.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontFamily: 'roboto',
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  rankIcon,
                                  height: height * 0.015,
                                  width: height * 0.015,
                                  fit: BoxFit.fill,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 7.0,
                                ),
                                Text(
                                  'Rank ${model.rank}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontFamily: 'roboto',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.011,
                  ),
                  results(
                    width: width,
                    title: 'Time',
                    value: model.time,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  results(
                    width: width,
                    title: 'Distance',
                    value: model.distance,
                  ),
                  SizedBox(
                    height: height * 0.011,
                  ),
                  SizedBox(
                    height: height * 0.47,
                    width: width,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: model.battlePhotos[0],
                              fit: BoxFit.fill,
                              placeholder: (BuildContext context, String url) =>
                                  Container(
                                width: 60,
                                height: 60,
                                color: Colors.transparent,
                                child: Center(child: progressIndicator()),
                              ),
                            ),
                            Visibility(
                              visible: model.battlePhotos.length > 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: height * 0.02, bottom: height * 0.05),
                                child: CachedNetworkImage(
                                  imageUrl: model.battlePhotos.length > 1
                                      ? model.battlePhotos[1]
                                      : '',
                                  fit: BoxFit.fill,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.transparent,
                                    child: Center(child: progressIndicator()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: buildRoundedButton(
                            label: 'ACCEPT',
                            width: width,
                            height: 40.h,
                            buttonTextSize: 14.0,
                            controller: _acceptBattleController,
                            textColor: Colors.white,
                            backColor: redColor,
                            onTap: () {
                              onTapResults(true);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: buttonNoIcon(
                            title: 'REJECT',
                            color: Colors.transparent,
                            height: 40.h,
                            textColor: Colors.black,
                            buttonTextSize: 14.0,
                            shadowColor: Colors.transparent,
                            onPressed: () {
                              dialog(
                                  context: context,
                                  title: "Are you sure you want to reject the opponent's results?",
                                  text: 'You can open chat for discussion.',
                                  applyButtonText: 'REJECT',
                                  cancelButtonText: 'CANCEL',
                                  onApplyPressed: () {
                                    Navigator.pop(context);
                                    onTapResults(false);
                                    Navigator.pop(context);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget results(
      {required String title, required String value, required double width}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
                color: redColor,
                fontSize: 17.sp,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
