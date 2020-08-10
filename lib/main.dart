import 'package:ellyvate/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_splash/custom_splash.dart';

void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(new MaterialApp(

    title: 'EllyVate',
    debugShowCheckedModeBanner: false,
    home: CustomSplash(
      imagePath: 'assets/images/logo.png',
      backGroundColor: Colors.white,
      animationEffect: 'fade-in',
      duration: 2500,
      type: CustomSplashType.StaticDuration,
      home: Home(),
    ),
  ));
}

Map<int, Widget> op = {1: Home()};
