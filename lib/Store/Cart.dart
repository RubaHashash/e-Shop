import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Address/Address.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Counters/totalMoney.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Store/StoreHome.dart';
import 'package:e_shop_app/Widgets/customAppBar.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  double totalAmount;
  @override
  void initState(){
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(shopApp.sharedPreferences.getStringList("userCart").length == 1){
              Fluttertoast.showToast(msg: "Cart is Empty.");
            }
            else{
              Route route = MaterialPageRoute(builder: (c) => Address(totalAmount: totalAmount));
              Navigator.pushReplacement(context, route);
            }
          },
        label: Text("Check Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "PatrickHand", fontSize: 20.0)),
        backgroundColor: Palette.darkBlue,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      body: CustomScrollView(
        slivers: [
          // a singlebox widgets that takes two consumers dependent on each other(total amount+cart items)
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c){
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                        r"Total Price: $ "+ "${amountProvider.totalAmount.toString()}",
                        style: TextStyle(color: Palette.darkBlue, fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }),
          ),

          // we need to recieve a sequesnce of items so we used stream builder listening to the items collection
          StreamBuilder<QuerySnapshot>(
            stream: shopApp.firestore.collection("items")
              .where("shortInfo", whereIn: shopApp.sharedPreferences.getStringList("userCart")).snapshots(),
            builder: (context, snapshot){
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress()))
                  : snapshot.data.documents.length == 0
                  ? beginbuildingCart()
                  : SliverList(             // multiple of sliverBoxAdapter
                      delegate: SliverChildBuilderDelegate(
                          (context,index){
                            ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                            if(index == 0){
                              totalAmount = 0;
                              totalAmount = model.price + totalAmount;
                             }else{
                              totalAmount = model.price + totalAmount;
                            }

                            if(snapshot.data.documents.length -1 == index){
                              // to display the total amount once the build finish, we use addPostFrameCallback
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(context, listen: false).display(totalAmount);
                              });
                            }
                            return sourceInfo(model,context, removeCartFunction: () => removeItemFromUserCart(model.shortInfo));
                          },

                        childCount: snapshot.hasData ? snapshot.data.documents.length : 0,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  beginbuildingCart(){
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon, color: Palette.darkBlue),
              Text("Cart is Empty."),
              Text("Start adding items to your Cart."),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsID){
    List shopList = shopApp.sharedPreferences.getStringList("userCart");
    shopList.remove(shortInfoAsID);

    shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
        .updateData({"userCart": shopList}).then((value) {
      Fluttertoast.showToast(msg: "Item Removed Successfully.");
      shopApp.sharedPreferences.setStringList("userCart", shopList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;
    });
  }
}