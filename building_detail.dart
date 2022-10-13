import 'package:casafoods_app/screens/room_checkout.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import './room_checkout.dart';
import 'package:casafoods_app/widgets/custom_gesture.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:casafoods_app/sliver_components/SABT.dart';

class Rent_Detail extends StatefulWidget {
  const Rent_Detail({Key? key}) : super(key: key);

  @override
  State<Rent_Detail> createState() => _Rent_DetailState();
}

class _Rent_DetailState extends State<Rent_Detail> {
  @override
  Widget build(BuildContext context) {
    double threshold = 100;
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          child: Container(
            child: Scaffold(
              body: CustomGestureDetector(
                axis: CustomGestureDetector.AXIS_Y,
                velocity: abv,
                onSwipeUp: () {
                  this.setState(() {
                    // showBottomMenu = true;
                  });
                },
                onSwipeDown: () {
                  this.setState(() {
                    // showBottomMenu = false;
                  });
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Flexible(
                          child: Container(
                            // height: 82.h,
                            // color: Colors.red,
                            child: CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  leading: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5.w, 1.h, 0, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.black,
                                      )),
                                    ),
                                  ),
                                  flexibleSpace: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        // color: Colors.red,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.white70,
                                                width: 1,
                                                style: BorderStyle.solid))),
                                    child: FlexibleSpaceBar(
                                      collapseMode: CollapseMode.pin,
                                      title: SABT(
                                        child: Text(
                                          "Lisbon House",
                                          style: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 1.1,
                                              fontFamily: 'Mons',
                                              fontSize: 19.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      background: Container(
                                        child: Image.asset("assets/pg.jpg",
                                            height: 60.h,
                                            width: 100.w,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  pinned: true,
                                  // floating: true,
                                  expandedHeight: 40.h,
                                  backgroundColor: Colors.transparent,
                                  collapsedHeight: 13.5.h,
                                ),
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.h),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h,
                                                      horizontal: 5.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.sp),
                                                      color:
                                                          Colors.grey.shade200),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.bed,
                                                        size: 22.sp,
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        "1 Bedroom",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        height: 1.5.h,
                                                      ),
                                                      Text(
                                                        "₹ 11,9990/mo *",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h,
                                                      horizontal: 5.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.sp),
                                                      color:
                                                          Colors.grey.shade200),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.bed,
                                                        size: 22.sp,
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        "2 Bedroom",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        height: 1.5.h,
                                                      ),
                                                      Text(
                                                        "₹ 11,9990/mo *",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.w),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h,
                                                      horizontal: 10.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.sp),
                                                      color:
                                                          Colors.grey.shade200),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.bed,
                                                        size: 22.sp,
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        "3 Bedroom",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        height: 1.3.h,
                                                      ),
                                                      Text(
                                                        "₹ 11,9990/mo *",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h,
                                                      horizontal: 5.w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.sp),
                                                      color:
                                                          Colors.grey.shade200),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.bed,
                                                        size: 22.sp,
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        "4 Bedroom",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        height: 1.5.h,
                                                      ),
                                                      Text(
                                                        "₹ 11,9990/mo *",
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            7.w, 5.h, 7.w, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: (() => {
                                                    _showMyDialog(context),
                                                  }),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    7.w, 2.h, 7.w, 2.h),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.sp)),
                                                child: Text(
                                                  "Book Now",
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/demo');
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    7.w, 2.h, 7.w, 2.h),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.sp)),
                                                child: Text(
                                                  "Book Demo",
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            7.w, 6.h, 7.w, 0),
                                        child: Text(
                                          "Room Facilities",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.sp),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.7.h),
                                        child: Container(
                                          height: 20.h,
                                          child: GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisExtent: 10.h,
                                              ),
                                              itemCount: 4,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xB6DFECFF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.sp),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Icon(
                                                            Icons.bathroom,
                                                            size: 16.sp,
                                                          ),
                                                          Text(
                                                            "Attached Washroom",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    11.sp),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            7.w, 4.h, 7.w, 0),
                                        child: Text(
                                          "Amenities and Service",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.sp),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.7.h),
                                        child: Container(
                                          height: 20.h,
                                          child: GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisExtent: 10.h,
                                              ),
                                              itemCount: 3,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xB6DFECFF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.sp),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Icon(
                                                            Icons.bathroom,
                                                            size: 16.sp,
                                                          ),
                                                          Text(
                                                            "High Speed Wifi",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    11.sp),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            7.w, 4.h, 7.w, 0),
                                        child: Text(
                                          "More about Lisbon House",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.sp),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            7.w, 4.h, 7.w, 2.h),
                                        child: Text(
                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              height: 1.15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showMyDialog(context) async {
  switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select your preference'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room(
                        option: '1',
                      ),
                    ));
              },
              child: const Text('1 BHK'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room(
                        option: '2',
                      ),
                    ));
              },
              child: const Text('2 BHK'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room(
                        option: '3',
                      ),
                    ));
              },
              child: const Text('3 BHK'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room(
                        option: '4',
                      ),
                    ));
              },
              child: const Text('4 BHK'),
            ),
          ],
        );
      })) {
    case 1:
      // Let's go.
      // ...
      break;
    case 2:
      // ...
      break;
    case 3:
      // ...
      break;
    case 4:
      // ...
      break;
    case null:
      // dialog dismissed
      break;
  }
}
