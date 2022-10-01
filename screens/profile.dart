// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:path_provider/path_provider.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:casafoods_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:casafoods_app/screens/choose_address.dart';

class Show_Profile{
  void showProfile(BuildContext context) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        avoidStatusBar: true,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [1.0, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        extendBody: false,
        builder: (context, state) {
          return Settings();
        },
      );
    });
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Profile user = Profile();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration myBoxDec = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
    );
    EdgeInsets myPad = EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0);
    EdgeInsets btn = EdgeInsets.symmetric(vertical: 6.0);
    TextStyle btnText =
    TextStyle(color: Colors.black87, fontWeight: FontWeight.w500);

    return Material(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            color: Color(0xffF3F2F7),
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(
                                  "Account",
                                  style: TextStyle(
                                      fontSize: 15.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 1.4.h,
                              right: 3.w,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Done',
                                  style:
                                  TextStyle(color: Colors.blue, fontSize: 14.sp,fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                        decoration: myBoxDec,
                        child: Row(
                          children: [
                            Container(
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
                            Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              height: 60.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ("${Provider.of<Users>(context, listen: false).name}") ,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                  "${Provider.of<Users>(context, listen: false).email}",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black54),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      //
                      const SizedBox(
                        height: 20.0,
                      ),
                      //
                      Container(
                        padding: myPad,
                        decoration: myBoxDec,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: ()
                        { Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (_) => ChooseLocationScreen(),
                        ),
                        );},
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Manage Address",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Manage Payment Methods",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed("/referral");
                              },
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Invite & Earn",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      const SizedBox(
                        height: 20.0,
                      ),
                      //
                      Container(
                        padding: myPad,
                        decoration: myBoxDec,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "My Orders",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //

                            InkWell(
                              onTap: () => Navigator.pushNamed(context, '/wallet'),
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Wallet",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                      //
                      const SizedBox(
                        height: 20.0,
                      ),
                      //
                      Container(
                        padding: myPad,
                        decoration: myBoxDec,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed("/termsandconditions"),
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Terms & Conditions",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed("/privacypolicy"),
                              child: Container(
                                padding: btn,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Privacy Policy",
                                      style: btnText,
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                      //
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  margin: EdgeInsets.only(bottom: 30.0),
                  decoration: myBoxDec,
                  child: InkWell(
                    onTap: ()async{
                      GoogleAuth().signOut();
                      Provider.of<Users>(context, listen: false).setData("", "", "", "","");
                      // Navigator.popUntil(context, ModalRoute.withName('/home'));
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    child: Container(
                      padding: btn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign Out",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: Colors.blue),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}