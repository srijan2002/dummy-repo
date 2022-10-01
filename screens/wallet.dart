import 'package:casafoods_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:casafoods_app/widgets/coupon_widget.dart';
import 'package:casafoods_app/screens/profile.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Dio dio = Dio();
  var normal = 0;
  var special = 0;
  var normal_coupon = 0;
  var special_coupon = 0;

  dynamic getCoupon() async {
    var response = await dio.get('https://api.casaworld.in/api/getwallet',
      options: Options(
        headers: {
          "Authorization":'Bearer ${Provider.of<Users>(context, listen: false).token}'
        }
      )
    );
    setState(() {
      normal_coupon = response.data['normal_coupons'];
      special_coupon = response.data['special_coupons'];
      // print(normal);print(special);
    });
  }

  dynamic getPrice() async {
    var response = await dio.get('https://api.casaworld.in/api/config',
      options: Options(
        headers: {
          "Authorization":'Bearer ${Provider.of<Users>(context, listen: false).token}'
        }
      )
    );
    setState(() {
      normal = response.data['data']['attributes']['normal_coupon_price'];
      special = response.data['data']['attributes']['special_coupon_price'];
      print(normal);
      print(special);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await getPrice();
      await getCoupon();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Wallet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.sp,
                      )),
                  GestureDetector(
                    onTap: () async {
                      Show_Profile().showProfile(context);
                    },
                    child: Container(
                      child: (Provider.of<Users>(context, listen: false).imageUrl!=null)?CircleAvatar(
                          radius: 16.sp,
                          backgroundImage:  NetworkImage('${Provider.of<Users>(context, listen: false).imageUrl}')
                      ):CircleAvatar(
                          radius: 16.sp,
                          backgroundImage:  AssetImage('assets/memoji.png')
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
              child: Container(
                padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        1.5,
                        0.5,
                      ),
                      blurRadius: 1.sp,
                      spreadRadius: 0.1.sp,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                ),
                height: 15.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          "Normal Dinner",
                          style: TextStyle(
                              fontSize: 11.5.sp, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    // SizedBox(height: 3.h,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "${normal_coupon}",
                              style: TextStyle(
                                  fontSize: 24.sp, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 1.5.w,
                            ),
                            Text(
                              "Remaining",
                              style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            // makePayment();
                            // var price = await getPrice('normal_coupon');
                            Coupon_Widget()
                                .showCoupon(context, "Normal", normal);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Colors.blue),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 1.5.h),
                            child: Center(
                              child: Text(
                                "Buy Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
              child: Container(
                padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.sp),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(
                        1.5,
                        0.5,
                      ),
                      blurRadius: 1.sp,
                      spreadRadius: 0.1.sp,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                ),
                height: 15.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          "Special Dinner",
                          style: TextStyle(
                              fontSize: 11.5.sp, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    // SizedBox(height: 3.h,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "${special_coupon}",
                              style: TextStyle(
                                  fontSize: 24.sp, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 1.5.w,
                            ),
                            Text(
                              "Remaining",
                              style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            // makePayment();
                            // var price = await getPrice();
                            Coupon_Widget()
                                .showCoupon(context, "Special", special);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Colors.blue),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 1.5.h),
                            child: Center(
                              child: Text(
                                "Buy Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 0,horizontal: 6.w),
            //   child: Row(children: [Text("Manage Payment Methods",style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w500),)],),
            // ),
            // Padding(
            //   padding:  EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 1.h),
            //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         child: Row(
            //           children: [
            //             Container(
            //               height: 6.h,
            //               width: 14.w,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage(
            //                       'assets/visa.png'),
            //                   fit: BoxFit.fill,
            //                 ),
            //               ),
            //             ),
            //             SizedBox(width: 4.w,),
            //             Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("4767xxxxxxxx053",style: TextStyle(fontSize: 11.5.sp),),
            //                 Text("Romit Karmakar",style: TextStyle(fontSize: 10.sp),),
            //               ],
            //             )
            //           ],
            //         ),
            //
            //       ),
            //       Icon(Icons.edit_note_outlined,size: 27.sp,color: Colors.black,)
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding:  EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 1.h),
            //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         child: Row(
            //           children: [
            //             Container(
            //               height: 6.h,
            //               width: 14.w,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage(
            //                       'assets/mastercard.png'),
            //                   fit: BoxFit.fill,
            //                 ),
            //               ),
            //             ),
            //             SizedBox(width: 4.w,),
            //             Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("4767xxxxxxxx053",style: TextStyle(fontSize: 11.5.sp),),
            //                 Text("Romit Karmakar",style: TextStyle(fontSize: 10.sp),),
            //               ],
            //             )
            //           ],
            //         ),
            //
            //       ),
            //       Icon(Icons.edit_note_outlined,size: 27.sp,color: Colors.black,)
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding:  EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 1.h),
            //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         child: Row(
            //           children: [
            //             Container(
            //               height: 6.h,
            //               width: 14.w,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage(
            //                       'assets/upi.jpg'),
            //                   fit: BoxFit.fill,
            //                 ),
            //               ),
            //             ),
            //             SizedBox(width: 4.w,),
            //             Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("4767xxxxxxxx053",style: TextStyle(fontSize: 11.5.sp),),
            //                 Text("Romit Karmakar",style: TextStyle(fontSize: 10.sp),),
            //               ],
            //             )
            //           ],
            //         ),
            //
            //       ),
            //       Icon(Icons.edit_note_outlined,size: 27.sp,color: Colors.black,)
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
