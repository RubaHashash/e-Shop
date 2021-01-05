import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'package:e_shop_app/Models/items.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class AdminProducts extends StatefulWidget {
  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {

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
                  Route route = MaterialPageRoute(builder: (c) => AdminHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),


        // body: GridView.builder(
        //   scrollDirection: Axis.vertical,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        //   itemCount: products.length,
        //   itemBuilder: (BuildContext context, int index){
        //     return myProducts(context, item_index: products[index]);
        //   },
        // ),


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
    padding: EdgeInsets.all(8.0),
    child: Container(
      height: 210.0,
      width: width,
      child: Row(
        children: [
          SizedBox(width: 8.0,),
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Image.network(model.thumbnailUrl, width: 160, height: 165,fit: BoxFit.fill),
          ),
          SizedBox(width: 4.0,),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 28),
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
                  SizedBox(height: 8.0),
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
                  SizedBox(height: 3.0,),
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

                  Flexible(
                    child: Container(

                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(width: 5.0,),

        ],
      ),
    ),
  );

}
