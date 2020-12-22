import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/Orders/MyOrders.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/Widgets/OrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderID = "";

class OrderDetails extends StatelessWidget {

  final String orderID;

  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    getOrderID = orderID;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                .collection("orders").document(orderID).get(),

            builder: (c, snapshot){
              Map dataMap;
              if(snapshot.hasData){
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                    child: Column(
                      children: [
                        StatusBanner(status: dataMap["isSuccess"]),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              r"$ " + dataMap["totalAmount"].toString(),
                              style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Palette.darkBlue,
                                    blurRadius: 2.0
                                ),
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Order ID: " + getOrderID, style: TextStyle(color: Palette.darkBlue, fontSize: 15.0, fontWeight: FontWeight.w500)),
                                SizedBox(height: 10.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Order at: " + DateFormat("dd MM, YYYY - hh:mm aa")
                                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                                    style: TextStyle(color: Palette.darkBlue, fontSize: 15.0, fontWeight: FontWeight.w500),),
                                )
                              ],
                            ),
                          ),
                        ),

                        FutureBuilder<QuerySnapshot>(
                          future: shopApp.firestore.collection("items")
                              .where("shortInfo", whereIn: dataMap["productID"]).getDocuments(),
                          builder: (c, dataSnapshot){
                            return dataSnapshot.hasData
                                ? OrderCard(
                                    itemCount: dataSnapshot.data.documents.length,
                                    data: dataSnapshot.data.documents
                                  )
                                : Center(child: circularProgress());
                          },
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                              .collection("address").document(dataMap["addressID"]).get(),

                          builder: (c, snap){
                            return snap.hasData
                                ? ShippingDetails(model: AddressModel.fromJson(snap.data.data),)
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
    );
  }
}



class StatusBanner extends StatelessWidget {

  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      decoration:  BoxDecoration(
          color: Palette.darkBlue
      ),
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => MyOrders());
              Navigator.pushReplacement(context, route);
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 30.0),
          Text(
            "Order Shipped " + msg,
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 30.0),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.white,
            child: Center(
              child: Icon(
                iconData,
                color: Palette.darkBlue,
                size: 15.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ShippingDetails extends StatelessWidget {

  final AddressModel model;

  ShippingDetails({Key key, this.model}): super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Palette.darkBlue,
                    blurRadius: 2.0
                ),
              ]
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Shipment Details: ",
                    style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
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
                    TableRow(
                        children: [
                          Text("Pin Code", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                          model.pincode != null ?
                          Text(model.pincode)
                              : Text("null"),
                        ]
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),


        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: (){
                confirmedUserOrderRecieved(context, getOrderID);
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
                    "Confirmed || Items Recieved",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "PatrickHand", fontSize: 24.0),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmedUserOrderRecieved(BuildContext context, String mOrderID){

    shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
        .collection("orders").document(mOrderID).delete();

    getOrderID = "";

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been Recieved. Confirmed");
  }
}
