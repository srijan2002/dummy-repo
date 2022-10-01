import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:from_css_color/from_css_color.dart';
import 'dashboard.dart';
import 'menu.dart';
import 'buildings.dart';
import 'bookings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;
  final _pageViewController = PageController();
   final screens = [Dashboard(), Menu(), Bookings(),Buildings()];

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey('intValue');
    if (CheckValue == false) prefs.setBool('intValue', true);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    // Provider.of<Time>(context).setTime();
    return Sizer(builder: (context, orientation, deviceType) {

       return Scaffold(
         body: SafeArea(child: screens[page]),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: page,
          tabs: [
            TabData(iconData:  Icons.home, title: "Home"),
            TabData(iconData: Icons.menu_book, title: "Menu"),
            TabData(iconData: Icons.book, title: "Bookings"),
            TabData(iconData: Icons.house_outlined, title: "Rent"),
          ],
          onTabChangedListener: (position) {
            setState(() {
              page = position;
            });
          },
          textColor: Colors.blue,
        ),
      );
    });
  }
}
