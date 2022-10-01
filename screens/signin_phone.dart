import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';

class Sign_InPhone extends StatefulWidget {
  const Sign_InPhone({Key? key}) : super(key: key);

  @override
  State<Sign_InPhone> createState() => _Sign_InPhoneState();
}

class _Sign_InPhoneState extends State<Sign_InPhone> {
  Dio dio = Dio();
  var no = "";
  List<dynamic> countries = [];
  List<dynamic> copy = [];
  final TextEditingController phone = new TextEditingController(text: "");
  final TextEditingController country = new TextEditingController(text: "");
  String code = "";
  String dial_code = "+91";
  String name = "";
  String url = "https://flagcdn.com/48x36/in.png";

  void getOtp() async {
    var response = await dio.post(
      'https://api.casaworld.in/api/auth/sms/callback',
      data: {'phoneNumber': dial_code + phone.text},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      var ctr = await dio.get('https://triunits.com/countries.json');
      setState(() {
        countries = ctr.data;
        copy = ctr.data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7.w, 6.h, 7.w, 0),
                    child: Column(
                      children: [
                        Text(
                          "Please enter your Phone Number",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 25.sp),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 0),
                    child: Column(
                      children: [
                        Text(
                          "Enter your phone number to get an SMS confirmation to verify your number to use Casaliving.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12.5.sp),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7.w, 3.h, 7.w, 0),
                    child: InkWell(
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.sp))),
                            builder: (context) => StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setModalState) {
                                  return Container(
                                    height: 100.h,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              7.w, 8.h, 0, 0),
                                          child: GestureDetector(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 20.sp,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              setState(() {
                                                countries = copy;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              7.w, 3.h, 7.w, 2.5.h),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Select a Country",
                                                style: TextStyle(
                                                    fontSize: 25.sp,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7.w),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.grey.shade600,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Flexible(
                                                  child: Center(
                                                    child: TextField(
                                                      onChanged: (val) {
                                                        setModalState(() {
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
                                                      decoration: InputDecoration(
                                                          hintStyle: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontSize: 12.sp),
                                                          fillColor:
                                                              Colors.grey,
                                                          border:
                                                              InputBorder.none,
                                                          hintText: 'Search..'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.sp),
                                              color: Colors.grey.shade100,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w),
                                            height: 7.h,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        Flexible(
                                          child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                            // shrinkWrap: true,
                                            itemCount: countries.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10.w, 2.h, 10.w, 2.h),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      code = countries[index]
                                                          ['code'];
                                                      dial_code =
                                                          countries[index]
                                                              ['dial_code'];
                                                      countries = copy;
                                                      url =
                                                          "https://flagcdn.com/48x36/${code.toLowerCase()}.png";
                                                      print(code);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Row(
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
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                "${countries[index]['name'].toUpperCase()}",
                                                                softWrap: false,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth:
                                                                      50.w),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Text(
                                                          "${countries[index]['dial_code']}",
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13.sp),
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
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              height: 5.8.h,
                              color: Colors.grey.shade200,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Colors.black,
                                    size: 20.sp,
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      "${dial_code}",
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp),
                                    ),
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
                                  borderRadius: BorderRadius.circular(8.sp),
                                  color: Colors.grey.shade100,
                                ),
                                padding:
                                    EdgeInsets.symmetric(horizontal: 2.5.w),
                                height: 6.5.h,
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: phone,
                                  onChanged: (val) {
                                    setState(() {
                                      countries = copy
                                          .where((element) => element['name']
                                              .toLowerCase()
                                              .contains(val.toLowerCase()))
                                          .toList();
                                    });
                                    // print(countries);
                                  },
                                  style: TextStyle(letterSpacing: 1),
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12.sp),
                                      fillColor: Colors.grey,
                                      border: InputBorder.none,
                                      hintText: 'Phone'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                          child: Text(
                            "Continue",
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
                  ),
                  onTap: () {
                    getOtp();
                    setState(() {
                      countries = copy;
                    });
                    Navigator.pushNamed(context, '/verify',
                        arguments: {'phone': dial_code + phone.text});
                  },
                ),
                bottom: 1.h,
                width: 100.w,
              )
            ],
          )),
    );
  }
}
