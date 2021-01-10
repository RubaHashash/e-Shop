import 'package:e_shop_app/Admin/AdminDrivers.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddDriverPage extends StatefulWidget {
  @override
  _AddDriverPageState createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  TextEditingController _ID = TextEditingController();
  TextEditingController _NAME = TextEditingController();
  TextEditingController _PASSWORD = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
                color: Colors.white
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Palette.darkBlue,
              onPressed: (){
                clearFormInfo();
                Route route = MaterialPageRoute(builder: (c) => AdminDriver());
                Navigator.pushReplacement(context, route);
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 70),
            child: Row(
              children: [
                Text(
                  "New Driver",
                  style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                ),
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 8.0),

              child: IconButton(
                icon: Icon(Icons.add, color: Palette.darkBlue, size: 25),
                onPressed: (){
                  saveItemInfo();
                  Route route = MaterialPageRoute(builder: (c) => AdminDriver());
                  Navigator.pushReplacement(context, route);
                },
              ),
            )
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              child: Icon(Icons.drive_eta, size: 200, color: Palette.darkBlue,),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.drive_eta_outlined, color: Palette.darkBlue,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  controller: _ID,
                  decoration: InputDecoration(
                    hintText: "Driver ID",
                    hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(color: Palette.darkBlue),


            ListTile(
              leading: Icon(Icons.store_mall_directory_outlined, color: Palette.darkBlue,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  controller: _NAME,
                  decoration: InputDecoration(
                    hintText: "Driver Name",
                    hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(color: Palette.darkBlue),


            ListTile(
              leading: Icon(Icons.store_mall_directory_outlined, color: Palette.darkBlue,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  controller: _PASSWORD,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Driver Password",
                    hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(color: Palette.darkBlue),
          ],
        ),
      ),
    );
  }

  clearFormInfo(){

    setState(() {
      _ID.clear();
      _NAME.clear();
      _PASSWORD.clear();
    });

  }

  saveItemInfo(){
    var uuid = Uuid();

    shopApp.firestore.collection("drivers").document(uuid.v4()).setData({
      "driverId": _ID.text.trim(),
      "driverName": _NAME.text.trim(),
      "password": _PASSWORD.text.trim(),

    });

    setState(() {
      _ID.clear();
      _NAME.clear();
      _PASSWORD.clear();
    });
  }
}
