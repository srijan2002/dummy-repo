import 'package:casafoods_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:casafoods_app/services/secure_storage.dart';
import 'home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choose_plan.dart';
import 'onboarding.dart';
import 'package:email_validator/email_validator.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Dio dio = Dio();
  var id;
  String token = "";
  var type;
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = new TextEditingController(text: "");

  List<dynamic> countries = [];
  List<dynamic> copy = [];
  final TextEditingController country = new TextEditingController(text: "");
  String code = "";
  String dial_code = "+91";
  String name = "";
  String url = "https://flagcdn.com/48x36/in.png";
  var no = "";
  Future updateUser(String token) async {
    // dio.options.headers["Authorization"] = 'Bearer ${token}';
    print(token);
    Map<dynamic, dynamic> d = {
      "id": id,
      "firstname": firstname.text,
      "lastname": lastname.text,
    };
    if (type == 2)
      d['email'] = email.text;
    else
      d['phone'] = dial_code + phone.text;

    print(d);
    try {
      var response = await dio.post('https://api.casaworld.in/api/user/update',
          data: {"data": d},
          options: Options(headers: {"Authorization": 'Bearer ${token}'}));
      return response.data;
    } catch (e) {
      print(e);
      if (e is DioError) {
        String msg = "";
        if (e.response!.data['message'] == null) {
          setState(() {
            msg = e.response!.data['error']['message'];
          });
        } else {
          setState(() {
            msg = e.response!.data['message'];
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${msg}"),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  void submit() async {
    if (firstname.text == "" || lastname.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty Field"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    final bool isValid = EmailValidator.validate(email.text);
    if (type == 2 && isValid == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Incorrect Email format"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (type == 1 && phone.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty Field"),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    dynamic user = await updateUser(token);
    print(user);
    if (user == null) {
    } else {
      if (type == 2) {
        Secure_Storage().addNewItem(user['name'], "name");
        Secure_Storage().addNewItem(user['email'], "email");
        Secure_Storage().addNewItem(user['phoneNumber'], "phone");
        Provider.of<Users>(context, listen: false).setData(
            user['name'], user['email'], null, token, user['phoneNumber']);
      } else {
        print("type type");
        Secure_Storage().addNewItem(user['name'], "name");
        Secure_Storage().addNewItem(user['phoneNumber'], "phone");
        Provider.of<Users>(context, listen: false)
            .setData("", null, null, token, user['phoneNumber']);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool CheckValue = prefs.containsKey('intValue');
      bool checkBoard = prefs.containsKey('boarded');
      bool profile = prefs.containsKey('profile');
      if (profile == false) prefs.setBool('profile', true);
      print(CheckValue);
      print(checkBoard);
      (CheckValue == true)
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => Home()),
              (route) => false)
          : (checkBoard == true)
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => Choose_Plan()),
                  (route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => Onboarding()),
                  (route) => false);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) =>  Home()), (route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      String t = await Secure_Storage().getAll();
      print(token);
      setState(() {
        token = t;
      });
      var response = await dio.get('https://api.casaworld.in/api/user/getuser',
          options: Options(headers: {"Authorization": 'Bearer ${token}'}));
      setState(() {
        id = response.data['id'];
      });
      if (response.data['provider'] == 'google') {
        setState(() {
          type = 1;
        });
      } else {
        setState(() {
          type = 2;
        });
      }
      var ctr = await dio.get('https://triunits.com/countries.json');
      setState(() {
        countries = ctr.data;
        copy = ctr.data;
      });
      return response.data;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // data = ModalRoute.of(context)!.settings.arguments;
    return Sizer(
      builder: ((context, orientation, deviceType) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(7.w, 5.h, 0, 0),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                size: 20.sp,
                              ),
                            ],
                          ),
                          onTap: () async {
                            GoogleAuth().signOut();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7.w, 6.h, 7.w, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Update\nInformation",
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  child: Lottie.asset('assets/info.json'),
                                  height: 10.h,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("FIRST NAME",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Container(
                                      height: 6.h,
                                      child: TextField(
                                        controller: firstname,
                                        style: TextStyle(fontSize: 14.5.sp),
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.sp,
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.sp,
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("LAST NAME",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Container(
                                      child: TextField(
                                        controller: lastname,
                                        style: TextStyle(fontSize: 14.5.sp),
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.sp,
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.sp,
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
                                            )),
                                      ),
                                      height: 6.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 3.5.h, 5.w, 0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text((type == 2) ? "EMAIL" : "PHONE",
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    (type == 2)
                                        ? TextField(
                                            controller: email,
                                            style: TextStyle(fontSize: 14.5.sp),
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1.sp,
                                                      color:
                                                          Colors.grey.shade400),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1.sp,
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp),
                                                )),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                countries = copy;
                                              });
                                              showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: true,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      15.sp))),
                                                  builder: (context) =>
                                                      StatefulBuilder(builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setModalState) {
                                                        return Container(
                                                          height: 100.h,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            7.w,
                                                                            8.h,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_back_ios,
                                                                        size: 20
                                                                            .sp,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      countries =
                                                                          copy;
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                        7.w,
                                                                        3.h,
                                                                        7.w,
                                                                        2.5.h),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Select a Country",
                                                                      style: TextStyle(
                                                                          fontSize: 25
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            7.w),
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .search,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            3.w,
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              TextField(
                                                                            onChanged:
                                                                                (val) {
                                                                              setModalState(() {
                                                                                countries = copy.where((element) => element['name'].toLowerCase().contains(val.toLowerCase())).toList();
                                                                              });
                                                                              // print(countries);
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                                                                                fillColor: Colors.grey,
                                                                                border: InputBorder.none,
                                                                                hintText: 'Search..'),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.sp),
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100,
                                                                  ),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              2.w),
                                                                  height: 7.h,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 1.5.h,
                                                              ),
                                                              Flexible(
                                                                child: ListView
                                                                    .builder(
                                                                  // physics: NeverScrollableScrollPhysics(),
                                                                  // shrinkWrap: true,
                                                                  itemCount:
                                                                      countries
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          10.w,
                                                                          2.h,
                                                                          10.w,
                                                                          2.h),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            code =
                                                                                countries[index]['code'];
                                                                            dial_code =
                                                                                countries[index]['dial_code'];
                                                                            countries =
                                                                                copy;
                                                                            url =
                                                                                "https://flagcdn.com/48x36/${code.toLowerCase()}.png";
                                                                            print(code);
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                width: 5.w,
                                                                                height: 4.h,
                                                                                child: Image(
                                                                                  image: NetworkImage(
                                                                                    "https://flagcdn.com/48x36/${countries[index]['code'].toLowerCase()}.png",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 3.w,
                                                                              ),
                                                                              Container(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Text(
                                                                                      "${countries[index]['name'].toUpperCase()}",
                                                                                      softWrap: false,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                constraints: BoxConstraints(maxWidth: 50.w),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5.w,
                                                                              ),
                                                                              Text(
                                                                                "${countries[index]['dial_code']}",
                                                                                softWrap: false,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.fade,
                                                                                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 13.sp),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }));
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.w),
                                                    height: 6.h,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down_sharp,
                                                          color: Colors.black,
                                                          size: 20.sp,
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Text(
                                                          "${dial_code}",
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12.sp),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.sp),
                                                        color: Colors
                                                            .grey.shade100,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w),
                                                      height: 6.h,
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        controller: phone,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            countries = copy
                                                                .where((element) => element[
                                                                        'name']
                                                                    .toLowerCase()
                                                                    .contains(val
                                                                        .toLowerCase()))
                                                                .toList();
                                                          });
                                                          // print(countries);
                                                        },
                                                        style: TextStyle(
                                                            letterSpacing: 1),
                                                        decoration: InputDecoration(
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    12.sp),
                                                            fillColor:
                                                                Colors.grey,
                                                            border: InputBorder
                                                                .none,
                                                            hintText: 'Phone'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 0),
                      child: InkWell(
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                              child: Text(
                                "Save Information",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.sp)),
                        ),
                        onTap: () async {
                          submit();
                        },
                      ),
                    ),
                    bottom: 1.h,
                    width: 100.w,
                  )
                ],
              )),
        );
      }),
    );
  }
}
