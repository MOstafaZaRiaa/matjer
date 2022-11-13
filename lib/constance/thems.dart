import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matjer/constance/colors.dart';

ThemeData darkTheme = ThemeData(
    fontFamily: 'jannah',
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
    ),
    primarySwatch: MyColors.primarySwatch,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyColors.myPrimary,
        unselectedItemColor: Colors.grey),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.myPrimary,
            statusBarIconBrightness: Brightness.light),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold)),
    scaffoldBackgroundColor: Colors.black.withOpacity(1.0),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
    ));
ThemeData lightTheme = ThemeData(
  fontFamily: 'jannah',
  primarySwatch: MyColors.primarySwatch,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.myPrimary),
  appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyColors.myPrimary,
          statusBarIconBrightness: Brightness.light),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)),
  scaffoldBackgroundColor: Colors.white,
  textTheme:  TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
    bodyText2: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
    subtitle1:TextStyle(
        fontSize: 14.0,  color: Colors.black),
  ),
);
