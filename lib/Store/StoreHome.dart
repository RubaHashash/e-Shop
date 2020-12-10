import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Store/ProductPage.dart';
import 'package:e_shop_app/Widgets/MyDrawer.dart';
import 'package:e_shop_app/Widgets/SearchBox.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
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
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Quick Shop",
                style: TextStyle(fontSize: 55.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Palette.darkBlue),
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
                                  counter.count.toString(),
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
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBoxDelegate(),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("items").orderBy("publishedDate", descending: true).snapshots(),
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


Widget sourceInfo(ItemModel model, BuildContext context, {Color background, removeCartFunction}){

  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Palette.darkBlue,
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 190.0,
        width: 190.0,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Image.network(model.thumbnailUrl, width: 160, height: 160,fit: BoxFit.fill),
            ),
            SizedBox(width: 4.0,),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 25),
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
                    SizedBox(height: 15.0),
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
                    SizedBox(height: 5.0,),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(model.shortInfo, style: TextStyle(color: Palette.darkBlue, fontSize: 15.0)),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                          )
                        ],
                      ),
                    ),

                    Flexible(
                      child: Container(

                      ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

}