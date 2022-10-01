import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:casafoods_app/screens/profile.dart';
import 'package:casafoods_app/providers/user.dart';

class Payment {
  void payment(BuildContext context, DateIn, guests) async {
    print(DateIn);
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        avoidStatusBar: true,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.6, 0.6],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        extendBody: false,
        builder: (context, state) {
          return RoomPayment(
              DateIn: DateIn);
        },
      );
    });
  }
}

class RoomPayment extends StatefulWidget {
  final String DateIn;
  const RoomPayment(
      {Key? key,
      required this.DateIn,
  
    })
      : super(key: key);

  @override
  State<RoomPayment> createState() => _RoomPaymentState();
}

class _RoomPaymentState extends State<RoomPayment> {
  @override
  void initState() {
    super.initState();
    print(widget.DateIn);
  
   
  }

  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5.h, 0, 10.h),
              child: Container(
                padding: EdgeInsets.fromLTRB(7.w, 3.h, 7.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Checkout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.sp,
                        )),
                    GestureDetector(
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
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Check-In Date',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(widget.DateIn,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rent',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rs. 12,000',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
                Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Security Deposit',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                        Text(
                        'Rs. 12,000',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction fees',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rs. 5',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rs. 24,005',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all<Color>(Colors.blue.shade400) ,
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Proceed to Payment', style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)), 
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
            
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,10,10),
                child: Image.asset(
                "assets/14521-hotel-booking-unscreen.gif",
                height: MediaQuery.of(context).size.width*0.6,
                width: MediaQuery.of(context).size.width*0.6,
            ),
              ),
        
          ],
        ),
      ),
    ));
  }
}
