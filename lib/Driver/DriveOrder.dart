import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Driver/DriverHomePage.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/Widgets/ManagerOrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

var getDriverID;
var getOrderID;


class DriveOrder extends StatefulWidget {

  final String addressID;
  final String orderBy;
  final String orderID;
  final String driverID;

  const DriveOrder({Key key, this.addressID, this.orderBy, this.orderID, this.driverID}) : super(key: key);

  @override
  _DriveOrderState createState() => _DriveOrderState();
}

class _DriveOrderState extends State<DriveOrder> {

  GoogleMapController mapController;
  List <Marker> myMarker = [];
  AddressModel addressmodel;
  double getLatitude;
  double getLongitude;

  Future getAddress (){
    return shopApp.firestore.collection("users").document(widget.orderBy)
        .collection("address").document(widget.addressID).get().then((snapshot){
          return AddressModel.fromJson(snapshot.data);
    });
  }

  _gett() async{
   AddressModel addresstest = await getAddress();
   setState(() {
     addressmodel = addresstest;
     getLatitude = addressmodel.latitude;
     getLongitude = addressmodel.longitude;
     addMarker(getLatitude,getLongitude);
   });
  }

  addMarker(double lat, double long){
    setState(() {
      myMarker.add(
          Marker(
              markerId: MarkerId('My Marker'),
              position: LatLng(lat,long),
              draggable: true,
              infoWindow: InfoWindow(
                title: "My Location",
              )
          )
      );
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverID = widget.driverID;
    getOrderID = widget.orderID;
    // get logitude and latitude
    _gett();
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
              padding: const EdgeInsets.only(top: 17.0, left: 70),
              child: Row(
                children: [
                  Text(
                    "Driving Order",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            leading: widget.driverID == null ? Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => DriverHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ) : Container()
          ),
        ),

        body: Stack(
          children: [
            Container(
              height: height-90,
              width: width,
              child: getLatitude != null ? GoogleMap(
                padding: EdgeInsets.only(bottom: 300.0),
                onMapCreated: (controller){
                  setState(() {
                    mapController = controller;
                  });

                  // locatePosition();
                },
                // where do i need the camera to be placed at first
                initialCameraPosition: CameraPosition(
                    target: LatLng(getLatitude-0.009, getLongitude-0.007),    // customer location
                    zoom: 14.0
                ),
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                compassEnabled: true,
                trafficEnabled: true,
                markers: Set.from(myMarker),
                myLocationEnabled: true,
              ): Container()

            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: getLatitude != null ? 300.0 : 580.0,
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
                    child: FutureBuilder<DocumentSnapshot>(
                      future: shopApp.firestore.collection("orders").document(getOrderID).get(),

                      builder: (c, snapshot){
                        Map dataMap;
                        if(snapshot.hasData){
                          dataMap = snapshot.data.data;
                        }
                        return snapshot.hasData
                            ? Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 13.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    r"$ " + dataMap["totalAmount"].toString(),
                                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),

                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Table(
                                      children: [
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:10.0),
                                              child: Text("Order ID ", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                            ),
                                            Text(getOrderID, style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:10.0),
                                              child: Text("Ordered at ",
                                                style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                                            ),
                                            Text(DateFormat("dd MM, YYYY - hh:mm aa")
                                                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                                                style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 15.0, left: 15.0, right:15.0),
                                child: Divider(color: Palette.darkBlue, thickness: 0.5),
                              ),

                              FutureBuilder<QuerySnapshot>(
                                future: shopApp.firestore.collection("items")
                                    .where("title", whereIn: dataMap["productID"]).getDocuments(),
                                builder: (c, dataSnapshot){
                                  return dataSnapshot.hasData
                                      ? AdminOrderCardDetails(
                                      itemCount: dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                  )
                                      : Center(child: circularProgress());
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Divider(color: Palette.darkBlue, thickness: 0.5),
                              ),


                              FutureBuilder<DocumentSnapshot>(
                                future: shopApp.firestore.collection("users").document(widget.orderBy)
                                    .collection("address").document(widget.addressID).get(),

                                builder: (c, snap){
                                  return snap.hasData
                                      ? DriverShippingDetails(model: AddressModel.fromJson(snap.data.data),)
                                      : Center(child: circularProgress());
                                },

                              )
                            ],
                          ),
                        )
                            : Center(child: circularProgress());
                      },

                    )
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}


class DriverShippingDetails extends StatelessWidget {

  final AddressModel model;

  DriverShippingDetails({Key key, this.model}): super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Shipment Details: ",
                  style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 15.0),

            Container(
              padding: EdgeInsets.only(left: 15.0),
              width: width,
              child: Table(
                children: [
                  TableRow(
                      children: [
                        Text("Name", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        Text(model.name),
                      ]
                  ),

                  TableRow(
                      children: [
                        Text("Phone Number", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        Text(model.phoneNumber),
                      ]
                  ),

                  TableRow(
                      children: [
                        Text("Home Phone Number", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        Text(model.homeNumber),
                      ]
                  ),

                  TableRow(
                      children: [
                        Text("City", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        Text(model.city),
                      ]
                  ),

                  TableRow(
                      children: [
                        Text("State", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        Text(model.state),
                      ]
                  ),

                  TableRow(
                      children: [
                        Text("Address Details", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        Text(model.addressDetails),
                      ]
                  ),

                  TableRow(
                      children: [
                        Text("Latitude", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        model.latitude.toString() != null ?
                        Text(model.latitude.toString())
                            : Text("null"),
                      ]
                  ),
                  TableRow(
                      children: [
                        Text("Longitude", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                        model.longitude.toString() !=null ?
                        Text(model.longitude.toString())
                            : Text("null"),
                      ]
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 10.0,),


        getDriverID != null ? Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: (){
                confirmedPackageShifted(context, getOrderID);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.darkBlue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3.0
                      ),
                    ]
                ),
                width: width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Package Delivered",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "PatrickHand", fontSize: 24.0),
                  ),
                ),
              ),
            ),
          ),
        ) : Container(),

        SizedBox(height: 20,)
      ],
    );
  }

  confirmedPackageShifted(BuildContext context, String mOrderID){

    shopApp.firestore.collection("orders").document(mOrderID)
        .updateData({
      'isSuccess': "Delivered",
    });

    shopApp.sharedPreferences.setString("isSuccess", "Delivered");


    // shopApp.firestore.collection("orders").document(mOrderID).delete();

    Route route = MaterialPageRoute(builder: (c) => DriverHomePage());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Package has been Delivered.");
  }
}