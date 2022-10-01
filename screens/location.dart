// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:casafoods_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:google_place/google_place.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/locationProvider.dart';

class Location_Select {
  void locationSelect(BuildContext context) async {
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
          return Settings();
        },
      );
    });
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

  
    googlePlace = GooglePlace(apiKey);
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    } else {
      print('result empty');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Profile user = Profile();
  String location = 'Null, Press Button';
  String Address = 'search';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    _controller.text = place.locality.toString();
    Provider.of<Locationprovider>(context, listen: false)
        .setData(_controller.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );

    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.90),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                margin: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          "Select Location",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: CupertinoTextField(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        placeholder: 'Search for area, street name..',
                        controller: _controller,
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                       
                        onChanged: ((value) => {
                              if (_debounce?.isActive ?? false)
                                _debounce!.cancel(),
                              _debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                if (value.isNotEmpty) {
                                  //places api
                                  autoCompleteSearch(value);
                                } else {
                                  setState(() {
                                    predictions = [];
                                  });
                                }
                              })
                            }
                            ),
                        // decoration: InputDecoration(
                        //   prefixIcon: new Icon(Icons.search),
                        //   labelText: 'Search for area, street name..',
                        //   enabledBorder: const OutlineInputBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(20.0)),
                        //     borderSide: const BorderSide(
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Position position =
                                  await _getGeoLocationPosition();
                              location =
                                  'Lat: ${position.latitude} , Long: ${position.longitude}';
                              GetAddressFromLatLong(position);
                            },
                            child: Icon(
                              Icons.gps_fixed,
                              color: Colors.red,
                              size: 45,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    await GetAddressFromLatLong(position);
                                  },
                                  child: Text(
                                    'Use your current location',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  predictions[index].description.toString(),
                                ),
                                onTap: () async {
                                  final placeId = predictions[index].placeId!;
                                  final details =
                                      await googlePlace.details.get(placeId);
                                  if (details != null &&
                                      details.result != null &&
                                      mounted) {
                                    _controller.text = details.result!.name!;
                                    String textToSend = _controller.text;
                                    Provider.of<Locationprovider>(context,
                                            listen: false)
                                        .setData(textToSend);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                    );
                                  }
                                });
                          }),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}
