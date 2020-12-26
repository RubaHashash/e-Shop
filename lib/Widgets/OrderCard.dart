import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Orders/OrderDetails.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

int counter =0;
class OrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({Key key, this.itemCount, this.data, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route;
        // if(counter == 0){
        //   counter = counter +1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        // }
        
        Navigator.push(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top: 2.0, bottom: 10.0, left: 10.0, right: 10.0),
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


Widget sourceOrderInfo(ItemModel model, BuildContext context, {Color background}){

  double width = MediaQuery.of(context).size.width;

  return Container(
    color: Colors.grey[100],
    height: 180.0,
    width: width,
    child: Row(
      children: [
        SizedBox(width: 10.0,height: 10.0,),
        ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Image.network(model.thumbnailUrl,height: 140.0, width: 180.0,fit: BoxFit.fill),
        ),
        SizedBox(width: 5.0,),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 25, bottom: 25),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                ),
                boxShadow: [
                  BoxShadow(
                      color: Palette.darkBlue,
                      blurRadius: 2.0
                  ),
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.0),
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
        ),
        SizedBox(width: 10.0,),

      ],
    ),
  );
}