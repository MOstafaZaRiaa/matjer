import 'package:flutter/material.dart';

class MyColors {

  static const Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };
  static MaterialColor primarySwatch = const MaterialColor(0xFF880E4F, color);

  static const Color myPrimary = Color(0xFF880E4F);
  static const Color myGrey = Color(0xFF929292);
  static const Color myWhite = Color(0xffffffff);

}
