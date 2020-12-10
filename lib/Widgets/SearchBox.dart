
import 'package:e_shop_app/Store/Search.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) =>
      InkWell(
        onTap: (){
          Route route = MaterialPageRoute(builder: (c) => SearchProduct());
          Navigator.pushReplacement(context, route);
        },
        child: InkWell(
          child: Container(
            margin: EdgeInsets.all(12.0),
            width: MediaQuery.of(context).size.width,
            height: 55.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text('Search', style: TextStyle(color: Colors.grey, fontSize: 22, fontFamily: "PatrickHand")),
                )
              ],
            ),
          ),
        ),
  );


  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
