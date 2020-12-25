import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';



class AdminProducts extends StatefulWidget {
  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {

  final storeId = shopApp.sharedPreferences.getString("storeID");

  List<DocumentSnapshot> products = <DocumentSnapshot> [];

  Future<List> getProducts () {
    return Firestore.instance.collection("items").where("store", isEqualTo: storeId).getDocuments().then((snap){
      return snap.documents;
    });
  }

  _getAllProducts() async{
    List<DocumentSnapshot> data = await getProducts();
    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProducts();
  }


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
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "All Products",
                style: TextStyle(fontSize: 47.0, color: Palette.darkBlue, fontFamily: "Signatra"),
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Palette.darkBlue),

            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => AdminHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),


        body: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index){
            return myProducts(context, item_index: products[index]);
          },
        ),
      ),
    );
  }
}




Widget myProducts(BuildContext context, {item_index}){
  double width = MediaQuery.of(context).size.width;

  return InkWell(
    onTap: (){
    },
    splashColor: Palette.darkBlue,
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 100.0,
        width: width,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Image.network(item_index['thumbnailUrl'], width: 150, height: 150,fit: BoxFit.fill),
            ),
            SizedBox(width: 4.0,),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 135, bottom: 135),
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
                              child: Text(item_index['title'], style: TextStyle(color: Palette.darkBlue, fontSize: 20.0, fontWeight: FontWeight.bold)),
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
                              child: Text("Category: "+item_index['category'], style: TextStyle(color: Palette.darkBlue, fontSize: 15.0)),
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
                              child: Text("Price: "+item_index['price'].toString(), style: TextStyle(color: Palette.darkBlue, fontSize: 15.0)),
                            )
                          ],
                        ),
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