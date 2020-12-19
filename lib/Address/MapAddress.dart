import 'package:e_shop_app/Address/Address.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/decoration_functions.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart' as Geoco;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  String _addressLine, _countryName, _postalCode, _cityName;

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
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                  color: Colors.white
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Shopick",
                style: TextStyle(fontSize: 55.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => Address());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
            actions: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart, color: Palette.darkBlue),
                      onPressed: (){
                        Route route = MaterialPageRoute(builder: (c) => CartPage());
                        Navigator.pushReplacement(context, route);
                      },
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Palette.lightBlue,
                          ),
                          Positioned(
                            top: 3.0,
                            bottom: 4.0,
                            left: 6.0,
                            child: Consumer<CartItemCounter>(
                                builder: (context, counter, _){
                                  return Text(
                                    (shopApp.sharedPreferences.getStringList("userCart").length - 1).toString(),
                                    style: TextStyle(color: Palette.darkBlue, fontSize: 13.0, fontWeight: FontWeight.w500),
                                  );
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                  child: Text("Add New Address", style: TextStyle(color: Palette.darkBlue,
                      fontWeight: FontWeight.bold, fontSize: 30.0, fontFamily: "PatrickHand")),
                ),
              ),
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

                      SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
              Container(
                height: height-90,
                width: width,
                child: GoogleMap(
                  onMapCreated: (controller){
                    setState(() {
                      mapController = controller;
                    });
                  },
                  // where do i need the camera to be placed at first
                  initialCameraPosition: CameraPosition(
                      target: LatLng(33.8547, 35.8623),    // lebanon by default
                      zoom: 10.0
                  ),
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

            ],
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 15.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Palette.darkBlue,
              onPressed: mapController == null
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
                          pincode: _postalCode,
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
            ),
          ),
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


