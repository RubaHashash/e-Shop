import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/Orders/MyOrders.dart';
import 'package:e_shop_app/Customer/StoreHome.dart';
import 'package:e_shop_app/Widgets/OrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderID = "";
String getOrderByName = "";
String getDriverName = "";
String orderStatus = "";

class OrderDetails extends StatefulWidget {

  final String orderID;
  final String orderByName;
  final String driver;

  OrderDetails({Key key, this.orderID, this.orderByName, this.driver}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {


  Future getStatus(){
    return shopApp.firestore.collection("orders").document(widget.orderID).get().then((snapshot){
      return snapshot.data["isSuccess"];
    });
  }

  gett() async{

    String data = await getStatus();
    setState(() {
      orderStatus = data;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gett();
  }

  @override
  Widget build(BuildContext context) {

    getOrderID = widget.orderID;
    getOrderByName = widget.orderByName;
    getDriverName = widget.driver;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: shopApp.firestore.collection("orders").document(widget.orderID).get(),

            builder: (c, snapshot){
              Map dataMap;
              if(snapshot.hasData){
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                    child: Column(
                      children: [
                        StatusBanner(),
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
                                          child: Text("Order By ", style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.bold)),
                                        ),
                                        Text(getOrderByName, style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:10.0),
                                          child: Text("Driven By ", style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.bold)),
                                        ),
                                        Text(getDriverName, style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.w500)),
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
                        ),

                        FutureBuilder<QuerySnapshot>(
                          future: shopApp.firestore.collection("items")
                              .where("shortInfo", whereIn: dataMap["productID"]).getDocuments(),
                          builder: (c, dataSnapshot){
                            return dataSnapshot.hasData
                                ? OrderCardDetails(
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

    IconData iconData;

    orderStatus == "Delivered" ? iconData = Icons.done : iconData = Icons.cancel;

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
            "Order is " +orderStatus,
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
                    "Shipment Details ",
                    style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Palette.darkBlue, thickness: 0.5,),
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
              child: orderStatus == "Delivered" ? Container(
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
                width: width - 80.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Confirmed || Items Recieved",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Cabin", fontSize: 18.0),
                  ),
                ),
              ) : Container()
            ),
          ),
        )
      ],
    );
  }

  confirmedUserOrderRecieved(BuildContext context, String mOrderID){

    // shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
    //     .collection("orders").document(mOrderID).delete();
    shopApp.firestore.collection("orders").document(mOrderID)
        .updateData({
      'isSuccess': "Done",
      'isRecieved': true
    });

    getOrderID = "";

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been Recieved. Confirmed");
  }
}
