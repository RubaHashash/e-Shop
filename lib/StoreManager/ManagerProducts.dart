import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/StoreManager/ManagerHomePage.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Customer/Search.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class ManagerProducts extends StatefulWidget {
  @override
  _ManagerProductsState createState() => _ManagerProductsState();
}

class _ManagerProductsState extends State<ManagerProducts> {

  final storeId = shopApp.sharedPreferences.getString("storeID");


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
              padding: const EdgeInsets.only(top: 17.0, left: 90),
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
            iconTheme: IconThemeData(color: Palette.darkBlue),
            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => ManagerHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),

            actions: [
              Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.search, color: Palette.darkBlue),
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c) => SearchStoreProduct(storeID: shopApp.sharedPreferences.getString("storeID"),));
                      Navigator.pushReplacement(context, route);
                    },
                  )
              ),
            ],
          ),
        ),

        body: CustomScrollView(
          slivers: [

           SliverToBoxAdapter(
              child: Padding(padding: EdgeInsets.all(5.0)),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("items").where("store", isEqualTo: storeId)
                  .orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, dataSnapshot){
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context,index){
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      return myProducts(model, context);
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


Widget myProducts(ItemModel model, BuildContext context){
  double width = MediaQuery.of(context).size.width;

  return Padding(
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
      width: width,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                bottomLeft: Radius.circular(14.0)
            ),
            child: Image.network(model.thumbnailUrl, width: 160, height: 150,fit: BoxFit.fill),
          ),
          SizedBox(width: 4.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

              ],
            ),
          ),
          SizedBox(width: 5.0,),

        ],
      ),
    ),
  );

}
