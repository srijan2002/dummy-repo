import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:casafoods_app/screens/profile.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:casafoods_app/sliver_components/SABT.dart';

class Buildings extends StatefulWidget {
  const Buildings({Key? key}) : super(key: key);

  @override
  State<Buildings> createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [

              SliverAppBar(
                 automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      // color: Colors.red,
                      border: Border(bottom: BorderSide(
                          color: Colors.white70,
                          width: 1,
                          style: BorderStyle.solid
                      ))
                  ),
                  child: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    title: SABT(
                      child: Text("Rent",style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Mons',
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),),
                    ),
                    background:  Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rent", style: TextStyle( fontWeight: FontWeight.bold,fontSize: 23.sp,)),
                                GestureDetector(
                                  onTap: () async{
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
                          Padding(
                            padding:  EdgeInsets.fromLTRB(7.w, 3.h, 7.w, 3.h),
                            child: Text("Check out amazing deals for rent at extraordinary prices. Hurry Now !",
                              style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w800),
                            ),
                          )
                        ],
                      ),
                  ),
                ),
                pinned: true,
                collapsedHeight: 10.h,
                expandedHeight: 25.h,
                backgroundColor: Colors.transparent,


              ),
              SliverList(delegate: SliverChildListDelegate([
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: EdgeInsets.fromLTRB(5.w, 1.2.h, 5.w, 1.2.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.sp),
                              color: Colors.grey.shade100,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: Column(
                                children: [
                                  Container(height: 23.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.sp),topRight: Radius.circular(12.sp) ),
                                        image: DecorationImage(
                                            image: AssetImage('assets/pg.jpg'),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 1.5.h,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row(children: [
                                      Text("Lisbon House",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11.sp),)
                                    ],),
                                  ),
                                  SizedBox(height: 1.h,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Electronic City, Phase 1",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 11.sp),),
                                        GestureDetector(
                                            onTap: (){
                                              Navigator.pushNamed(context, '/details');
                                            },
                                            child: Text("View Details",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.sp,color: Colors.blue),)),
                                      ],),
                                  ),
                                  SizedBox(height: 1.h,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row(children: [
                                      Text("2,3,4 BHK",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 11.sp),)
                                    ],),
                                  ),
                                  SizedBox(height: 1.h,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row( mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("₹ 12000/month",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.sp),)
                                      ],),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ]))
            ],
          ),
        )

      ],
    );
  }
}
