import 'package:e_shop_app/Store/ViewProducts.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class HorizontalList extends StatelessWidget {

  final images;
  final categories;

  const HorizontalList({Key key, this.images, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145.0,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Category(image_caption: categories[index]['categoryName'], image_location: images[index],);
        },
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  const Category({Key key, this.image_location, this.image_caption}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route = MaterialPageRoute(builder: (c) => ViewProducts(category: image_caption));
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13)
        ),
        child: Column(
          children: [
            Image.asset(image_location, width: 120, height: 70,),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(image_caption, style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
    );
  }
}
