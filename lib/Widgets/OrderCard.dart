import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Orders/OrderDetails.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int counter =0;
class OrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String orderByName;
  final String driver;
  final String orderTime;

  OrderCard({Key key, this.itemCount, this.data, this.orderID, this.orderByName, this.driver, this.orderTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route;
        // if(counter == 0){
        //   counter = counter +1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID, orderByName: orderByName, driver: driver));
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

class OrderCardDetails extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCardDetails({Key key, this.itemCount, this.data, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 2.0, bottom: 10.0, left: 10.0, right: 10.0),
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


Widget sourceOrderInfo(ItemModel model, BuildContext context, {Color background}){

  double width = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.only(left:10.0, right:10.0, bottom: 10, top:10),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
                color: Palette.darkBlue,
                blurRadius: 2.0
            ),
          ]
      ),
      width: width,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                bottomLeft: Radius.circular(14.0)
            ),
            child: Image.network(model.thumbnailUrl,width: 160, height: 150,fit: BoxFit.fill),
          ),
          SizedBox(width: 5.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title, style: TextStyle(color: Palette.darkBlue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.0,),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo, style: TextStyle(color: Palette.darkBlue, fontSize: 15.0)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "Total Price: ",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Palette.darkBlue,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  r"$ ",
                                  style: TextStyle(color: Palette.darkBlue, fontSize: 16.0),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Palette.darkBlue,
                                      fontWeight: FontWeight.bold

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
          SizedBox(width: 10.0,),

        ],
      ),
    ),
  );
}