import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Store/Cart.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
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
                "Shopick",
                style: TextStyle(fontSize: 55.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
               padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: 350,
                                height: 220,
                                color: Colors.white,
                                  child: Image.network(widget.itemModel.thumbnailUrl, fit: BoxFit.fill,)
                              )
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: SizedBox(
                            height: 1.0,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: width,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0
                          ),
                        ]
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Text(
                                widget.itemModel.title, style: TextStyle(color: Palette.darkBlue,fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "PatrickHand"),
                              ),
                            ),
                          ),

                          Container(
                            width: width,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0
                                  ),
                                ]
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Description: ", style: TextStyle(color: Palette.darkBlue,fontSize: 18.0, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.itemModel.longDescription, style: TextStyle(color: Palette.darkBlue,fontSize: 17.0),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top:10.0, right: 25.0, bottom: 5.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      r"$ " + widget.itemModel.price.toString(),
                                      style: TextStyle(color: Palette.darkBlue,fontSize: 18.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height:10.0),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Center(
                              child: InkWell(
                                onTap: () => checkItemInCart(widget.itemModel.shortInfo, context),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Palette.darkBlue,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0
                                        ),
                                      ]
                                  ),
                                  width: 200,
                                  height: 50.0,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 22.0)),
                                        Icon(Icons.favorite, color: Colors.white),
                                        Padding(padding: EdgeInsets.all(8.0)),
                                        Text("Add to Cart", style: TextStyle(color: Colors.white ,fontSize: 20.0, fontWeight: FontWeight.w700),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0)
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
}
