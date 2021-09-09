import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//NOte:'/faqHelper'
class FAQHelperPage extends StatelessWidget {
  FAQHelperPage({Key? key, required this.faqHelperState}) : super(key: key);

  final PageController _pageController = PageController();

  final FAQHelperState faqHelperState;

  final List<String> faqImages = <String>[
    faqHelp1,
    faqHelp2,
    faqHelp3,
    faqHelp4,
    faqHelp5,
    faqHelp6,
  ];

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;

    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              itemCount: _getPageCount(state: faqHelperState),
              itemBuilder: (_, int index) {
                return faqItem(
                    image: faqImages[
                        faqHelperState == FAQHelperState.InteractState
                            ? (index + 3)
                            : index],
                    height: height,
                    width: width);
              },
            ),
            Positioned(
              bottom: height * 0.01,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _getPageCount(state: faqHelperState),
                effect: JumpingDotEffect(
                  dotHeight: width * 0.032,
                  dotWidth: width * 0.032,
                  spacing: 10,
                  activeDotColor: redColor,
                  dotColor: lightGreenColor,
                  verticalOffset: 12.0,
                  // strokeWidth: 5,
                ),
              ),
            ),
            Positioned(
              right: 5.0,
              bottom: height * 0.03,
              child: buttonNoIcon(
                title: "Let's start",
                color: redColor.withOpacity(0.6),
                height: height * 0.045,
                width: width * 0.02,
                textColor: Colors.white,
                buttonTextSize: 14.0,
                onPressed: () {
                  onClick(context: context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClick({required BuildContext context}) {
    if (faqHelperState == FAQHelperState.LoginState) {
      Navigator.of(context).pushReplacementNamed(Constants.homeRoute);
    } else if (faqHelperState == FAQHelperState.InteractState) {
      Navigator.of(context).pop();
    }
  }

  Widget faqItem(
      {required String image, required double width, required double height}) {
    return Image.asset(
      image,
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
  }

  int _getPageCount({required FAQHelperState state}) {
    if (state == FAQHelperState.LoginState ||
        state == FAQHelperState.InteractState) {
      return 3;
    } else if (state == FAQHelperState.HelpState) {
      return 6;
    }

    return 0;
  }
}
