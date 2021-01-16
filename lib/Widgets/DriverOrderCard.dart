import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Driver/DriveOrder.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


var AddressID;
var OrderBy;
var OrderID;

class DriverOrderCard extends StatefulWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;
  final String orderByName;
  final String driver;
  final String orderTime;

  DriverOrderCard({Key key, this.itemCount, this.data, this.orderID, this.addressID, this.orderBy, this.orderByName, this.driver, this.orderTime}) : super(key: key);

  @override
  _DriverOrderCardState createState() => _DriverOrderCardState();
}

class _DriverOrderCardState extends State<DriverOrderCard> {

  final driverID = shopApp.sharedPreferences.getString("driverId");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddressID = widget.addressID;
    OrderBy = widget.orderBy;
    OrderID = widget.orderID;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        Route route = MaterialPageRoute(builder: (c) => DriveOrder(addressID: widget.addressID, orderBy: widget.orderBy, orderID: widget.orderID));
        Navigator.push(context, route);
      },
      child:  Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Palette.darkBlue,
                  blurRadius: 10.0
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
                      Text(widget.orderID, style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text("Order By ", style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.bold)),
                      ),
                      Text(widget.orderByName, style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text("Driven By ", style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.bold)),
                      ),
                      Text(widget.driver, style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.w500)),
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
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.orderTime))),
                          style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: (){
                    shopApp.firestore.collection("orders").document(OrderID)
                        .updateData({
                      'AssignedDriver': driverID,
                    });
                    Route route = MaterialPageRoute(builder: (c) => DriveOrder(addressID: AddressID, orderBy: OrderBy, orderID: OrderID, driverID: driverID));
                    Navigator.push(context, route);
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
                    width: 30.0,
                    height: 25.0,
                    child: Center(
                      child: Icon(Icons.check, color: Colors.white,),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

