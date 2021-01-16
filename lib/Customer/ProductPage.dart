import 'package:e_shop_app/Counters/ItemQuantity.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Customer/Cart.dart';
import 'package:e_shop_app/Customer/StoreHome.dart';
import 'package:e_shop_app/Customer/Products.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  var itemQuantity = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var quantityOfItems = Provider.of<ItemQuantity>(context, listen: false);

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
              padding: const EdgeInsets.only(top: 17.0, left: 70),
              child: Row(
                children: [
                  Text(
                    widget.itemModel.title,
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
                  quantityOfItems.display(1);
                  setState(() {
                    itemQuantity = 1;
                  });
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
            Container(
             padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              child: Image.network(widget.itemModel.thumbnailUrl, fit: BoxFit.fill, height: 300,)
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: width,
                    margin: EdgeInsets.only(top: 12),
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

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 23),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.itemModel.storeName, style: TextStyle(color: Palette.darkBlue,fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Divider(color: Palette.darkBlue, thickness: 0.5,),
                        ),
                        Container(
                          width: width,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
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
                                        "Description :", style: TextStyle(color: Palette.darkBlue,fontSize: 18.0, fontWeight: FontWeight.bold),
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
                                    style: TextStyle(color: Palette.darkBlue,fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height:10.0),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            SizedBox(width: 25),

                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    itemQuantity--;
                                  });
                                  quantityOfItems.decrement();
                                },
                                child: Container(
                                  width: 40,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      color: Palette.darkBlue,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0
                                        ),
                                      ]
                                  ),

                                  child: Center(
                                      child: Text("-", style: TextStyle(color: Colors.white, fontSize: 25),)
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Consumer<ItemQuantity>(builder: (context, counter, _){
                              return Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Center(
                                  child: Text("${counter.numberOfItems}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ),
                              );
                            }),
                            SizedBox(width: 15),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    itemQuantity++;
                                  });
                                  quantityOfItems.increment();
                                },
                                child: Container(
                                  width: 40,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                      color: Palette.darkBlue,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0
                                        ),
                                      ]
                                  ),

                                  child: Center(
                                      child: Text("+", style: TextStyle(color: Colors.white, fontSize: 25),)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: InkWell(
                                  onTap: () {
                                    quantityOfItems.display(1);
                                    itemQuantity >= 1 ?
                                      checkItemInCart(widget.itemModel.title, context)
                                        : Fluttertoast.showToast(msg: "Check the items quantity");
                                    setState(() {
                                      itemQuantity = 1;
                                    });
                                  },
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
                          ],
                        ),



                        SizedBox(height: 10.0)
                      ],
                    ),
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
