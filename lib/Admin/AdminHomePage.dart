import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminDrivers.dart';
import 'package:e_shop_app/Admin/AdminStores.dart';
import 'package:e_shop_app/Authentication/MainPage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  List<DocumentSnapshot> driverCount = <DocumentSnapshot> [];
  List<DocumentSnapshot> storesCount = <DocumentSnapshot> [];

  Future<List> getDriverCount(){
    return Firestore.instance.collection("drivers").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getStoresrCount(){
    return Firestore.instance.collection("admins").getDocuments().then((value){
      return value.documents;
    });
  }

  _getCounters() async{
    List<DocumentSnapshot> Driverdata = await getDriverCount();
    List<DocumentSnapshot> Storedata = await getStoresrCount();

    setState(() {
      driverCount = Driverdata;
      storesCount = Storedata;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCounters();
  }

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

        body: Row(
          children: [
            SizedBox(width: 5),
            InkWell(
              onTap: (){
                Route route = MaterialPageRoute(builder: (c) => AdminStores());
                Navigator.push(context, route);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Palette.darkBlue,
                            blurRadius: 10.0
                        ),
                      ]
                  ),
                  width: 170,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store, color: Palette.darkBlue, size: 45,)
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Stores", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                          SizedBox(width: 20),
                          Text(storesCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.w500),)

                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: (){
                Route route = MaterialPageRoute(builder: (c) => AdminDriver());
                Navigator.push(context, route);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Palette.darkBlue,
                            blurRadius: 10.0
                        ),
                      ]
                  ),
                  width: 170,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.drive_eta, color: Palette.darkBlue, size: 45,)
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Drivers", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                          SizedBox(width: 20),
                          Text(driverCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.w500),)

                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
