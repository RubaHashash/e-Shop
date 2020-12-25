import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Store/Search.dart';
import 'package:e_shop_app/Widgets/HorizontalList.dart';
import 'package:e_shop_app/Widgets/MyDrawer.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  List<DocumentSnapshot> categories = <DocumentSnapshot> [];
  List<String> images = ["assets/CatImage/image1.jpg", "assets/CatImage/image2.jpg",
    "assets/CatImage/image3.jpg", "assets/CatImage/image4.jpg",  "assets/CatImage/image5.jpeg",];

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
    double width = MediaQuery.of(context).size.width;
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
                  Icon(Icons.shopping_bag, size: 37,),
                  SizedBox(width: 10),
                  Text(
                    "Shopick",
                    style: TextStyle(fontSize: 47.0, color: Palette.darkBlue, fontFamily: "Signatra"),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Palette.darkBlue),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 10),
                child: IconButton(
                  icon: Icon(Icons.search, color: Palette.darkBlue),
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                )
              ),
            ],
          ),
        ),

        drawer: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: MyDrawer(),
        ),

        body: CustomScrollView(
          slivers: [

            SliverList(delegate: SliverChildListDelegate(
              List.generate(1, (index) {
                return imageSlider;
              })
            )),

            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Categories",
                      style: TextStyle(fontSize: 25.0, color: Palette.darkBlue, fontWeight: FontWeight.bold, fontFamily: "PatrickHand"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:50.0),
                    child: HorizontalList(categories: categories, images: images),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// image slider
Widget imageSlider = Padding(
  padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
  child: Container(
    height: 230.0,
    child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/images/picture1.jpg'),
        AssetImage('assets/images/picture2.jpg'),
        AssetImage('assets/images/picture3.jpg'),
        AssetImage('assets/images/picture4.jpg'),
        AssetImage('assets/images/picture5.jpg'),
      ],
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 4.0,
      indicatorBgPadding: 6.0,
    ),
  ),
);
