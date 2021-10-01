import 'package:flutter/material.dart';
import 'package:one2one_run/components/widgets.dart';
import 'package:one2one_run/resources/colors.dart';
import 'package:one2one_run/resources/images.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//NOte:'/faqHelper'
class FAQHelperPage extends StatefulWidget {
  const FAQHelperPage({Key? key, required this.faqHelperState})
      : super(key: key);

  final FAQHelperState faqHelperState;

  @override
  FAQHelperPageState createState() => FAQHelperPageState();

}
class FAQHelperPageState extends State<FAQHelperPage> {
  final PageController _pageController = PageController();

  final List<String> _faqImages = <String>[
    faqHelp1,
    faqHelp2,
    faqHelp3,
    faqHelp4,
    faqHelp5,
    faqHelp6,
  ];

   bool isNeedToShowGoButton = false;


  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
         if(_pageController.page == (widget.faqHelperState == FAQHelperState.LoginState ||
             widget.faqHelperState == FAQHelperState.InteractState ? 2: 5)){
           isNeedToShowGoButton = true;
         } else {
           isNeedToShowGoButton = false;
         }
         setState((){});
    });
  }

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
              scrollDirection: Axis.vertical,
              itemCount: _getPageCount(state: widget.faqHelperState),
              itemBuilder: (_, int index) {
                return faqItem(
                    image: _faqImages[
                    widget.faqHelperState == FAQHelperState.InteractState
                            ? (index + 3)
                            : index],
                    height: height,
                    width: width);
              },
            ),
            Positioned(
              right: height * 0.01,
              child: SmoothPageIndicator(
                axisDirection: Axis.vertical,
                controller: _pageController,
                count: _getPageCount(state: widget.faqHelperState),
                effect: SlideEffect(
                  dotHeight: width * 0.022,
                  dotWidth: width * 0.022,
                  spacing: 5,
                  activeDotColor: redColor,
                  dotColor: Colors.grey.shade300,
                  // strokeWidth: 5,
                ),
              ),
            ),
            Positioned(
              right: 5.0,
              bottom: height * 0.03,
              child: Visibility(
                visible: isNeedToShowGoButton,
                child: buttonNoIcon(
                  title: "Let's Go  ->",
                  color: redColor,
                  height: height * 0.055,
                  width: width * 0.02,
                  textColor: Colors.white,
                  buttonTextSize: 14.0,
                  onPressed: () {
                    onClick(context: context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClick({required BuildContext context}) {
    if (widget.faqHelperState == FAQHelperState.LoginState) {
      Navigator.of(context).pushReplacementNamed(Constants.homeRoute);
    } else if (widget.faqHelperState == FAQHelperState.InteractState ||
        widget.faqHelperState == FAQHelperState.HelpState) {
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
    }
    return 6;
  }
}
