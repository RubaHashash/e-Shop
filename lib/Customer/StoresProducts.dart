import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Customer/Cart.dart';
import 'package:e_shop_app/Customer/Products.dart';
import 'package:e_shop_app/Customer/Search.dart';
import 'package:e_shop_app/Customer/StoreHome.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class StoresProducts extends StatefulWidget {

  final storeName;
  final storeID;

  const StoresProducts({Key key, this.storeName, this.storeID}) : super(key: key);
  @override
  _StoresProductsState createState() => _StoresProductsState();
}

class _StoresProductsState extends State<StoresProducts> {
  final List<String> categories = ["All","Clothes", "Electronics", "Home Decoration", "Souvenir", "Others"];

  final categorySelected = TextEditingController();
  var selected = "";
  Future<QuerySnapshot> docList;


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
            padding: const EdgeInsets.only(top: 17.0, left: 70),
            child: Row(
              children: [
                Text(
                  widget.storeName,
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

      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: DropDownField(
                controller: categorySelected,
                hintText: "Select any Category",
                enabled: true,
                itemsVisibleInDropdown: 3,
                items: categories,
                onValueChanged: (value){
                  setState(() {
                    selected = value;
                    startSearching(selected);
                  });
                },
              ),
            ),
          ),

          selected == ""
            ? StreamBuilder<QuerySnapshot>(
                stream: shopApp.firestore.collection("items").where("storeName", isEqualTo: widget.storeName)
                    .orderBy("publishedDate", descending: true).snapshots(),
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
            )
            : FutureBuilder<QuerySnapshot>(
                future: docList,
                builder: (context, snapshot){
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No data available"),
                        )
                      )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context,index){
                          ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                          return sourceInfo(model, context);
                          },
                          itemCount: snapshot.data.documents.length,
                      );
                },
            ),
        ],
      ),

    );
  }

  Future startSearching(String query) async{

    if(query == "All"){
      docList = shopApp.firestore.collection("items").where("storeName", isEqualTo: widget.storeName)
          .orderBy("publishedDate", descending: true).getDocuments();
    }else{
      docList = shopApp.firestore.collection("items").where("storeName", isEqualTo: widget.storeName)
          .where("category", isEqualTo: query).orderBy("publishedDate", descending: true).getDocuments();
    }



  }

}
