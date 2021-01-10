import 'package:e_shop_app/StoreManager/ManagerHomePage.dart';
import 'package:e_shop_app/StoreManager/ManagerProducts.dart';
import 'package:e_shop_app/StoreManager/ManagerShiftOrders.dart';
import 'package:e_shop_app/Authentication/MainPage.dart';
import 'package:e_shop_app/Profile/ManagerProfilePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagerDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: Palette.darkBlue
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Text('${shopApp.sharedPreferences.getString("adminName")[0].toUpperCase()}',
                  style: TextStyle(color: Palette.darkBlue, fontSize: 45.0, fontWeight: FontWeight.w500)),
            ),
            accountName: Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(
                shopApp.sharedPreferences.getString("adminName"),
                style: TextStyle(color: Colors.white, fontSize: 33.0, fontFamily: "Signatra", fontWeight: FontWeight.w500),
              ),
            ),
            accountEmail: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                "Available",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),

          SizedBox(height: 10),
          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => ManagerHomePage());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.home, color: Palette.darkBlue),
            title: Text("Home", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => ManagerShiftOrders());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.reorder, color: Palette.darkBlue),
            title: Text("Orders", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => ManagerProducts());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.shop, color: Palette.darkBlue),
            title: Text("All Products", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => ManagerProfilePage());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.person, color: Palette.darkBlue),
            title: Text("Profile", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),



          SizedBox(height: 190),
          ListTile(
            onTap: (){
              shopApp.auth.signOut().then((value){
                Route route = MaterialPageRoute(builder: (c) => MainPage());
                Navigator.pushReplacement(context, route);
              });
            },
            leading: Icon(Icons.exit_to_app, color: Palette.darkBlue),
            title: Text("Logout", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),


        ],
      ),
    );
  }
}

