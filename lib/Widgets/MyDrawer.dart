import 'package:e_shop_app/Address/AddAddress.dart';
import 'package:e_shop_app/Authentication/MainPage.dart';
import 'package:e_shop_app/Orders/MyOrders.dart';
import 'package:e_shop_app/Profile/AboutUS.dart';
import 'package:e_shop_app/Profile/ProfilePage.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Store/Search.dart';
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
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Palette.darkBlue
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Text('${shopApp.sharedPreferences.getString("name")[0].toUpperCase()}',
                  style: TextStyle(color: Palette.darkBlue, fontSize: 45.0, fontWeight: FontWeight.w500)),
            ),
            accountName: Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(
                    shopApp.sharedPreferences.getString("name"),
                    style: TextStyle(color: Colors.white, fontSize: 33.0, fontFamily: "Signatra", fontWeight: FontWeight.w500),
                  ),
            ),
            accountEmail: Text(
              shopApp.sharedPreferences.getString("email"),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),

          SizedBox(height: 10),
          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.home, color: Palette.darkBlue),
            title: Text("Home", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => MyOrders());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.reorder, color: Palette.darkBlue),
            title: Text("My Orders", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => CartPage());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.shopping_cart, color: Palette.darkBlue),
            title: Text("My Cart", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => SearchProduct());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.search, color: Palette.darkBlue),
            title: Text("Search", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => AddAddress());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.add_location, color: Palette.darkBlue),
            title: Text("Add New Address", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => ProfilePage());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.person, color: Palette.darkBlue),
            title: Text("Profile", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => AboutUs());
              Navigator.pushReplacement(context, route);
            },
            leading: Icon(Icons.info_rounded, color: Palette.darkBlue),
            title: Text("About Us", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          SizedBox(height: 20.0),
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

