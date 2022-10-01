import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:sizer/sizer.dart';
import 'package:casafoods_app/services/secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:casafoods_app/services/auth.dart';
import 'package:casafoods_app/providers/time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Choose_Plan extends StatefulWidget {
  const Choose_Plan({Key? key}) : super(key: key);

  @override
  State<Choose_Plan> createState() => _Choose_PlanState();
}

class _Choose_PlanState extends State<Choose_Plan> {
  var _razorpay = Razorpay();
  List a = [];
  List b = [];
  int x = 1;
  bool pay = true;
  double _standardSliderValue = 20;
  double _premiumSliderValue = 20;
  Dio dio = Dio();
  var normal = 0;
  var special = 0;
  Secure_Storage storage = Secure_Storage();
  double amount = 0;
  dynamic monthly = {};
  dynamic yearly = {};
  String status = "";

  dynamic getCouponPrice() async {
    var response = await dio.get('https://api.casaworld.in/api/config',
        options: Options(headers: {
          "Authorization":
              'Bearer ${Provider.of<Users>(context, listen: false).token}'
        }));
    setState(() {
      normal = response.data['data']['attributes']['normal_coupon_price'];
      special = response.data['data']['attributes']['special_coupon_price'];
    });
  }

  dynamic getPlanPrice() async {
    dio.options.headers["Authorization"] =
        'Bearer ${Provider.of<Users>(context, listen: false).token}';
    var response = await dio.get('https://api.casaworld.in/api/plans');
    a = response.data['data']
        .where((elem) => elem['attributes']['name'] == "monthly")
        .toList();
    b = response.data['data']
        .where((elem) => elem['attributes']['name'] == "yearly")
        .toList();
    monthly['normal'] = a[0]['attributes']['normal_coupon'];
    monthly['special'] = a[0]['attributes']['special_coupon'];
    monthly['amount'] = a[0]['attributes']['amount'].toDouble();
    monthly['id'] = a[0]['id'];
    yearly['normal'] = b[0]['attributes']['normal_coupon'];
    yearly['special'] = b[0]['attributes']['special_coupon'];
    yearly['amount'] = b[0]['attributes']['amount'].toDouble();
    yearly['id'] = b[0]['id'];
    setState(() {
      amount = monthly['amount'];
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment successful");
    setState(() {
      status = "SUCCESS";
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Payment Successful!"),
                duration: Duration(seconds: 2),
              ));
    Navigator.popAndPushNamed(context, '/home');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("payment failed");
    setState(() {
      status = "FAILED";
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Payment Failed!"),
                duration: Duration(seconds: 2),
              ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print("another wallet");
  }


  void payRazorpay(int amt) async{

    var order = await dio.post('https://api.casaworld.in/api/order',
        data: {
          'data':{
            "amount":amt*100,
            "key":"rzp_test_GkIS0bwSap5k2z",
            "secret":"Ht93VEXRl68mXVlLkC6bRB9O"
          }
        },options: Options(headers: {
          "Authorization":'Bearer ${Provider.of<Users>(context, listen: false).token}'
        })
    );
    print(order);

    var response = await dio.post('https://api.casaworld.in/api/orders',
        data: {
          'data':{
            "amount":amt,
            "normal_coupon": (pay == true)
                          ? (x == 1)
                              ? monthly['normal']
                              : yearly['normal']
                          : _standardSliderValue,
                      "special_coupon": (pay == true)
                          ? (x == 1)
                              ? monthly['special']
                              : yearly['special']
                          : _premiumSliderValue,
                      "plan": (pay == true)
                          ? (x == 1)
                              ? monthly['id']
                              : yearly['id']
                          : null,
            "orderId":order.data['orderId']
          }
        },options: Options(headers: {
          "Authorization":'Bearer ${Provider.of<Users>(context, listen: false).token}'
        })
    );

    print(response.data);

    var options = {
      'key': "rzp_test_GkIS0bwSap5k2z",
      'amount': amt*100, //in the smallest currency sub-unit.
      'name': 'Elite_Raven',
      'order_id': order.data['orderId'], // Generate order_id using Orders API
      'description': 'Payment Gateway using Razorpay API and Flutter',
      'timeout': 240, // in seconds
      'prefill': {'contact': '9330427421', 'email': 'srjnmajumdar8@gmail.com'},
      'send_sms_hash': true,
      'retry': {'enabled': true, 'max_count': 4},
      'image': 'https://www.carlogos.org/car-logos/tesla-logo-2000x2890.png',
      'theme': {'color': '#F50D94', 'backdrop_color': '#07E2FF'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }

  }

  Future payCashfree(int amt) async {
    var response = await dio.post('https://api.casaworld.in/api/orders',
        data: {
          'data': {
            "amount": amt,
            "normal_coupon": (pay == true)
                ? (x == 1)
                    ? monthly['normal']
                    : yearly['normal']
                : _standardSliderValue,
            "special_coupon": (pay == true)
                ? (x == 1)
                    ? monthly['special']
                    : yearly['special']
                : _premiumSliderValue,
            "plan": (pay == true)
                ? (x == 1)
                    ? monthly['id']
                    : yearly['id']
                : null
          }
        },
        options: Options(headers: {
          "Authorization":
              'Bearer ${Provider.of<Users>(context, listen: false).token}'
        }));
    print(response.data);
    print("\n");
    String stage = "TEST";
    // String paymentOption = "dc";
    String orderId = response.data['orderId'];
    String orderAmount = "${amt}";
    String tokenData = response.data['cftoken'];
    String customerName = "${Provider.of<Users>(context, listen: false).name}";
    String orderNote = "Food Coupons";
    String orderCurrency = "INR";
    String appId = "176106837794bf12c88c8ca426601671";
    String customerEmail =
        "${Provider.of<Users>(context, listen: false).email}";
    String customerPhone =
        "${Provider.of<Users>(context, listen: false).phone}";
    String notifyUrl = "https://api.casaworld.in/api/notify";
    Map<String, dynamic> inputs = {
      // "paymentModes":paymentOption,
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "customerPhone": customerPhone,
      "appId": appId,
      "customerEmail": customerEmail,
      "stage": stage,
      "notifyUrl": notifyUrl,
      "tokenData": tokenData
    };
    var id = response.data['id'];

    CashfreePGSDK.doPayment(inputs).then((value) async {
      print(value);
      if (value!['txStatus'] == "SUCCESS") {
        setState(() {
          status = "SUCCESS";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment Successful!"),
          duration: Duration(seconds: 2),
        ));
        Navigator.popAndPushNamed(context, '/home');
      } else if (value['txStatus'] == "CANCELLED") {
        setState(() {
          status = "CANCELLED";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment Failed!"),
          duration: Duration(seconds: 2),
        ));
      } else if (value['txStatus'] == "FAILED") {
        setState(() {
          status = "PENDING";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment Failed!"),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      String phone = await storage.getPhone();
      if (Provider.of<Users>(context, listen: false).name == "") {
        String token = await storage.getAll();
        String name = "";
        String email = "";
        GoogleSignInAccount? googleSignInAccount = GoogleAuth.currentUser();
        if (googleSignInAccount != null) {
          Provider.of<Users>(context, listen: false).setData(
              googleSignInAccount.displayName,
              googleSignInAccount.email,
              googleSignInAccount.photoUrl,
              token,
              phone);
        } else {
          name = await storage.getName();
          email = await storage.getEmail();
          Provider.of<Users>(context, listen: false)
              .setData(name, email, null, token, phone);
        }
      }
      Provider.of<Time>(context, listen: false).setTime(context);
      await getPlanPrice();
      await getCouponPrice();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool CheckValue = prefs.containsKey('boarded');
      if (CheckValue == false) prefs.setBool('boarded', true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Casa Foods",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.sp,
                                letterSpacing: 0.5.sp)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                    child: Container(
                      child: Lottie.asset('assets/plan.json'),
                      height: 55.h,
                    ),
                  ),
                ],
              ),
              Positioned(child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 1.h, 8.w, 0),
                child: Container(
                  height: 32.h,
                  decoration: BoxDecoration(
                      border: Border.all(color:Colors.blue,width: 1.5.sp),
                      boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(
                        -0.5,
                        0.5,
                      ),
                      blurRadius: 3.sp,
                      spreadRadius: 0.1.sp,
                    ),
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(
                        0.5,
                        0.5,
                      ),
                      blurRadius: 3.sp,
                      spreadRadius: 0.1.sp,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ], borderRadius: BorderRadius.circular(8.sp)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => showModalBottomSheet(
                                isDismissible: false,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.sp))),
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: 88.h,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    0, 2.h, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Container(
                                                      // color: Colors.blue,
                                                      width: 65.w,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        children: [
                                                          Text(
                                                            "Choose a Plan",
                                                            style: TextStyle(
                                                                fontSize:
                                                                15.sp,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context);
                                                        setState(() {
                                                          x = 1;
                                                          pay = true;
                                                          amount = monthly[
                                                          'amount'];
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                            3.w,
                                                            1.h,
                                                            5.w,
                                                            1.h),
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(
                                                              fontSize:
                                                              13.sp,
                                                              color: Colors
                                                                  .blue,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    6.w, 0, 6.w, 0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      x = 1 - x;
                                                    });
                                                    amount = (x == 1)
                                                        ? monthly['amount']
                                                        : yearly['amount'];
                                                  },
                                                  child: Container(
                                                    // height:23.h,
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12.sp),
                                                      border: Border.all(
                                                          color: (x == 1)
                                                              ? Colors.blue
                                                              : Colors
                                                              .transparent,
                                                          width: 2.sp),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                          Colors.grey,
                                                          offset:
                                                          const Offset(
                                                            -0.5,
                                                            0.5,
                                                          ),
                                                          blurRadius: 1.sp,
                                                          spreadRadius:
                                                          0.05.sp,
                                                        ),
                                                        BoxShadow(
                                                          color:
                                                          Colors.grey,
                                                          offset:
                                                          const Offset(
                                                            0.5,
                                                            0.5,
                                                          ),
                                                          blurRadius: 1.sp,
                                                          spreadRadius:
                                                          0.05.sp,
                                                        ), //BoxShadow
                                                        BoxShadow(
                                                          color:
                                                          Colors.white,
                                                          offset:
                                                          const Offset(
                                                              0.0, 0.0),
                                                          blurRadius: 0.0,
                                                          spreadRadius: 0.0,
                                                        ), //BoxShadow
                                                      ],
                                                    ),
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        3.w,
                                                        2.h,
                                                        3.w,
                                                        2.h),
                                                    child: Column(
                                                      children: [
                                                        Visibility(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "MONTHLY",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize: 14
                                                                        .sp,
                                                                    letterSpacing:
                                                                    0.5.sp),
                                                              ),
                                                              Icon(
                                                                (x == 0)
                                                                    ? CupertinoIcons
                                                                    .circle
                                                                    : CupertinoIcons
                                                                    .smallcircle_fill_circle_fill,
                                                                color: (x ==
                                                                    1)
                                                                    ? Colors
                                                                    .blue
                                                                    : Colors
                                                                    .grey
                                                                    .shade500,
                                                                size: 25.sp,
                                                              )
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "STANDARD COUPON",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize: 14
                                                                        .sp,
                                                                    letterSpacing:
                                                                    0.5.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "₹${monthly['amount'].toInt()}/month",
                                                                style: TextStyle(
                                                                    fontSize: 18
                                                                        .sp,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "₹${normal * _standardSliderValue.toInt()}",
                                                                style: TextStyle(
                                                                    fontSize: 18
                                                                        .sp,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "10% off",
                                                                style: TextStyle(
                                                                    fontSize: 12
                                                                        .sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: fromCssColor(
                                                                        '#24C658')),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        SizedBox(
                                                          height: 1.5.h,
                                                        ),
                                                        Visibility(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets
                                                                .fromLTRB(
                                                                0,
                                                                0,
                                                                2.w,
                                                                0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "₹${normal}/coupon",
                                                                  style: TextStyle(
                                                                      fontSize: 12
                                                                          .sp,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                ),
                                                                Text(
                                                                  "${_standardSliderValue.toInt()}",
                                                                  style: TextStyle(
                                                                      fontSize: 13
                                                                          .sp,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color:
                                                                      Colors.blue),
                                                                ),
                                                              ],
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                            ),
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: SizedBox(
                                                            height: 1.5.h,
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${monthly['normal']} Standard Coupons +",
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey.shade500,
                                                                        fontSize: 10.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${monthly['special']} Special Coupons. Cancel Anytime",
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey.shade500,
                                                                        fontSize: 10.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        Visibility(
                                                          visible: !pay,
                                                          child: SizedBox(
                                                            child: Slider(
                                                              activeColor: Colors
                                                                  .blue
                                                                  .withOpacity(
                                                                  0.7),
                                                              inactiveColor:
                                                              Colors
                                                                  .grey
                                                                  .shade400,
                                                              thumbColor:
                                                              Colors
                                                                  .white,
                                                              value:
                                                              _standardSliderValue,
                                                              max: 100,
                                                              divisions:
                                                              100,
                                                              onChanged:
                                                                  (double
                                                              value) {
                                                                setState(
                                                                        () {
                                                                      _standardSliderValue =
                                                                          value;
                                                                      amount = _standardSliderValue *
                                                                          normal +
                                                                          _premiumSliderValue *
                                                                              special;
                                                                    });
                                                              },
                                                            ),
                                                            height: 2.h,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    6.w, 0, 6.w, 0),
                                                child: InkWell(
                                                  child: Container(
                                                    // height: 23.h ,
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12.sp),
                                                      border: Border.all(
                                                          color: (x == 0)
                                                              ? Colors.blue
                                                              : Colors
                                                              .transparent,
                                                          width: 2.sp),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                          Colors.grey,
                                                          offset:
                                                          const Offset(
                                                            -0.5,
                                                            0.5,
                                                          ),
                                                          blurRadius: 1.sp,
                                                          spreadRadius:
                                                          0.05.sp,
                                                        ),
                                                        BoxShadow(
                                                          color:
                                                          Colors.grey,
                                                          offset:
                                                          const Offset(
                                                            0.5,
                                                            0.5,
                                                          ),
                                                          blurRadius: 1.sp,
                                                          spreadRadius:
                                                          0.05.sp,
                                                        ), //BoxShadow
                                                        BoxShadow(
                                                          color:
                                                          Colors.white,
                                                          offset:
                                                          const Offset(
                                                              0.0, 0.0),
                                                          blurRadius: 0.0,
                                                          spreadRadius: 0.0,
                                                        ), //BoxShadow
                                                      ],
                                                    ),
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        3.w,
                                                        2.h,
                                                        3.w,
                                                        2.h),
                                                    child: Column(
                                                      children: [
                                                        Visibility(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "YEARLY",
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey.shade400,
                                                                        fontSize: 14.sp,
                                                                        letterSpacing: 0.5.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    1.w,
                                                                  ),
                                                                  Container(
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          1.w,
                                                                          0.5.h,
                                                                          1.w,
                                                                          0.5.h),
                                                                      color: Colors.yellow,
                                                                      child: Text(
                                                                        "RECOMMENDED",
                                                                        style:
                                                                        TextStyle(
                                                                          color: Colors.red,
                                                                          fontSize: 7.sp,
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                              Icon(
                                                                (x == 1)
                                                                    ? CupertinoIcons
                                                                    .circle
                                                                    : CupertinoIcons
                                                                    .smallcircle_fill_circle_fill,
                                                                color: (x ==
                                                                    0)
                                                                    ? Colors
                                                                    .blue
                                                                    : Colors
                                                                    .grey
                                                                    .shade500,
                                                                size: 25.sp,
                                                              )
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "SPECIAL COUPON",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize: 14
                                                                        .sp,
                                                                    letterSpacing:
                                                                    0.5.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "₹${yearly['amount'].toInt()}/year",
                                                                style: TextStyle(
                                                                    fontSize: 18
                                                                        .sp,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "₹${special * _premiumSliderValue.toInt()}",
                                                                style: TextStyle(
                                                                    fontSize: 18
                                                                        .sp,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "25% off",
                                                                style: TextStyle(
                                                                    fontSize: 12
                                                                        .sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: fromCssColor(
                                                                        '#24C658')),
                                                              ),
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        SizedBox(
                                                          height: 1.5.h,
                                                        ),
                                                        Visibility(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets
                                                                .fromLTRB(
                                                                0,
                                                                0,
                                                                2.w,
                                                                0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "₹${special}/coupon",
                                                                  style: TextStyle(
                                                                      fontSize: 12
                                                                          .sp,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                                ),
                                                                Text(
                                                                  "${_premiumSliderValue.toInt()}",
                                                                  style: TextStyle(
                                                                      fontSize: 13
                                                                          .sp,
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      color:
                                                                      Colors.blue),
                                                                ),
                                                              ],
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                            ),
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: SizedBox(
                                                            height: 1.5.h,
                                                          ),
                                                          visible: !pay,
                                                        ),
                                                        Visibility(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${yearly['normal']} Standard Coupons +",
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey.shade500,
                                                                        fontSize: 10.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${yearly['special']} Special Coupons. Cancel Anytime",
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey.shade500,
                                                                        fontSize: 10.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          visible: pay,
                                                        ),
                                                        Visibility(
                                                          visible: !pay,
                                                          child: SizedBox(
                                                            child: Slider(
                                                              activeColor: Colors
                                                                  .blue
                                                                  .withOpacity(
                                                                  0.7),
                                                              inactiveColor:
                                                              Colors
                                                                  .grey
                                                                  .shade400,
                                                              thumbColor:
                                                              Colors
                                                                  .white,
                                                              value:
                                                              _premiumSliderValue,
                                                              max: 100,
                                                              divisions:
                                                              100,
                                                              onChanged:
                                                                  (double
                                                              value) {
                                                                setState(
                                                                        () {
                                                                      _premiumSliderValue =
                                                                          value;
                                                                      amount = _standardSliderValue *
                                                                          normal +
                                                                          _premiumSliderValue *
                                                                              special;
                                                                    });
                                                              },
                                                            ),
                                                            height: 2.h,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      x = 1 - x;
                                                    });
                                                    amount = (x == 1)
                                                        ? monthly['amount']
                                                        : yearly['amount'];
                                                  },
                                                ),
                                              ),
                                              (pay == true)
                                                  ? SizedBox(
                                                height: 3.h,
                                              )
                                                  : SizedBox(
                                                height: 6.3.h,
                                              ),
                                              Visibility(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    InkWell(
                                                      child: Text(
                                                        "Choose Pay as you Go",
                                                        style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            color: Colors
                                                                .blue),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          pay = !pay;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                                visible: pay,
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "By Proceeding you are agreeing to the Casa Foods Terms and Conditions. To learn more, click here.",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.grey
                                                              .shade500),
                                                    ),
                                                    width: 86.w,
                                                  ),
                                                ],
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10.w, 0, 10.w, 0),
                                            child: InkWell(
                                              child: Container(
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        4.w,
                                                        2.h,
                                                        4.w,
                                                        2.h),
                                                    child: Text(
                                                      "Proceed to Checkout",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        11.sp)),
                                              ),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                String pg = Provider.of<Time>(context, listen: false).pg;
                                                if(pg == "RAZORPAY")
                                                 payRazorpay(
                                                    amount.toInt());
                                                else if(pg == "CASHFREE")
                                                  payCashfree(
                                                      amount.toInt());

                                              },
                                            ),
                                          ),
                                          bottom: 2.h,
                                          width: 100.w,
                                        )
                                      ],
                                    );
                                  },
                                )).whenComplete(() => setState(() {
                              pay = true;
                            })),
                            child: Container(
                              width: 74.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.sp),
                                  color: Colors.blue),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Choose Your Plan",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "* Monthly/Yearly Coupons",
                            style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500),
                          ),
                          Text(
                            "* Normal and Special Coupons",
                            style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500),
                          ),
                          Text(
                            "* Choose Pay as you go",
                            style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),width: 100.w,bottom: 2.h,)
            ],
          )
        );
      }),
    );
  }
}
