import 'package:e_shop_app/Authentication/LoginPage.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                    color: Palette.darkBlue,
                    width: 3.0
                ),
              ),
            ),

            child: Column(
              children: [
                SizedBox(height: 10.0),
                Text(
                  shopApp.sharedPreferences.getString("name"),
                  style: TextStyle(color: Palette.darkBlue, fontSize: 45.0, fontFamily: "Signatra", fontWeight: FontWeight.w600),
                ),
                Text('Active', style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontFamily: "PatrickHand"))
              ],
            ),
          ),

          SizedBox(height: 12.0),

          Container(
            padding: EdgeInsets.only(top: 1.0, bottom: 100),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                    color: Palette.darkBlue,
                    width: 3.0
                ),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Palette.darkBlue, size: 30),
                    title: Text("Home", style: TextStyle(color: Palette.darkBlue, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "PatrickHand")),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: ListTile(
                    leading: Icon(Icons.reorder, color: Palette.darkBlue, size: 30),
                    title: Text("My Orders", style: TextStyle(color: Palette.darkBlue, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "PatrickHand")),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart, color: Palette.darkBlue, size: 30),
                    title: Text("My Cart", style: TextStyle(color: Palette.darkBlue, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "PatrickHand")),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: ListTile(
                    leading: Icon(Icons.search, color: Palette.darkBlue, size: 30),
                    title: Text("Search", style: TextStyle(color: Palette.darkBlue, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "PatrickHand")),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: ListTile(
                    leading: Icon(Icons.add_location, color: Palette.darkBlue, size: 30),
                    title: Text("Add New Address", style: TextStyle(color: Palette.darkBlue, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: "PatrickHand")),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 70.0, bottom: 3.0),
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Palette.darkBlue, size: 30),
                    title: Text("Logout", style: TextStyle(color: Palette.darkBlue, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "PatrickHand")),
                    onTap: (){
                      shopApp.auth.signOut().then((value){
                        Route route = MaterialPageRoute(builder: (c) => LoginPage());
                        Navigator.pushReplacement(context, route);
                      });
                    },
                  ),
                ),


              ],
            )
          )
        ],
      ),
    );
  }
}

