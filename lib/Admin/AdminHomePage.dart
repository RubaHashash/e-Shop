import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminShiftOrders.dart';
import 'package:e_shop_app/Widgets/AdminCategoryCard.dart';
import 'package:e_shop_app/Widgets/AdminDrawer.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  List<DocumentSnapshot> categories = <DocumentSnapshot> [];
  List<String> images = ["assets/CatImage/picture1.jpg", "assets/CatImage/picture2.jpg",
    "assets/CatImage/picture3.jpg", "assets/CatImage/picture4.jpg",  "assets/CatImage/picture5.jpg",];

  Future<List> getCategories () {
    return shopApp.firestore.collection("categories").getDocuments().then((snap){
      return snap.documents;
    });
  }

  _getCategoriesName() async{
    List<DocumentSnapshot> data = await getCategories();
    setState(() {
      categories = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoriesName();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          iconTheme: IconThemeData(color: Palette.darkBlue),

          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(Icons.border_color, color: Palette.darkBlue),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
                  Navigator.pushReplacement(context, route);
                },
              ),
            )
          ],
        ),
      ) ,
      drawer: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: AdminDrawer(),
      ),

      body: GridView.builder(
        scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index){
            return AdminCategoryCard(category_index: categories[index]['categoryName'], images: images[index]);
          },
      ),
    );
  }
}


