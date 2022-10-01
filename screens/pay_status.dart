import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';
class PayStatus extends StatefulWidget {
  const PayStatus({Key? key}) : super(key: key);

  @override
  State<PayStatus> createState() => _PayStatusState();
}

class _PayStatusState extends State<PayStatus> {
  dynamic data={};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            body: SafeArea(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Container(
                              // color: Colors.amber,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (data['status']=="SUCCESS"||data['status']=="SUCCESSFUL")?Lottie.asset('assets/success.json'):Lottie.asset('assets/failure.json'),
                                Text(
                                  (data['status']=="SUCCESS")? "Payment Successful !":(data['status']=="SUCCESSFUL")?"Table Booking Successful !":((data['status']=="CANCELLED")?"Payment Cancelled !":"Payment failed !"),
                                  style:   TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    letterSpacing: 1.sp),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            height: 95.h,
                    ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 2.5.h,
                        left: 4.w,
                        child:  Row(
                          children: [
                            InkWell(
                              onTap: (){Navigator.pop(context);},
                              child: Icon(
                                Icons.arrow_back,size: 25.sp,
                              ),
                            )
                          ],
                        ),
                      )
                    ]
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
