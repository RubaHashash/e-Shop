import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Store/Search.dart';
import 'package:e_shop_app/Widgets/HorizontalList.dart';
import 'package:e_shop_app/Widgets/MyDrawer.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 210),
                    child: Text("Recent Products",
                      style: TextStyle(fontSize: 25.0, color: Palette.darkBlue, fontWeight: FontWeight.bold, fontFamily: "PatrickHand"),
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
                    return RecentProducts(model, context);
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


Widget RecentProducts(ItemModel model, BuildContext context, {Color background, removeCartFunction}){
  double width = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      height: 160.0,
      width: width,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Image.network(model.thumbnailUrl, width: 165, height: 140,fit: BoxFit.fill),
          ),
          SizedBox(width: 4.0,),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 25, bottom: 29),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Palette.darkBlue,
                        blurRadius: 2.0
                    ),
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.title, style: TextStyle(color: Palette.darkBlue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Palette.orange
                          ),
                          alignment: Alignment.topLeft,
                          width: 40.0,
                          height: 43.0,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "50%", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 15.0),
                                ),
                                Text("OFF",style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"Original Price: $ ",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                  Text(
                                    (model.price + model.price).toString(),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    "New Price: ",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Palette.darkBlue,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    r"$ ",
                                    style: TextStyle(color: Palette.darkBlue, fontSize: 16.0),
                                  ),
                                  Text(
                                    (model.price).toString(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Palette.darkBlue,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

}
