import 'package:e_shop_app/Customer/StoresProducts.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class StoresHorizontalList extends StatefulWidget {

  final stores;


  const StoresHorizontalList({Key key, this.stores}) : super(key: key);

  @override
  _StoresHorizontalListState createState() => _StoresHorizontalListState();
}

class _StoresHorizontalListState extends State<StoresHorizontalList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145.0,
      child: ListView.builder(
        itemCount: widget.stores.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Store(storeName: widget.stores[index]['name']);
        },
      ),
    );
  }
}

class Store extends StatelessWidget {
  final String storeName;

  const Store({Key key, this.storeName}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route = MaterialPageRoute(builder: (c) => StoresProducts(storeName: storeName));
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                  color: Palette.darkBlue,
                  blurRadius: 3.0
              ),
            ]
        ),
        child: Column(
          children: [
            Container(
              width: 120, height: 70,
              child: CircleAvatar(
                maxRadius: 15,
                backgroundColor: Palette.darkBlue,
                child: Center(
                  child: Text(storeName[0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w500, fontFamily: "Signatra")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(storeName, style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
    );
  }
}
