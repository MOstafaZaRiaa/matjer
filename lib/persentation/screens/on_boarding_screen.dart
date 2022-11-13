import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../constance/colors.dart';
import '../../constance/strings.dart';
import '../../helper/shared_prefrence_helper.dart';
import 'login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return IntroductionScreen(
      pages: [
        buildPageViewModel(
          deviceWidth,
          'Let\'s to shop our needs.',
          'Here you can find all different clothes.',
          'assets/images/on_boarding/img3.svg',
          context,
        ),
        buildPageViewModel(
          deviceWidth,
          'Very beautiful staff.',
          'Here you can find all different phones.',
          'assets/images/on_boarding/img2.svg',
          context,
        ),
        buildPageViewModel(
          deviceWidth,
          'Order now what you favorite.',
          'Here you can receive products immediately.',
          'assets/images/on_boarding/img1.svg',
            context,
        ),
      ],
      onDone: () {
        SharedPreferenceHelper.saveData(key: isFirstUse, value: false).then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          ),
        );
      },
      done: const Text(
        'Order Now',
        style: TextStyle(
          color: MyColors.myPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      showSkipButton: true,
      nextFlex: 1,
      dotsFlex: 1,
      skip: const Text(
        'Skip',
        style: TextStyle(
          color: MyColors.myPrimary,
          fontSize: 16,
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: MyColors.myPrimary,
      ),
      animationDuration: 1000,
      dotsDecorator: DotsDecorator(
          activeColor: MyColors.myPrimary,
          size: const Size(10, 10),
          activeSize: const Size(22, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          )),
    );
  }

  PageViewModel buildPageViewModel(
    double deviceWidth,
    String title,
    String body,
    String image,
      context,
  ) {
    return PageViewModel(
      title: title,
      body: body,
      image: SvgPicture.asset(
        image,
        width: deviceWidth * 0.7,
      ),
      decoration: PageDecoration(
        titleTextStyle:  TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1!.color!
        ),
        bodyTextStyle:  TextStyle(
          fontSize: 20,
            color: Theme.of(context).textTheme.subtitle1!.color!

        ),
        imagePadding: const EdgeInsets.all(24).copyWith(
          bottom: 0,
        ),
      ),
    );
  }
}
