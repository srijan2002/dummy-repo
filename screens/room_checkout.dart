import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:casafoods_app/screens/profile.dart';
import 'package:casafoods_app/providers/user.dart';
import 'package:intl/intl.dart';
import './room_booking.dart';

class Room extends StatefulWidget {
  final String option;
  Room({Key? key, required this.option}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  TextEditingController dateIn = TextEditingController();
  TextEditingController dateOut = TextEditingController();
  void initState() {
    super.initState();
    print(widget.option);
    dateIn.text = "";
    dateOut.text = "";
  }

  int _n = 0;

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  DateTime x1 = DateTime.now();
  DateTime x2 = DateTime.now();
  var difference = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(3.w, 5.h, 7.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Confirm Booking Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Image.asset(
                "assets/113434-booking-unscreen.gif",
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            Container(
                padding: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.width / 4.5,
                child: Center(
                    child: TextField(
                  controller: dateIn,
                  //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Check-In Date" //label text of field
                      ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate1 = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate1 != null) {
                      x1 = pickedDate1;
                      print(
                          pickedDate1); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate1 =
                          DateFormat('yyyy-MM-dd').format(pickedDate1);
                      print(formattedDate1);
                      //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateIn.text =
                            formattedDate1; //set output date to TextField value.
                      });
                    } else {}
                  },
                ))),
            Padding(
              padding: const EdgeInsets.only(top: 30),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue.shade400),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomPayment(
                          DateIn: dateIn.text,
                        ),
                      ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Proceed to Checkout',
                        style: TextStyle(
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
          ],
        ),
      );
    }));
  }
}
