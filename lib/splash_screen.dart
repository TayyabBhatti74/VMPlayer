import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mp3_player/main.dart';
import 'package:mp3_player/onboarding_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final showHome = preferences.getBool('showHome') ?? false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5),(){
      showHome ? Get.off(()=> const HomeScreen()) : Get.off(()=> const OnBoardingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/icons/logo.png', height: 100.h, width: 100.w,)),
          Center(child: Lottie.asset('assets/icons/loading.json', width: 100.w)),
        ],
      ),
    );
  }
}
