import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/address.dart';
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
                            alignment: Alignment.centerLeft,
                            child: Text(
                              r"$ " + dataMap["totalAmount"].toString(),
                              style: TextStyle(fontSize: 20.0, color: Palette.darkBlue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Order ID: " + getOrderID),
                        ),

                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Order at: " + DateFormat("dd MM, YYYY - hh:mm aa")
                              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                            style: TextStyle(color: Palette.darkBlue, fontSize: 16.0),
                          ),
                        ),
                        Divider(height: 2.0),
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
                        Divider(height: 2.0),
                        FutureBuilder<DocumentSnapshot>(
                          future: shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                              .collection("userAddress").document(dataMap["addressID"]).get(),

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
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 20.0),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.white,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          child: Text(
            "Shipment Details: ",
            style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold),
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
                    Text("Pin Code", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                    Text(model.pincode),
                  ]
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
                    style: TextStyle(color: Palette.darkBlue, fontSize: 15.0),
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
