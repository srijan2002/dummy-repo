import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int page = 0;
  @override
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    // init();
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            PageView(
              onPageChanged: (val) {
                setState(() {
                  page = val;
                });
              },
              controller: _controller,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Lottie.asset('assets/onboard.json'),
                        height: 50.h,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Text(
                          "Welcome to Casaliving. Find your favourite meals here!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w400),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Lottie.asset('assets/pay.json'),
                        height: 50.h,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Text(
                          "Select recommended plans or pay with coupons on the go!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w400),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Lottie.asset('assets/rent.json'),
                        height: 50.h,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Text(
                          "Choose from many options for rent and services. Let's begin!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w400),
                        ),
                      ))
                    ],
                  ),
                )
              ],
            ),
            Container(
                alignment: Alignment(0, 0.85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.sp)),
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        _controller.jumpToPage(2);
                      },
                    ),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: SlideEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          dotColor: Colors.grey.shade400,
                          activeDotColor: Colors.blue),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.sp)),
                        child: Text(
                          (page == 2) ? "Done" : "Next",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                        if (page == 2) {
                          Navigator.popAndPushNamed(context, '/onboard');
                        }
                      },
                    ),
                  ],
                ))
          ],
        )),
      );
    });
  }
}
