import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';

class PendingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: const Color(0xffF5F5F5),
      child: Center(
        child: _listItem(
          context: context,
          width: width,
          height: height,
        ),
      ),
    );
  }

  Widget _listItem({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    return Container(
      height: height * 0.41,
      width: width,
      padding: EdgeInsets.all(width * 0.035),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.025,
        vertical: height * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Battle name',
            style: TextStyle(
                color: Colors.red,
                fontSize: 18.sp,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: height * 0.017,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              statusLabel(
                  width: width,
                  title: 'Proposed',
                  color: const Color(0xffEDEDED),
                  icon: proposedIcon),
            ],
          ),
          SizedBox(
            height: height * 0.008,
          ),
          Row(
            children: [
              Container(
                height: height * 0.05,
                width: height * 0.05,
                margin: EdgeInsets.only(
                  right: width * 0.02,
                ),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 80,
                    backgroundImage:
                        /*model?.photoLink == null
                            ?*/
                        AssetImage(
                      defaultProfileImage,
                    ) as ImageProvider
                    /*    : NetworkImage(model!.photoLink!),*/
                    ),
              ),
              Text(
                'Opponent',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                'Issa mirage',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            margin: EdgeInsets.only(
              left: height * 0.062,
              bottom: height * 0.02,
            ),
            child: Text(
              'It will be a piece of cake!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w600),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: cardItem(
              height: height,
              width: width + width * 0.7,
              title: 'Time left',
              icon: weeklyDistanceIcon,
              value: '0 days 8 hours 49 minutes',
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: cardItem(
              height: height,
              width: width,
              title: 'Distance',
              icon: distanceIcon,
              value: '5.0 km',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.01),
            child: const Divider(
              height: 5,
              endIndent: 3.0,
              indent: 3.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonNoIcon(
                title: 'Accept',
                color: const Color(0xffCFFFB1),
                textColor: Colors.black87,
                width: width * 0.25,
                height: height * 0.055,
                buttonTextSize: 14.sp,
                onPressed: () async {},
              ),
              buttonNoIcon(
                title: 'Change',
                color: const Color(0xffEDEDED),
                textColor: Colors.black87,
                width: width * 0.25,
                height: height * 0.055,
                buttonTextSize: 14.sp,
                onPressed: () async {},
              ),
              buttonNoIcon(
                title: 'Decline',
                color: Colors.white,
                textColor: Colors.black87,
                width: width * 0.25,
                height: height * 0.055,
                buttonTextSize: 14.sp,
                onPressed: () async {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
