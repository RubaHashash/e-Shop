import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/StoreManager/ManagerHomePage.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Widgets/ManagerOrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class ManagerShiftOrders extends StatefulWidget {
  @override
  _ManagerShiftOrdersState createState() => _ManagerShiftOrdersState();
}

class _ManagerShiftOrdersState extends State<ManagerShiftOrders> {
  
  final storeName = shopApp.sharedPreferences.getString("adminName");
  final orderStatus = "Transferred";

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
                    "Orders",
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
                  Route route = MaterialPageRoute(builder: (c) => ManagerHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),

        // get the list of orders from firebase collection
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").where("storesID", arrayContains: storeName)
              .where("isReceived", isEqualTo: false).snapshots(),

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
                      .where("title", whereIn: snapshots.data.documents[index].data["productID"])
                      .where("store", isEqualTo: shopApp.sharedPreferences.getString("storeID")).getDocuments(),
                  builder: (c, snapshot){
                    return snapshot.hasData
                        ? ManagerOrderCard(
                      itemCount: snapshot.data.documents.length,
                      data: snapshot.data.documents,
                      orderID: snapshots.data.documents[index].documentID,
                      orderBy: snapshots.data.documents[index].data["orderBy"],
                      orderByName: snapshots.data.documents[index].data["orderByName"],
                      addressID: snapshots.data.documents[index].data["addressID"],
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
            Text("No Orders found."),
            Text("Come back later."),
          ],
        ),
      ),
    ),
  );
}
