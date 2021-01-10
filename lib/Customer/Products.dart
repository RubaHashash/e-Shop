import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Customer/Cart.dart';
import 'package:e_shop_app/Customer/ProductPage.dart';
import 'package:e_shop_app/Customer/Search.dart';
import 'package:e_shop_app/Customer/StoreHome.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {

  final category;
  final category_images;

  const Products({Key key, this.category, this.category_images}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
              padding: const EdgeInsets.only(top: 17.0, left: 60),
              child: Row(
                children: [
                  Text(
                    "All Products",
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45)
                  ),
                ),
                padding: EdgeInsets.only(top: 4.0),
                width: width,
                height: 200,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45)
                    ),
                    child: Image.asset(widget.category_images)
                ),

              ),
            ),



            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("items").where("category", isEqualTo: widget.category)
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
            ),
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, {Color background, removeCartFunction}){
  double width = MediaQuery.of(context).size.width;

  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Palette.darkBlue,
    child: Padding(
      padding: EdgeInsets.only(left:10.0, right:10.0, bottom: 10, top:10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: [
              BoxShadow(
                  color: Palette.darkBlue,
                  blurRadius: 2.0
              ),
            ]
        ),
        height: 166.0,
        width: width,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  bottomLeft: Radius.circular(14.0)
              ),
              child: Image.network(model.thumbnailUrl, width: 165, height: 170,fit: BoxFit.fill),
            ),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(model.title, style: TextStyle(color: Palette.darkBlue, fontSize: 20.0, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0,),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(model.shortInfo, style: TextStyle(color: Palette.darkBlue, fontSize: 15.0)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
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
                  Container(
                    padding: EdgeInsets.only(left: 165),
                    child: Row(
                      children: [
                        removeCartFunction == null
                            ? IconButton(
                          icon: Icon(Icons.add_shopping_cart, color: Palette.darkBlue),
                          onPressed: (){
                            checkItemInCart(model.shortInfo, context);
                          },
                        )
                            : IconButton(
                          icon: Icon(Icons.remove_shopping_cart, color: Palette.darkBlue),
                          onPressed: (){
                            removeCartFunction();
                            Route route = MaterialPageRoute(builder: (c) => StoreHome());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
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
          ],
        ),
      ),
    ),
  );

}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}){

  return Container(
    height: 150.0,
    width: 150.0,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0 , 5), blurRadius: 10.0, color: Palette.darkBlue)
      ]
    ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20.0),
    child: Image.network(imgPath, height: 150.0, width: 150.0,fit: BoxFit.fill),
      ),
  );
}

void checkItemInCart(String shortInfoAsID, BuildContext context){

  shopApp.sharedPreferences.getStringList("userCart").contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context){

  List shopList = shopApp.sharedPreferences.getStringList("userCart");
  shopList.add(shortInfoAsID);

  shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
  .updateData({"userCart": shopList}).then((value) {
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");
    shopApp.sharedPreferences.setStringList("userCart", shopList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}