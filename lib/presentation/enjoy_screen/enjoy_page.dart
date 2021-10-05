import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/data/apis/enjoy_api.dart';
import 'package:one2one_run/data/models/enjoy_response_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/extension.dart';
import 'package:one2one_run/utils/preference_utils.dart';

//NOte:'/enjoy'
class EnjoyPage extends StatelessWidget {
  EnjoyPage({Key? key}) : super(key: key);

  final EnjoyApi _enjoyApi = EnjoyApi();

  late final UserModel _currentUserModel;

  @override
  Widget build(BuildContext context) {
    _currentUserModel = PreferenceUtils.getCurrentUserModel();
    final double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            MediaQuery.of(context).padding.bottom);
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<List<EnjoyResponseModel>?>(
        future: _enjoyApi.getEnjoyList(),
        builder: (BuildContext context,
            AsyncSnapshot<List<EnjoyResponseModel>?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: <Widget>[
                Container(
                  height: height * 0.072,
                  width: width,
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.025,
                    vertical: height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        rankIcon,
                        height: height * 0.025,
                        width: height * 0.025,
                        fit: BoxFit.fill,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 7.0,
                      ),
                      Text(
                        'You ranked #${_currentUserModel.rank}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height - (height * 0.214),
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext con, int index) {
                          return userCardEnjoy(
                            context: context,
                            width: width,
                            height: height,
                            model: snapshot.data![index],
                            distance:
                                '${snapshot.data![index].weeklyDistance.toStringAsFixed(snapshot.data![index].isMetric ? 0 : 1)} ${snapshot.data![index].isMetric ? 'km' : 'mile'}',
                          );
                        }),
                  ),
                ),
              ],
            );
          }
          return Container(
            width: width,
            height: height,
            color: const Color(0xffF5F5F5),
            child: Center(child: progressIndicator()),
          );
        });
  }
}
