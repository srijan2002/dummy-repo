import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'home.dart';
import 'package:casafoods_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casafoods_app/services/secure_storage.dart';
import 'package:casafoods_app/widgets/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Dio dio = Dio();
  Secure_Storage storage = Secure_Storage();

  void showDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Loading(),
    );
  }

  Future getUser(String token) async {
    GoogleSignInAccount? googleSignInAccount = GoogleAuth.currentUser();
    try {
      var response = await dio.post('https://api.casaworld.in/api/user/phone',
          data: {
            "data": {
              'phoneNumber': "",
              "email": "${googleSignInAccount!.email}"
            }
          },
          options: Options(headers: {"Authorization": 'Bearer ${token}'}));

      return response.data;
    } catch (e) {
      return null;
    }
  }

  void signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";
    bool CheckValue = prefs.containsKey('intValue');
    bool checkBoard = prefs.containsKey('boarded');
    showDialogue(context);
    bool isSignedIn = await GoogleAuth().signIn();
    print(CheckValue);
    print(checkBoard);
    if (isSignedIn == true) {
      String token = await storage.getAll();
      dynamic user = await getUser(token);
      print(user);
      if (user['phoneNumber'] == null || user['phoneNumber'] == "") {
        // hideProgressDialogue(context);
        Navigator.pushNamed(context, '/profile');
      } else {
        Provider.of<Users>(context, listen: false)
            .setData("", "", null, token, user['phoneNumber']);
        Secure_Storage().addNewItem(user['phoneNumber'], "phone");
        // hideProgressDialogue(context);
        (CheckValue == true)
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => Home()),
                (route) => false)
            : (checkBoard == true)
                ? Navigator.popAndPushNamed(context, '/onboard')
                : Navigator.popAndPushNamed(context, '/onboarding');
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 7.h, 0, 0),
                      child: Container(
                        height: 9.h,
                        child: Center(
                          child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText("Casa Foods",
                                    textStyle: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.bold),
                                    duration: Duration(seconds: 2),
                                    fadeInEnd: 0.7,
                                    fadeOutBegin: 0.9)
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      child: Lottie.asset('assets/login.json'),
                      height: 50.h,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            signIn();
                          },
                          child: Container(
                            width: 100.w,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              // color: Color(0xfff7f7f7),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/google.png",
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/phone');
                            },
                            child: Container(
                              width: 100.w,
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.activeBlue,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign in with Phone Number",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        );
      },
    );
  }
}
