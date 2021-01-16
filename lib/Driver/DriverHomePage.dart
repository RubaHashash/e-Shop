import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Authentication/MainPage.dart';
import 'package:e_shop_app/Profile/DriverProfilePage.dart';
import 'package:e_shop_app/Widgets/DriverOrderCard.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
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
              padding: const EdgeInsets.only(top: 10.0, left: 60),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag, size: 37, color: Palette.darkBlue,),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Shopick",
                      style: TextStyle(fontSize: 47.0, color: Palette.darkBlue, fontFamily: "Signatra"),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.person),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => DriverProfilePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
            actions: [
              IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 14.0, right: 10.0),
                    child: Icon(Icons.exit_to_app, color: Palette.darkBlue,),
                  ),
                  onPressed: (){
                    shopApp.auth.signOut().then((value){
                      Route route = MaterialPageRoute(builder: (c) => MainPage());
                      Navigator.pushReplacement(context, route);
                    });
                  }
              ),
            ],
          ),
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").where("isSuccess", isEqualTo: "Transferred")
              .where("AssignedDriver", isEqualTo: "").snapshots(),

          builder: (c, snapshots){
            return snapshots.hasData
                ? ListView.builder(
              itemCount: snapshots.data.documents.length,
              itemBuilder: (c, index){
                return FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance.collection("items")
                      .where("title", whereIn: snapshots.data.documents[index].data["productID"]).getDocuments(),
                  builder: (c, snapshot){
                    return snapshot.hasData
                        ? DriverOrderCard(
                      itemCount: snapshot.data.documents.length,
                      data: snapshot.data.documents,
                      orderID: snapshots.data.documents[index].documentID,
                      orderBy: snapshots.data.documents[index].data["orderBy"],
                      addressID: snapshots.data.documents[index].data["addressID"],
                      orderByName: snapshots.data.documents[index].data["orderByName"],
                      driver: snapshots.data.documents[index].data["AssignedDriver"],
                      orderTime: snapshots.data.documents[index].data["orderTime"]
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
