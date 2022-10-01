import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:casafoods_app/models/menu_model.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:casafoods_app/providers/time.dart';

List<dynamic> food = [];

class Book_Table extends StatefulWidget {
  const Book_Table({Key? key}) : super(key: key);

  @override
  State<Book_Table> createState() => _Book_TableState();
}

class _Book_TableState extends State<Book_Table> {
  // String time = "";  Timer? timer;
  bool value = false;
  int choice = 0;
  List<dynamic> data = [];
  var normal_coupon = 0;
  var special_coupon = 0;
  Dio dio = Dio();
  List<MenuModel> menu = [];
  List<MenuModel> copy = [];
  List<MenuModel> selected = [];
  String formattedDate = "";
  List<dynamic> filter = [];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await fetchMenu();
      await getCoupon();
    });
    super.initState();
    // setOrderType();
  }

  @override
  void dispose() {
    // timer?.cancel();
    super.dispose();
  }

  dynamic getCoupon() async {
    var response = await dio.get('https://api.casaworld.in/api/getwallet',
        options: Options(headers: {
          "Authorization":
              'Bearer ${Provider.of<Users>(context, listen: false).token}'
        }));
    setState(() {
      normal_coupon = response.data['normal_coupons'];
      special_coupon = response.data['special_coupons'];
      // print(normal);print(special);
    });
  }

  Future bookTable(String type, String time) async {
    try {
      var response = await dio.post('https://api.casaworld.in/api/bookings',
          data: {
            "data": {
              "type": type,
            }
          },
          options: Options(headers: {
            "Authorization":
                'Bearer ${Provider.of<Users>(context, listen: false).token}'
          }));
      Navigator.popAndPushNamed(context, '/paystatus', arguments: {
        'status': (response.statusCode == 200) ? "SUCCESSFUL" : "FAILED"
      });
    } catch (err) {
      print(err);
      Navigator.popAndPushNamed(context, '/paystatus',
          arguments: {'status': "FAILED"});
    }
    // if(response.statusCode==200){

    // }
  }

  Future fetchMenu() async {
    var response = await dio
        .get('https://api.casaworld.in/api/menus?populate=items.food.image');
    // print(response);
    setState(() {
      food = response.data['data'];
      data = food
          .where((element) =>
              element['attributes']['time'].contains(
                  "${Provider.of<Time>(context, listen: false).time.toUpperCase()}") &&
              element['attributes']['date'] == formattedDate)
          .toList();
      print(data);
      filter = (data.length != 0)
          ? data[0]['attributes']['items'].where((element) => true).toList()
          : [];

      menu = [];
      for (var i = 0; i < filter.length; i++) {
        menu.add(MenuModel(
            filter[i]['food']['data']['attributes']['name'],
            filter[i]['food']['data']['attributes']['image']['data']
                ['attributes']['url'],
            false,
            filter[i]['type']));
      }
      // print(menu);
      copy = menu.where((element) => element.special == "NORMAL").toList();
    });
  }

  void setDate() {
    DateTime today = DateTime.now();
    String year = today.year.toString();
    String month = (today.month >= 10)
        ? today.month.toString()
        : "0" + today.month.toString();
    String day =
        (today.day >= 10) ? today.day.toString() : "0" + today.day.toString();
    setState(() {
      formattedDate = year + "-" + month + "-" + day;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    setDate();

    // print(Provider.of<Time>(context,listen: true).time);

    return SafeArea(
      child: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
            body: Stack(
          children: [
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(7.w, 5.h, 0, 0),
                    child: Row(
                      children: [
                        Text("Book a",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11.sp))
                      ],
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(7.w, 0.5.h, 7.w, 0),
                  child: Row(
                    children: [
                      Text("Table",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.sp,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),
                        color: Colors.grey.shade300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              choice = 0;
                              // data = food.where((element) => element['attributes']['time'].contains('${Provider.of<Time>(context,listen: false).time.toUpperCase()}') &&element['attributes']['items'][0]['type']=="NORMAL" ).toList();
                              data = food
                                  .where((element) =>
                                      element['attributes']['time'].contains(
                                          '${Provider.of<Time>(context, listen: false).time.toUpperCase()}') &&
                                      element['attributes']['date'] ==
                                          formattedDate)
                                  .toList();
                              filter = (data.length != 0)
                                  ? data[0]['attributes']['items']
                                      .where((element) =>
                                          element['type'] == "NORMAL")
                                      .toList()
                                  : [];
                              copy = menu
                                  .where(
                                      (element) => element.special == "NORMAL")
                                  .toList();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.sp),
                              color: (choice == 0)
                                  ? Colors.white
                                  : Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(
                                    -1.5,
                                    0.5,
                                  ),
                                  blurRadius: (choice == 0) ? 1.sp : 0,
                                  spreadRadius: (choice == 0) ? 0.5.sp : 0,
                                ), //BoxShadow
                              ],
                            ),
                            padding:
                                EdgeInsets.fromLTRB(2.sp, 12.sp, 2.sp, 12.sp),
                            width: 43.5.w,
                            child: Center(
                              child: Text(
                                "Normal ${Provider.of<Time>(context, listen: false).time}",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              choice = 1;
                              // data = food.where((element) => element['attributes']['time'].contains('${Provider.of<Time>(context,listen: false).time.toUpperCase()}') && element['attributes']['items'][0]['type']=="SPECIAL" ).toList();
                              data = food
                                  .where((element) =>
                                      element['attributes']['time'].contains(
                                          '${Provider.of<Time>(context, listen: false).time.toUpperCase()}') &&
                                      element['attributes']['date'] ==
                                          formattedDate)
                                  .toList();
                              filter = (data.length != 0)
                                  ? data[0]['attributes']['items']
                                      .where((element) =>
                                          element['type'] == "SPECIAL")
                                      .toList()
                                  : [];
                              copy = menu
                                  .where(
                                      (element) => element.special == "SPECIAL")
                                  .toList();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.sp),
                              color: (choice == 1)
                                  ? Colors.white
                                  : Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(
                                    1.5,
                                    0.5,
                                  ),
                                  blurRadius: (choice == 1) ? 1.sp : 0,
                                  spreadRadius: (choice == 1) ? 0.5.sp : 0,
                                ), //BoxShadow//BoxShadow
                              ],
                            ),
                            padding:
                                EdgeInsets.fromLTRB(2.sp, 12.sp, 2.sp, 12.sp),
                            width: 43.5.w,
                            child: Center(
                              child: Text(
                                "Special ${Provider.of<Time>(context, listen: false).time}",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 3.h,),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 0),
                //   child: Row(
                //     children: [
                //       Text("Select Your Menu",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500), )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  height: 43.h,
                  child: (copy.length != 0)
                      ? ListView.builder(
                          itemCount: copy.length,
                          itemBuilder: (context, index) {
                            return MenuItem(
                                copy[index].name,
                                copy[index].link,
                                copy[index].isSelected,
                                copy[index].special,
                                index);
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Today's booking is closed. Sorry for the inconvenience !",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 0.5,
                              style: BorderStyle.solid))),
                ),
              ],
            ),
            Positioned(
              width: 100.w,
              bottom: 2.h,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(7.w, 0, 7.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.account_balance_wallet,
                              size: 16.sp,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  (choice == 0)
                      ? Text('${normal_coupon} Normal Coupons Remaining')
                      : Text('${special_coupon} Special Coupons Remaining'),
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6.w),
                    child: InkWell(
                      onTap: () async {
                        String x = (choice == 1) ? "SPECIAL" : "NORMAL";
                        await bookTable(
                            x,
                            Provider.of<Time>(context, listen: false)
                                .time
                                .toUpperCase());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.sp)),
                        padding: EdgeInsets.fromLTRB(0, 2.5.h, 0, 2.5.h),
                        child: Center(
                          child: Text(
                            "Book Table",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
      }),
    );
  }

  Widget MenuItem(
      String name, String link, bool isSelected, String special, int index) {
    return InkWell(
      onTap: () {
        // setState(() {
        //   copy[index].isSelected=!copy[index].isSelected;
        //   if(copy[index].isSelected==true){
        //     selected.add(MenuModel(name, link, true,special));
        //   }else if(copy[index].isSelected==false){
        //     selected.removeWhere((element) => element.name==copy[index].name);
        //   }
        // });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 1.h),
        child: Container(
          padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 0),
          child: Center(
            child: Row(
              children: [
                // (isSelected)?Icon(Icons.check_box,color: Colors.blue,):Icon(Icons.check_box_outline_blank,color: Colors.grey,),
                // SizedBox(width: 5.w,),
                Container(
                  height: 7.h,
                  width: 14.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.sp),
                    child: CachedNetworkImage(
                      imageUrl: link,
                      width: 16.w,
                      fit: BoxFit.cover,
                      height: 8.h,
                      errorWidget: (context, url, error) {
                        print("Could not load content");
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.sp),
                          child: Image.asset("assets/placeholder.jpg",
                              height: 8.h, width: 16.w, fit: BoxFit.cover),
                        );
                      },
                      placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(8.sp),
                        child: Image.asset("assets/placeholder.jpg",
                            height: 8.h, width: 16.w, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  '$name',
                  style:
                      TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          height: 10.h,
        ),
      ),
    );
  }
}
