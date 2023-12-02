import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mp3_player/home_screen.dart';
import 'package:mp3_player/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  final pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 60.h),
        child: PageView(
          controller: pageController,
          onPageChanged: (index){
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            buildPage(
              urlImage: 'assets/icons/music1.png',
              title: 'GrooveHub',
              subTitle: "Streamline your music experience with GrooveHub's user-friendly interface, playlists, and offline mode."
            ),
            buildPage(
                urlImage: 'assets/icons/music2.png',
                title: 'HarmoniPlay',
                subTitle: "HarmoniPlay offers high-quality audio and a 10-band equalizer for a personalized music journey."
            ),
            buildPage(
                urlImage: 'assets/icons/music3.png',
                title: 'SoundWave',
                subTitle: "SoundWave recommends tracks and brings your music to life with visuals and smooth transitions."
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage ? Padding(
        padding: const EdgeInsets.all(10),
        child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              backgroundColor: Colors.deepPurple,
              minimumSize: Size.fromHeight(50.h),
            ),
          onPressed: () {
          preferences.setBool('showHome', true);
          Get.off(()=> HomeScreen());
        }, child: const Text('Get Started')),
      )
          :
      Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              pageController.jumpToPage(2);
            }, child: const Text('SKIP')),
            Center(
              child: SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect:  const WormEffect(
                    spacing: 16,
                    dotColor: Colors.black,
                    activeDotColor: Colors.deepPurple,
                  ),
                  onDotClicked: (index){
                    pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  },
              ),
            ),
            TextButton(onPressed: (){
              pageController.nextPage(duration: const Duration(microseconds: 500), curve: Curves.easeInOut);
            }, child: const Text('NEXT')),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required String urlImage,
    required String title,
    required String subTitle,
}) => Container(
    color: Colors.grey.shade300,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          urlImage,
          fit: BoxFit.contain,
          width: 150.w,
          height: 150.h,
        ),
        SizedBox(height: 60.h,),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 20.h,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 5.h),
          child: Text(
            subTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp
            ),
          ),
        ),
      ],
    ),
  );

}

