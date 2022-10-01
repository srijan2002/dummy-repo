import 'package:casafoods_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:casafoods_app/providers/time.dart';
import 'package:casafoods_app/screens/book_table.dart';
import 'package:from_css_color/from_css_color.dart';
import 'package:sizer/sizer.dart';
import 'package:casafoods_app/screens/profile.dart';
import 'package:casafoods_app/screens/location.dart';
import 'package:dio/dio.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casafoods_app/services/secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/locationProvider.dart';

class Dashboard extends StatefulWidget {
  

  Dashboard({Key? key }) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> current = []; List<dynamic> banner =[{'attributes':{'url':""}}];
  Secure_Storage storage = Secure_Storage();
  Dio dio = Dio();
  int seat = -1;
  CarouselController buttonCarouselController = CarouselController();
  @override
  void initState() {
    // TODO: implement initState
  
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      String phone = await storage.getPhone();
      if (Provider.of<Users>(context, listen: false).name == "") {
        String token = await storage.getAll();
        String name = "";
        String email = "";
        GoogleSignInAccount? googleSignInAccount = GoogleAuth.currentUser();

        if (googleSignInAccount != null) {
          print(googleSignInAccount.photoUrl);
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
      try {
        var response = await dio.get('https://api.casaworld.in/api/getbooking',
            options: Options(headers: {
              "Authorization":
                  'Bearer ${Provider.of<Users>(context, listen: false).token}'
            }));
        setState(() {
        
          current = response.data
              .where((element) => element['status'] == "ACTIVE")
              .toList();
          if (current.length != 0) seat = current[0]['table'];
        });
      } catch (err) {
        print(err);
      }

      try{
        var response = await dio.get('https://api.casaworld.in/api/banner?populate=*',
            options: Options(headers: {
              "Authorization":
              'Bearer ${Provider.of<Users>(context, listen: false).token}'
            }));
        setState(() {
          banner=response.data['data']['attributes']['image']['data'];
        });
        print(banner);

      }catch(err){
        print(err);
      }
    });
    super.initState();
    // timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => setOrderType());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  child: Row(
                children: [
                  InkWell(
                     onTap: () {
                        Location_Select().locationSelect(context);
                      },
                    child: Text("Your Location",
                        style:
                            TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp)),
                  )
                ],
              )),
              Container(
                padding: EdgeInsets.only(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Location_Select().locationSelect(context);
                      },
                      child: Text(
                          // "${Provider.of<Users>(context, listen: false).name!.split(' ')[0]}",
                          '${Provider.of<Locationprovider>(context, listen: false).name}',
                       
                       
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.sp,
                              letterSpacing: 0.8.sp)),
                    ),
                              //Textchange(),
                              
                    InkWell(
                      onTap: () {
                        Show_Profile().showProfile(context);
                      },
                      child: Container(
                        child: (Provider.of<Users>(context, listen: false)
                                    .imageUrl !=
                                null)
                            ? CircleAvatar(
                                radius: 16.sp,
                                backgroundImage: NetworkImage(
                                    '${Provider.of<Users>(context, listen: false).imageUrl}'))
                            : CircleAvatar(
                                radius: 16.sp,
                                backgroundImage: AssetImage('assets/memoji.png')),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
    
              SizedBox(
                height: 4.h,
              ),
    
              //Carousel
              (banner.length!=0)? CarouselSlider.builder(
                  itemCount: banner.length,
                  options: CarouselOptions(
                    height: 25.h,
                    aspectRatio: 1,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  carouselController: buttonCarouselController,
                  itemBuilder:
                      (BuildContext context, int index, int pageViewIndex) =>
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            child: ClipRRect(
                              borderRadius:  BorderRadius.circular(12.sp),
                              child: CachedNetworkImage(imageUrl: banner[index]['attributes']['url'],height: 28.h,width: 80.w,fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  print("Could not load content");
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    child: Image.asset("assets/placeholder.jpg",
    
                                        height: 28.h,width: 80.w,
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
                          )):CircularProgressIndicator(),
              SizedBox(height: 4.h,),
              Row(
                children: [
                  Text("Popular Nearest You",style: TextStyle(
                      fontSize: 14.sp,fontWeight: FontWeight.w600
                  ),),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Container(
                  height: 46.5.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,itemBuilder: (context,index){
                    return Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                      child: Container(
                        width: 58.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                            ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: Column(
                            children: [
                              Container(height: 23.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12.sp),topRight: Radius.circular(12.sp) ),
                                    image: DecorationImage(
                                        image: AssetImage('assets/home.jpeg'),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              SizedBox(height: 1.5.h,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text("Apartment",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10.sp,color: Colors.grey.shade500),softWrap: false,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,),
                                      constraints:  BoxConstraints(
                                          maxWidth:
                                          32.w),
                                    ),
                                    Container(
                                      child: Text("1.9 miles",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 10.sp,color: Colors.grey.shade500),softWrap: false,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,),
                                      constraints:  BoxConstraints(
                                          maxWidth:
                                          20.w),
                                    ),
                                  ],),
                              ),
                              SizedBox(height: 1.5.h,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text("AYG Apartment",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 11.5.sp),softWrap: false,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,),
                                      constraints:  BoxConstraints(
                                          maxWidth:
                                          36.w),
                                    ),
                                    Container(
                                      // color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.star,color: fromCssColor("#FFD700"),size: 20.sp,),
                                          SizedBox(width: 0.5.w,),
                                          Text("4.7",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 11.sp),softWrap: false,
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow
                                                .ellipsis,),
                                        ],
                                      ),
                                      constraints:  BoxConstraints(
                                          maxWidth:
                                          16.w),
                                    ),
                                  ],),
                              ),
                              SizedBox(height: 0.5.h,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Jakarta Selatan",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10.sp,color: Colors.grey.shade400),softWrap: false,
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,),
                                  ],),
                              ),
                              SizedBox(height: 1.5.h,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text("₹ 2,200",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13.5.sp,color: Colors.blue),softWrap: false,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,),
                                      constraints:  BoxConstraints(
                                          maxWidth:
                                          34.w),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5.sp),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle
                                      ),
                                      child:  Icon(Icons.favorite,color: Colors.white,size: 19.sp,),
                                      constraints:  BoxConstraints(
                                          maxWidth:
                                          18.w),
                                    ),
                                  ],),
                              ),
    
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
                ),
              ),
    
    
              Visibility(
                visible: (seat != -1),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 23, 8, 8),
                  child: Stack(
                    children: [
                      Container(
                        height: 28.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.sp),
                          image: DecorationImage(
                            image: AssetImage('assets/image1.jpeg'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Text(
                          "Your Booking at",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        top: 5.5.h,
                        left: 3.5.w,
                      ),
                      Positioned(
                        child: Text(
                          "Table ${seat}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp),
                        ),
                        top: 8.h,
                        left: 3.5.w,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(8, 4.h, 8, 8),
                  child: InkWell(
                    onTap: () {
                      Provider.of<Time>(context, listen: false).setTime(context);
                      if (Provider.of<Time>(context, listen: false).time !=
                          "Coming Soon")
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => Book_Table(),
                          ),
                        );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 28.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.sp),
                            image: DecorationImage(
                              image: AssetImage('assets/image2.jpeg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Text(
                            "Ongoing Booking",
                            style:
                                TextStyle(color: Colors.black, fontSize: 11.sp),
                          ),
                          top: 4.h,
                          left: 4.w,
                        ),
                        Positioned(
                          child: Text(
                            "${Provider.of<Time>(context).time}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 27.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          top: 6.2.h,
                          left: 4.w,
                        ),
                        Positioned(
                          child: Container(
                            // width: 10.w,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Book Table",
                                    style: TextStyle(
                                        color: fromCssColor('#3198F7'),
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.bold)),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: fromCssColor('#3198F7'),
                                )
                              ],
                            ),
                          ),
                          top: 16.h,
                          left: 4.w,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
