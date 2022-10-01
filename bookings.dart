import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:casafoods_app/models/Auth.dart';
import 'package:casafoods_app/screens/profile.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:lottie/lottie.dart';
class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Dio dio = Dio();
  // List<dynamic> bookings= [];
  List<dynamic> current= []; List<dynamic> expired= [];

  Future getBookings()async{
    try{
      var response  = await dio.get('https://api.casaworld.in/api/getbooking',
        options: Options(headers: {
          "Authorization":'Bearer ${Provider.of<Users>(context, listen: false).token}'
        })
      );
      setState(() {
        current=response.data.where((element)=> element['status']=="ACTIVE").toList();
        expired=response.data.where((element)=> element['status']=="EXPIRED" || element['status']=="CANCELLED").toList();
      });
      print(expired);
    }catch(err){
      print(err);
    }
  }

  Future cancelBooking()async{
    try{
      var response  = await dio.put('https://api.casaworld.in/api/cancel',
        data: {"data":{}}, options: Options(headers: {
          "Authorization":'Bearer ${Provider.of<Users>(context, listen: false).token}'
          })
      );

    }catch(err){
      print(err);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Booking Cancelled!"),duration: Duration(
        seconds: 2
    ),));
  }

  String formatDate(String x){
    List<String> month  = ["January","February","March","April","May","June","July","August","September","October","November","December",];
    DateTime? today = DateTime.tryParse(x);

    String date = month[today!.month-1]+" "+today.day.toString()+","+today.year.toString();
    return date;
  }

  @override
  void initState() {
    // TODO: implement initState
    getBookings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView(
        physics: ScrollPhysics(),
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bookings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.sp,
                        )),
                    GestureDetector(
                      onTap: () {
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
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.w),
                child: Row(
                  children: [
                    Text(
                      "Current Bookings",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 13.5.sp),
                    )
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(7.w, 0, 7.w, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: (current.length>=1)?ListView.builder(
                          shrinkWrap: true,
                          itemCount: current.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.sp),
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
                                height: 12.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(10.sp),
                                              topLeft: Radius.circular(10.sp)),
                                          child: Image.asset(
                                            'assets/current.jpg',
                                            fit: BoxFit.cover,
                                            height: 12.h,
                                            width: 22.w,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "${current[index]['menu']['time'].toString()[0]+current[index]['menu']['time'].toString().substring(1).toLowerCase()}",
                                              style: TextStyle(fontSize: 11.sp),
                                            ),
                                            Text(
                                              "${current[index]['type'].toString()[0]+current[index]['type'].toString().substring(1).toLowerCase()} Coupon",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Table No. ${current[index]['table']}",
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 3.w, 1.h),
                                          child: InkWell(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 11.5.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onTap: ()async{
                                              print("Clicked");
                                              return showDialog<void>(
                                                context: context,
                                                builder: (BuildContext context){
                                                  return AlertDialog(
                                                    backgroundColor: Colors.grey.shade300,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(13.sp))),
                                                    title: Text("Do you wish to cancel your booking?",style: TextStyle(
                                                      fontWeight: FontWeight.w400,fontSize: 13.sp
                                                    ),),
                                                    content: Container(
                                                      height: 10.h,
                                                      child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                            child: Container(
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
                                                                child: Text("Yes",style: TextStyle(color: Colors.white,
                                                                    fontWeight: FontWeight.w400,fontSize: 13.sp
                                                                )),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: Colors.blue,borderRadius: BorderRadius.circular(12.sp)
                                                              ),
                                                            ),
                                                            onTap: ()async{
                                                              Navigator.pop(context);
                                                              await cancelBooking();
                                                              await getBookings();

                                                            },
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
                                                                child: Text("No",style: TextStyle(color: Colors.white,
                                                                    fontWeight: FontWeight.w400,fontSize: 13.sp
                                                                )),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.red,borderRadius: BorderRadius.circular(12.sp)
                                                              ),
                                                            ),
                                                            onTap: (){
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }): Container(
                        child: Lottie.asset('assets/order.json'),
                        height: 25.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.w),
                child: Row(
                  children: [
                    Text(
                      "Past Bookings",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 13.5.sp),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(7.w, 0, 7.w, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: (expired.length>=1)?ListView.builder(
                          shrinkWrap: true,
                          itemCount: expired.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.sp),
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
                                height: 12.h,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.sp),
                                          topLeft: Radius.circular(10.sp)),
                                      child: Image.asset(
                                        'assets/past.jpg',
                                        fit: BoxFit.cover,
                                        height: 12.h,
                                        width: 22.w,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 2.w,
                                    // ),
                                    Expanded(
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: 2.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "${expired[index]['menu']['time'].toString()[0]+expired[index]['menu']['time'].toString().substring(1).toLowerCase()}",
                                              style: TextStyle(fontSize: 11.sp),
                                            ),
                                            Text(
                                              "${expired[index]['type'].toString()[0]+expired[index]['type'].toString().substring(1).toLowerCase()} Coupon",
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${formatDate(expired[index]['menu']['date'])}",
                                                  style: TextStyle(
                                                    fontSize: 9.sp,
                                                  ),
                                                ),
                                                Text(
                                                  "${expired[index]['status'].toString()[0]+expired[index]['status'].toString().substring(1).toLowerCase()}",
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ],
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }): Container(
                        child: Lottie.asset('assets/data.json'),
                        height: 21.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
