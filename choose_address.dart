import 'dart:async';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import '../services/place.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
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
  return await Geolocator.getCurrentPosition();
}

Future<Placemark> getAddressFromLocation(
    double latitude, double longitude) async {
  List<Placemark> placemarks =
  await placemarkFromCoordinates(latitude, longitude);

  return placemarks[0];
}

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLocationScreen> createState() => ChooseLocationScreenState();
}

class ChooseLocationScreenState extends State<ChooseLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  PlaceApiProvider placeApiProvider = PlaceApiProvider(Uuid().v4());
  var address = "";
  LatLng currentLocation = LatLng(37.42796133580664, -122.085749655962);
  TextEditingController locationController = TextEditingController();


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    loadUserAndLocation();
  }

  void loadUserAndLocation() async {


        _goToTheLake(LatLng(  37.42796133580664, -122.085749655962));
        setAddressFromLocation(  37.42796133580664, -122.085749655962);

        // return;




    _determinePosition().then((position) {
      _goToTheLake(LatLng(position.latitude, position.longitude));
      setAddressFromLocation(position.latitude, position.longitude);
    });

    return;
  }

  void setAddressFromLocation(double latitude, double longitude) async {
    var value = await getAddressFromLocation(latitude, longitude);
    setState(() {
      address =
      "${value.name}, ${value.street}, ${value.subLocality}, ${value.locality}, ${value.subAdministrativeArea}, ${value.administrativeArea} - ${value.postalCode}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        middle: Text('Choose Location'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                    draggable: true,
                    markerId: MarkerId(Uuid().v4()),
                    position: currentLocation,
                    onDragEnd: (val) => {
                      setAddressFromLocation(val.latitude, val.longitude),
                      setState(() {
                        currentLocation = val;
                      })
                    })
              },
              onTap: (val) => {
                setAddressFromLocation(val.latitude, val.longitude),
                setState(() {
                  currentLocation = val;
                })
              },
            ),
            Positioned(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 10.h,
                  padding:  EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 1.h),
                  child: CupertinoTypeAheadField(
                    noItemsFoundBuilder:  (value) {
                      var localizedMessage = "Search not Found !";
                      // return Text(localizedMessage, style: GoogleFonts.roboto(
                      //     fontSize: 12.sp, color: Colors.black,
                      //     decoration: TextDecoration.none,
                      //     fontWeight: FontWeight.w400
                      // ),);
                      return Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(1.w, 1.h, 1.w, 1.h),
                          child: Row(
                            children: [
                              Text(localizedMessage, style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w400
                              ),),
                            ],
                          ),
                        ),
                      );
                    },
                    textFieldConfiguration: CupertinoTextFieldConfiguration(
                      controller: locationController,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      prefix: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search,  color: Colors.grey.shade500,size: 20.sp,),
                      ),
                      suffixMode: OverlayVisibilityMode.always,
                      suffix: GestureDetector(
                        onTap: () => _determinePosition().then((position) {
                          setAddressFromLocation(
                              position.latitude, position.longitude);
                          _goToTheLake(
                              LatLng(position.latitude, position.longitude));
                        }),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.location_searching,
                            color: Colors.grey.shade500,size: 19.sp,
                          ),
                        ),
                      ),
                      placeholder: "Search for Location",
                      style: TextStyle(
                        fontSize: 12.sp, color: Colors.black
                      )
                    ),
                    suggestionsCallback: (pattern) async {
                      List<Suggestion> suggestions = await placeApiProvider
                          .fetchSuggestions(pattern, "en");
                      return suggestions;
                    },
                    itemBuilder: (BuildContext context, Suggestion itemData) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Text(itemData.description, style: TextStyle(
                            fontSize: 12.sp, color: Colors.black,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400
                          ),),
                        ),
                      );
                    },
                    onSuggestionSelected: (Suggestion suggestion) {
                      placeApiProvider
                          .getPlaceDetailFromId(suggestion.placeId)
                          .then((value) => {
                        setState(() {
                          locationController.text =
                              suggestion.description;
                          currentLocation = value.position;
                          address = suggestion.description;
                        }),
                        _goToTheLake(value.position)
                      });
                    },
                  )),
              top: 10,
              left: 0,
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        address,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoButton.filled(
                          child: Text("Confirm Location"),
                          onPressed: address != ""
                              ? () async {
                            // await setUserLocation(
                            //     currentUser!, currentLocation, address);
                            Navigator.of(context).pop();
                          }
                              : null),
                    )
                  ],
                ),
              ),
              bottom: 0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 19)));
    setState(() {
      currentLocation = LatLng(pos.latitude, pos.longitude);
    });
  }
}