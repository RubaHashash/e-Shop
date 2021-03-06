import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/StoreManager/ManagerHomePage.dart';
import 'package:e_shop_app/StoreManager/ManagerShiftOrders.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/Widgets/ManagerOrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderID = "";
String getOrderByName = "";
String getDriverName = "";
String getIfDriver;
String orderStatus = "";


class ManagerOrderDetails extends StatefulWidget {

  final String orderID;
  final String addressID;
  final String orderBy;
  final String orderByName;
  final String driver;

  ManagerOrderDetails({Key key, this.addressID, this.orderBy, this.orderID, this.orderByName, this.driver}) : super (key: key);

  @override
  _ManagerOrderDetailsState createState() => _ManagerOrderDetailsState();
}

class _ManagerOrderDetailsState extends State<ManagerOrderDetails> {

  Future getDriver(){
    return shopApp.firestore.collection("orders").document(widget.orderID).get().then((snapshot){
      return snapshot.data["AssignedDriver"];
    });
  }

  Future getStatus(){
    return shopApp.firestore.collection("orders").document(widget.orderID).get().then((snapshot){
      return snapshot.data["isSuccess"];
    });
  }


  gett() async{

    String DriverData = await getDriver();
    String StatusData = await getStatus();
    setState(() {
      getIfDriver = DriverData;
      orderStatus = StatusData;
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
                          AdminStatusBanner(),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
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
                            child:  Padding(
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
                                .where("title", whereIn: dataMap["productID"]).getDocuments(),
                            builder: (c, dataSnapshot){
                              return dataSnapshot.hasData
                                  ? AdminOrderCardDetails(
                                  itemCount: dataSnapshot.data.documents.length,
                                  data: dataSnapshot.data.documents
                              )
                                  : Center(child: circularProgress());
                            },
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: shopApp.firestore.collection("users").document(widget.orderBy)
                                .collection("address").document(widget.addressID).get(),

                            builder: (c, snap){
                              return snap.hasData
                                  ? AdminShippingDetails(model: AddressModel.fromJson(snap.data.data),)
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


class AdminStatusBanner extends StatelessWidget {

  final status;

  AdminStatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    IconData iconData = Icons.done;

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
              Route route = MaterialPageRoute(builder: (c) => ManagerShiftOrders());
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


class AdminShippingDetails extends StatelessWidget {

  final AddressModel model;

  AdminShippingDetails({Key key, this.model}): super(key: key);

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

                  ],
                ),
              ),
            ],
          ),
        ),


        getIfDriver != "" ? Padding(
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
                width: width - 80.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Package Shifted",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Cabin", fontSize: 18.0),
                  ),
                ),
              ),
            ),
          ),
        ) : Container()
      ],
    );
  }

  confirmedPackageShifted(BuildContext context, String mOrderID){

    shopApp.firestore.collection("orders").document(mOrderID)
        .updateData({
      'isSuccess': "In Progress",
    });

    // shopApp.firestore.collection("orders").document(mOrderID).delete();

    getOrderID = "";

    Route route = MaterialPageRoute(builder: (c) => ManagerHomePage());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Package has been Shifted to "+ getDriverName);
  }
}