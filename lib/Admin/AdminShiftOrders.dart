import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Widgets/AdminOrderCard.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _AdminShiftOrdersState createState() => _AdminShiftOrdersState();
}

class _AdminShiftOrdersState extends State<AdminShiftOrders> {
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
                "Orders",
                style: TextStyle(fontSize: 50.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Palette.darkBlue),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => AdminHome());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),

        // get the list of orders from firebase collection
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").snapshots(),

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
                        ? AdminOrderCard(
                      itemCount: snapshot.data.documents.length,
                      data: snapshot.data.documents,
                      orderID: snapshots.data.documents[index].documentID,
                      orderBy: snapshots.data.documents[index].data["orderBy"],
                      addressID: snapshots.data.documents[index].data["addressID"],
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
    );
  }
}
