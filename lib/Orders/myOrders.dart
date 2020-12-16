import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/Widgets/OrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                  color: Colors.white
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Quick Shop",
                style: TextStyle(fontSize: 50.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Palette.darkBlue),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => StoreHome());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),

        // get the list of orders from firebase collection
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 14.0),
                child: Text('My Orders', style: TextStyle(color: Palette.darkBlue,
                    fontWeight: FontWeight.bold, fontSize: 30.0, fontFamily: "PatrickHand")),
              ),
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                    .collection("orders").snapshots(),

                builder: (c, snapshots){
                  return snapshots.hasData
                      ? ListView.builder(
                          itemCount: snapshots.data.documents.length,
                          itemBuilder: (c, index){
                            return FutureBuilder<QuerySnapshot>(
                              future: Firestore.instance.collection("items")
                                  .where("shortInfo", whereIn: snapshots.data.documents[index].data["productID"]).getDocuments(),
                              builder: (c, snapshot){
                                return snapshot.hasData
                                    ? OrderCard(
                                        itemCount: snapshot.data.documents.length,
                                        data: snapshot.data.documents,
                                        orderID: snapshot.data.documents[index].documentID,
                                    )
                                    : Center(child: circularProgress());
                              },
                              );
                          },
                        )
                      : Center(child: circularProgress());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
