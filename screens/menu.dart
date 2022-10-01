import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:casafoods_app/screens/profile.dart';

List<dynamic> food = [];
class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int category = 0; int choice=0; String meal = "BREAKFAST";
  Dio dio = Dio(); String formattedDate="";

  List<dynamic> data =[]; List<dynamic> filter =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMenu();

  }
  void setDate(){
    DateTime today = DateTime.now();
    String year = today.year.toString();
    String month = (today.month>=10)?today.month.toString():"0"+today.month.toString();
    String day= (today.day>=10)?today.day.toString():"0"+today.day.toString();
    setState(() {
      formattedDate =  year+"-"+month+"-"+day;
    });
  }
  Future fetchMenu()async{

   print(formattedDate);
    var response  = await dio.get('https://api.casaworld.in/api/menus?populate=items.food.image');
     setState(() {
       food = response.data['data'];
       print(food);
       data = food.where((element) =>  element['attributes']['time'].contains('BREAKFAST') &&  element['attributes']['date']==formattedDate ).toList();
       filter = (data.length!=0)?data[0]['attributes']['items'].where((element) => element['type']=="NORMAL").toList():[];

     });
  }

  @override
  Widget build(BuildContext context) {
   setDate();
    return Column(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(7.w, 5.h, 0, 0),
            child: Row(children: [Text("Today's", style: TextStyle( fontWeight: FontWeight.bold,fontSize: 11.sp))],)),
        Container(
          padding: EdgeInsets.fromLTRB(7.w, 0.5.h, 7.w, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Menu", style: TextStyle( fontWeight: FontWeight.bold,fontSize: 23.sp,letterSpacing: 1.sp)),
              GestureDetector(
                onTap: (){Show_Profile().showProfile(context);},
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
              )
            ],
          ),
        ),
        SizedBox(height: 2.5.h,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          InkWell(
            onTap: (){setState(() {
              category=0;choice=0;meal="BREAKFAST";
              data = food.where((element) =>  element['attributes']['time'].contains('BREAKFAST') &&  element['attributes']['date']==formattedDate ).toList();
              filter = (data.length!=0)?data[0]['attributes']['items'].where((element) => element['type']=="NORMAL").toList():[];

            }
            );},
            child: Container(
              width: 25.w,height: 14.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.sp),color:(category==0)?fromCssColor('#47A3F8'): Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(1.5, 0.5,),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.coffee_outlined, color: (category==0)?Colors.white:Colors.black,size: 27.sp,),SizedBox(height: 1.h,),
                  Text('Breakfast',style: TextStyle(
                    fontSize: 13.sp,color: (category==0)?Colors.white:Colors.black,
                  ),)
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){setState(() {category=1;choice=0;meal="LUNCH";
              // data = food.where((element) => element['attributes']['time'].contains('LUNCH') &&element['attributes']['items'][0]['type']=="NORMAL").toList();
            data = food.where((element) =>  element['attributes']['time'].contains('LUNCH') &&  element['attributes']['date']==formattedDate ).toList();
            filter = (data.length!=0)?data[0]['attributes']['items'].where((element) => element['type']=="NORMAL").toList():[];
            print(filter);
            });},
            child: Container(
              width: 25.w,height: 14.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.sp),color:(category==1)?fromCssColor('#47A3F8'): Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(1.5, 0.5,),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lunch_dining, color: (category==1)?Colors.white:Colors.black,size: 27.sp,),SizedBox(height: 1.h,),
                  Text('Lunch',style: TextStyle(
                    fontSize: 13.sp,color: (category==1)?Colors.white:Colors.black,
                  ),)
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){setState(() {category=2;choice=0;meal="DINNER";
              // data = food.where((element) => element['attributes']['time'].contains('DINNER') &&element['attributes']['items'][0]['type']=="NORMAL").toList();
            data = food.where((element) =>  element['attributes']['time'].contains('DINNER') &&  element['attributes']['date']==formattedDate ).toList();
            filter = (data.length!=0)?data[0]['attributes']['items'].where((element) => element['type']=="NORMAL").toList():[];
            });},
            child: Container(
              width: 25.w,height: 14.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.sp),color:(category==2)?fromCssColor('#47A3F8'): Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: const Offset(1.5, 0.5,),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dinner_dining, color: (category==2)?Colors.white:Colors.black,size: 27.sp,),SizedBox(height: 1.h,),
                  Text('Dinner',style: TextStyle(
                    fontSize: 13.sp,color: (category==2)?Colors.white:Colors.black,
                  ),)
                ],
              ),
            ),
          )
        ],),
        SizedBox(height: 4.h,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0,horizontal:6.w ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.sp),color: Colors.grey.shade300
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){setState(() {choice=0;
                    // data = food.where((element) => element['attributes']['time'].contains('$meal') &&element['attributes']['items'][0]['type']=="NORMAL" ).toList();
                  data = food.where((element) =>  element['attributes']['time'].contains('$meal')&&  element['attributes']['date']==formattedDate  ).toList();
                  filter = (data.length!=0)?data[0]['attributes']['items'].where((element) => element['type']=="NORMAL").toList():[];
                  print(data[0]['attributes']['items'].length);
                  });},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),color: (choice==0)?Colors.white:Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(-1.5, 0.5,),
                          blurRadius: (choice==0)?1.sp:0,
                          spreadRadius: (choice==0)?0.5.sp:0,
                        ), //BoxShadow
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(2.sp, 6.sp, 2.sp, 6.sp),
                    width: 43.5.w,
                    child: Center(
                      child: Text("Normal ${meal[0].toUpperCase() + meal.substring(1).toLowerCase()}", style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){setState(() {choice=1;
                    // data = food.where((element) => element['attributes']['time'].contains('$meal') && element['attributes']['items'][0]['type']=="SPECIAL" ).toList();
                  data = food.where((element) =>  element['attributes']['time'].contains('$meal') &&  element['attributes']['date']==formattedDate ).toList();
                  filter = (data.length!=0)?data[0]['attributes']['items'].where((element) => element['type']=="SPECIAL").toList():[];
                  print(filter);
                  });},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.sp),color: (choice==1)?Colors.white:Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(1.5, 0.5,),
                          blurRadius: (choice==1)?1.sp:0,
                          spreadRadius: (choice==1)?0.5.sp:0,
                        ), //BoxShadow//BoxShadow
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(2.sp, 6.sp, 2.sp, 6.sp),
                    width: 43.5.w,
                    child: Center(
                      child: Text("Special ${meal[0].toUpperCase() + meal.substring(1).toLowerCase()} ",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 2.5.h,),
        Container(
          height: 45.h,
          child: (filter==[]||filter.length!=0)?ListView.builder(
            itemCount: filter.length,
            itemBuilder: (context,index){
              return Padding(
                padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 1.h),
                child: Container(
                  padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 0),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          height: 8.h,
                          width: 16.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.sp),
                            child: CachedNetworkImage(imageUrl: filter[index]['food']['data']['attributes']['image']['data']['attributes']['url'],width: 16.w,fit: BoxFit.fill,height: 8.h,
                              errorWidget: (context, url, error) {
                                print("Could not load content");
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  child: Image.asset("assets/placeholder.jpg",

                                      height: 8.h,width: 16.w,
                                      fit: BoxFit.cover),
                                );
                              },
                              placeholder: (context, url) => ClipRRect(
                                borderRadius: BorderRadius.circular(8.sp),
                                child: Image.asset(
                                    "assets/placeholder.jpg",

                                    height: 8.h,width: 16.w,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Text('${filter[index]['food']['data']['attributes']['name']}',style: TextStyle(
                          fontSize: 14.5.sp,fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                  ),
                  height: 10.h,
                ),
              );
            },
          ):Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
             child: Container(
               child: Image(
                 width: 50.w,
                 image: AssetImage('assets/closed.png'),
               ),
             ),
          ),
        )
      ],
    );
  }
}
