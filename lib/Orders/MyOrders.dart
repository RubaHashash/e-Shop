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
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration:  BoxDecoration(
                  color: Colors.white
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 17.0, left: 90),
              child: Row(
                children: [
                  Text(
                    "My Orders",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
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
            SizedBox(height: 20,),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: shopApp.firestore.collection("orders")
                    .where("orderBy", isEqualTo: shopApp.sharedPreferences.getString("uid"))
                    .where("isRecieved", isEqualTo: false).snapshots(),

                builder: (c, snapshots){
                  return !snapshots.hasData
                      ? Center(child: circularProgress())
                      : snapshots.data.documents.length == 0
                      ? NoOrders()
                      : ListView.builder(
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
                                        orderID: snapshots.data.documents[index].documentID,
                                        orderByName: snapshots.data.documents[index].data["orderByName"],
                                        driver: snapshots.data.documents[index].data["AssignedDriver"],
                                        orderTime: snapshots.data.documents[index].data["orderTime"]

                                )
                                    : Center(child: circularProgress());
                              },
                              );
                          },
                        );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

NoOrders(){
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Card(
      color: Colors.white.withOpacity(0.5),
      child: Container(
        height: 100,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_emoticon, color: Palette.darkBlue),
            Text("You haven't done any order."),
            Text("Start sending your orders NOW."),
          ],
        ),
      ),
    ),
  );
}
