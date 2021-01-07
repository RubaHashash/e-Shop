import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Store/Products.dart';
import 'package:e_shop_app/Store/Search.dart';
import 'package:e_shop_app/Widgets/HorizontalList.dart';
import 'package:e_shop_app/Widgets/StoresHorizontalList.dart';
import 'package:e_shop_app/Widgets/MyDrawer.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';


class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  List<DocumentSnapshot> categories = <DocumentSnapshot> [];
  List<DocumentSnapshot> stores = <DocumentSnapshot> [];

  List<String> images = ["assets/CatImage/image1.jpg", "assets/CatImage/image2.jpg",
    "assets/CatImage/image3.jpg", "assets/CatImage/image4.jpg",  "assets/CatImage/image5.jpeg",];


  Future<List> getCategories () {
    return shopApp.firestore.collection("categories").getDocuments().then((snap){
      return snap.documents;
    });
  }

  Future<List> getStores () {
    return shopApp.firestore.collection("admins").getDocuments().then((snap){
      return snap.documents;
    });
  }

  _getCategoriesName() async{
    List<DocumentSnapshot> data = await getCategories();
    setState(() {
      categories = data;
    });
  }

  _getStoresName() async{
    List<DocumentSnapshot> data = await getStores();
    setState(() {
      stores = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoriesName();
    _getStoresName();
  }


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
              padding: const EdgeInsets.only(top: 10.0, left: 40),
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
                  icon: Icon(Icons.search, color: Palette.darkBlue),
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                )
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart, color: Palette.darkBlue),
                      onPressed: (){
                        Route route = MaterialPageRoute(builder: (c) => CartPage());
                        Navigator.pushReplacement(context, route);
                      },
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Palette.lightBlue,
                          ),
                          Positioned(
                            top: 3.0,
                            bottom: 4.0,
                            left: 6.0,
                            child: Consumer<CartItemCounter>(
                                builder: (context, counter, _){
                                  return Text(
                                    (shopApp.sharedPreferences.getStringList("userCart").length - 1).toString(),
                                    style: TextStyle(color: Palette.darkBlue, fontSize: 13.0, fontWeight: FontWeight.w500),
                                  );
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
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
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                    child: Text("Categories",
                      style: TextStyle(fontSize: 21.0, color: Palette.darkBlue, fontWeight: FontWeight.bold, fontFamily: "Cabin"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:44.0),
                    child: HorizontalList(categories: categories, images: images),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 212.0, left: 10.0),
                    child: Text("Stores",
                      style: TextStyle(fontSize: 21.0, color: Palette.darkBlue, fontWeight: FontWeight.bold, fontFamily: "Cabin"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:242.0),
                    child: StoresHorizontalList(stores: stores),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 412),
                    child: Text("Recent Products",
                      style: TextStyle(fontSize: 21.0, color: Palette.darkBlue, fontWeight: FontWeight.bold, fontFamily: "Cabin"),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("items").orderBy("publishedDate", descending: true).limit(5).snapshots(),
              builder: (context, dataSnapshot){
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context,index){
                    ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                    return sourceInfo(model, context);
                  },
                  itemCount: dataSnapshot.data.documents.length,
                );
              },
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
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Palette.darkBlue,
              blurRadius: 3.0
          ),
        ]
    ),
    height: 230.0,
    child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/images/picture1.jpg'),
        AssetImage('assets/images/picture3.jpg'),
        AssetImage('assets/images/picture2.jpg'),
        AssetImage('assets/images/picture5.jpg'),
        AssetImage('assets/images/picture4.jpg'),
      ],
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 4.0,
      indicatorBgPadding: 6.0,
    ),
  ),
);

