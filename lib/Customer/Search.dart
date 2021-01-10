import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/StoreManager/ManagerAddProduct.dart';
import 'package:e_shop_app/StoreManager/ManagerProducts.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Customer/Cart.dart';
import 'package:e_shop_app/Customer/StoreHome.dart';
import 'package:e_shop_app/Customer/Products.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  Future<QuerySnapshot> docList;

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
              padding: const EdgeInsets.only(top: 17.0, left: 105),
              child: Row(
                children: [
                  Text(
                    "Search",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,

            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => StoreHome());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),

            actions: [
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            searchWidget(),
            Flexible(
              child: FutureBuilder<QuerySnapshot>(
                future: docList,
                builder: (context, snapshot){
                  return snapshot.hasData
                      ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No data available"),
                  );
                },
              ),
            ),
          ],

        ),
      ),
    );
  }

  searchWidget(){
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      color: Colors.grey[100],
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0
              ),
            ]
        ),

        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Icon(Icons.search, color: Palette.darkBlue),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value){
                    startSearching(value.toLowerCase());
                  },
                  decoration: InputDecoration.collapsed(hintText: "Search here ..."),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async{

    docList = Firestore.instance.collection("items").where("shortInfo", isEqualTo: query).getDocuments();

  }
}


class SearchStoreProduct extends StatefulWidget {

  final storeID;

  const SearchStoreProduct({Key key, this.storeID}) : super(key: key);

  @override
  _SearchStoreProductState createState() => _SearchStoreProductState();
}

class _SearchStoreProductState extends State<SearchStoreProduct> {

  Future<QuerySnapshot> docList;

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
              padding: const EdgeInsets.only(top: 17.0, left: 105),
              child: Row(
                children: [
                  Text(
                    "Search",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,

            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => ManagerProducts());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            searchWidget(),
            Flexible(
              child: FutureBuilder<QuerySnapshot>(
                future: docList,
                builder: (context, snapshot){
                  return snapshot.hasData
                      ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                      return myProducts(model, context);
                    },
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No data available"),
                  );
                },
              ),
            ),
          ],

        ),
      ),
    );
  }

  searchWidget(){
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      color: Colors.grey[100],
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0
              ),
            ]
        ),

        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Icon(Icons.search, color: Palette.darkBlue),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value){
                    startSearching(value.toLowerCase());
                  },
                  decoration: InputDecoration.collapsed(hintText: "Search here ..."),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async{

    docList = Firestore.instance.collection("items").where("store", isEqualTo: widget.storeID)
        .where("shortInfo", isEqualTo: query).getDocuments();

  }
}

class SearchStoreCategoryProduct extends StatefulWidget {
  final storeID;
  final category;

  const SearchStoreCategoryProduct({Key key, this.storeID, this.category}) : super(key: key);
  @override
  _SearchStoreCategoryProductState createState() => _SearchStoreCategoryProductState();
}

class _SearchStoreCategoryProductState extends State<SearchStoreCategoryProduct> {

  Future<QuerySnapshot> docList;

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
              padding: const EdgeInsets.only(top: 17.0, left: 105),
              child: Row(
                children: [
                  Text(
                    "Search",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,

            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => ManagerAddProduct(category_name: widget.category,));
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            searchWidget(),
            Flexible(
              child: FutureBuilder<QuerySnapshot>(
                future: docList,
                builder: (context, snapshot){
                  return snapshot.hasData
                      ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                      return myProducts(model, context);
                    },
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No data available"),
                  );
                },
              ),
            ),
          ],

        ),
      ),
    );
  }

  searchWidget(){
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      color: Colors.grey[100],
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0
              ),
            ]
        ),

        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Icon(Icons.search, color: Palette.darkBlue),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value){
                    startSearching(value.toLowerCase());
                  },
                  decoration: InputDecoration.collapsed(hintText: "Search here ..."),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async{

    docList = Firestore.instance.collection("items").where("store", isEqualTo: widget.storeID)
        .where("category", isEqualTo: widget.category)
        .where("shortInfo", isEqualTo: query).getDocuments();

  }
}
