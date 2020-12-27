import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Widgets/OrderCard.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class DriverOrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  DriverOrderCard({Key key, this.itemCount, this.data, this.orderID, this.addressID, this.orderBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route;
        // route = MaterialPageRoute(builder: (c) => AdminOrderDetails(orderID: orderID, orderBy: orderBy, addressID: addressID));
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
                  blurRadius: 2.0
              ),
            ]
        ),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );
  }
}
