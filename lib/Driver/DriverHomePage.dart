import 'package:e_shop_app/Authentication/MainPage.dart';
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
                  icon: Icon(Icons.exit_to_app),
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
      ),
    );
  }
}
