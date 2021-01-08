import 'package:e_shop_app/Address/Address.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/decoration_functions.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart' as Geoco;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAddress extends StatefulWidget {
  @override
  _MapAddressState createState() => _MapAddressState();
}

class _MapAddressState extends State<MapAddress> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cPhoneNumber = TextEditingController();
  final TextEditingController _cHomeNumber = TextEditingController();

  GoogleMapController mapController;
  List <Marker> myMarker = [];
  Position position;
  var address;
  double _latitude, _longitude;
  String _addressLine, _countryName, _cityName;

  Position liveCurrentPosition;
  var geoLocator = Geolocator();


  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    liveCurrentPosition = position;

    LatLng latLanPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLanPosition, zoom: 14.0);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                  color: Colors.white
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 17.0, left: 50),
              child: Row(
                children: [
                  Text(
                    "Add New Address",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => Address());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: height-90,
              width: width,
              child: GoogleMap(
                padding: EdgeInsets.only(bottom: 200.0),
                onMapCreated: (controller){
                  setState(() {
                    mapController = controller;
                  });

                  // locatePosition();
                },
                // where do i need the camera to be placed at first
                initialCameraPosition: CameraPosition(
                    target: LatLng(33.8547, 35.8623),    // lebanon by default
                    zoom: 10.0
                ),
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                compassEnabled: true,
                trafficEnabled: true,
                markers: Set.from(myMarker),
                onTap: (tapped)async {
                  handleTapMarker(tapped.latitude, tapped.longitude);
                  mapController.animateCamera(CameraUpdate.newLatLng(tapped));
                  final coordinates = new Geoco.Coordinates(tapped.latitude, tapped.longitude);
                  address = await Geoco.Geocoder.local.findAddressesFromCoordinates(coordinates);
                  final firstAddress = address.first;
                  _latitude = tapped.latitude;
                  _longitude = tapped.longitude;
                  _addressLine = firstAddress.addressLine;
                  _countryName = firstAddress.countryName;
                  _cityName = firstAddress.featureName;
                  _postalCode = firstAddress.postalCode;
                },
                myLocationEnabled: true,
              ),

            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Palette.darkBlue,
                          blurRadius: 16.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7)
                      ),
                    ]
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.0,),
                        Text("More Details", style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20.0,),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(5.0),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               color: Palette.darkBlue,
                        //               blurRadius: 6.0,
                        //               spreadRadius: 0.5,
                        //               offset: Offset(0.7, 0.7)
                        //           ),
                        //         ]
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.all(12.0),
                        //       child: Row(
                        //         children: [
                        //           Icon(Icons.search, color: Palette.darkBlue,),
                        //           SizedBox(width: 10.0,),
                        //           Text("Search Drop Off")
                        //         ],
                        //       ),
                        //     )
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _cName,

                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Name is Required';
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration(hintText: 'Name', data: Icons.person),
                                  style: TextStyle(color: Palette.darkBlue),
                                  onSaved: (input) => _cName.text = input,
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  controller: _cPhoneNumber,

                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Phone Number is Required';
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration(hintText: 'Phone Number', data: Icons.phone_android),
                                  style: TextStyle(color: Palette.darkBlue),
                                  onSaved: (input) => _cPhoneNumber.text = input,

                                ),

                                SizedBox(height: 5),

                                TextFormField(
                                  controller: _cHomeNumber,

                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Home Phone is required';
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration(hintText: 'Home Phone Number', data: Icons.phone),
                                  style: TextStyle(color: Palette.darkBlue),
                                  onSaved: (input) => _cHomeNumber.text = input,

                                ),

                                SizedBox(height: 25),

                                InkWell(
                                  child: Container(
                                    height: 40,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      color: Palette.darkBlue,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Align(
                                        child: Text("Add Address",
                                            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Cabin")
                                        ),
                                    ),
                                  ),

                                  onTap: mapController == null
                                        ? null
                                        : () async{
                                      if(_formKey.currentState.validate()) {
                                        final model = AddressModel(
                                          name: _cName.text.trim(),
                                          phoneNumber: _cPhoneNumber.text,
                                          homeNumber: _cHomeNumber.text,
                                          city: _cityName,
                                          state: _countryName,
                                          addressDetails: _addressLine,
                                          latitude: _latitude,
                                          longitude: _longitude,
                                        ).toJson();

                                        await shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                                            .collection("address").document(DateTime.now().millisecondsSinceEpoch.toString())
                                            .setData(model).then((value){

                                          Fluttertoast.showToast(msg: "New Address Added Successfully.");

                                        });

                                        Route route = MaterialPageRoute(builder: (c) => Address());
                                        Navigator.pushReplacement(context, route);
                                      }
                                    }
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void handleTapMarker(double lat, double long){
    MarkerId _markerId = MarkerId(lat.toString()+long.toString());

    setState(() {
      myMarker = [];
      myMarker.add(
          Marker(
              markerId: _markerId,
              position: LatLng(lat,long),
              draggable: true,
              infoWindow: InfoWindow(
                title: "My Location",
              )
          )
      );
    });
  }

  void getCurrentLocation() async{
    Position currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }
}


