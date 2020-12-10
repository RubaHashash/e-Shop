import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Widgets/customAppBar.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.grey[200],
        appBar: MyAppBar(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
               padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Image.network(widget.itemModel.thumbnailUrl),
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
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
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
                                widget.itemModel.title, style: TextStyle(color: Palette.darkBlue,fontSize: 35.0, fontWeight: FontWeight.bold, fontFamily: "PatrickHand"),
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
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      widget.itemModel.longDescription, style: TextStyle(color: Palette.darkBlue,fontSize: 18.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top:10.0, right: 25.0, bottom: 5.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      r"$ " + widget.itemModel.price.toString(),
                                      style: TextStyle(color: Palette.darkBlue,fontSize: 20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height:10.0),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                              child: InkWell(
                                onTap: () => print("clicked"),
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
                                  width: 250,
                                  height: 50.0,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 40.0)),
                                        Icon(Icons.favorite_border_sharp, color: Colors.white),
                                        Padding(padding: EdgeInsets.all(8.0)),
                                        Text("Add to Cart", style: TextStyle(color: Colors.white ,fontSize: 22.0, fontWeight: FontWeight.w700),)
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



// body: Stack(
// children: [
// Positioned.fill(
// child: Column(
// children: [
// Expanded(
// child: Container(
// color: Colors.grey,
// ),
// ),
// Expanded(
// child: Container(
// color: Colors.white,
// ),
// ),
// ],
// ),
// ),
// Container(
// margin: EdgeInsets.only(top: 40.0),
// child: Align(
// alignment: Alignment.topCenter,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// IconButton(
// icon: Icon(Icons.arrow_back_ios),
// onPressed: (){
// Navigator.pop(context);
// }
// ),
// IconButton(
// icon: Icon(Icons.add_shopping_cart),
// onPressed: (){
// Navigator.pop(context);
// }
// )
// ],
// ),
// ),
// ),
//
// Container(
// margin: EdgeInsets.only(top: 90.0),
// child: Align(
// alignment: Alignment.topCenter,
// child: Image.network(widget.itemModel.thumbnailUrl),
// ),
// ),
//
// Align(
// alignment: Alignment.center,
// child: Container(
// height: 100,
// margin: EdgeInsets.symmetric(horizontal: 20),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(20),
// boxShadow: [
// BoxShadow(
// color: Colors.grey,
// blurRadius: 5.0
// ),
// ]
// ),
// ),
// )
// ],
// ),
