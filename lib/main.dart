import 'package:ellyvate/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:animated_overflow/animated_overflow.dart';

final controller = FadeInController();

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
    home: Home(),
  ));
}

Map<int, Widget> op = {1: Home()};
