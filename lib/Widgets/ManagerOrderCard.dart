import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/StoreManager/ManagerOrderDetails.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Widgets/OrderCard.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int counter=0;

class ManagerOrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;
  final String orderByName;
  final String driver;
  final String orderTime;

  ManagerOrderCard({Key key, this.itemCount, this.data, this.orderID, this.addressID, this.orderBy, this.orderByName, this.driver, this.orderTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route;
        // if(counter == 0){
        //   counter = counter +1;
          route = MaterialPageRoute(builder: (c) => ManagerOrderDetails(orderID: orderID, orderBy: orderBy, addressID: addressID, orderByName: orderByName, driver: driver));
        // }
        Navigator.push(context, route);
      },
      child: Container(
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
                      Text(orderID, style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text("Order By ", style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.bold)),
                      ),
                      Text(orderByName, style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text("Driven By ", style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.bold)),
                      ),
                      Text(driver, style: TextStyle(color: Palette.darkBlue,fontWeight: FontWeight.w500)),
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
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderTime))),
                          style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminOrderCardDetails extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  AdminOrderCardDetails({Key key, this.itemCount, this.data, this.orderID, this.addressID, this.orderBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
                color: Palette.darkBlue,
                blurRadius: 2.0
            ),
          ]
      ),
      height: itemCount * 183.0,
      child: ListView.builder(
        itemCount: itemCount,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          ItemModel model = ItemModel.fromJson(data[index].data);
          return sourceOrderInfo(model, context);
        },
      ),
    );
  }
}

