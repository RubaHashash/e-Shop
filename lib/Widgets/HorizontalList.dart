import 'package:e_shop_app/Store/Products.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class HorizontalList extends StatefulWidget {

  final images;
  final categories;


  const HorizontalList({Key key, this.images, this.categories}) : super(key: key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

  List<String> category_images = ["assets/CatImage/clothes_picture.jpg", "assets/CatImage/electronics_picture.png",
    "assets/CatImage/souvenir_picture.jpg", "assets/CatImage/home_picture.png",  "assets/CatImage/others_picture.jpg",];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145.0,
      child: ListView.builder(
        itemCount: widget.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Category(image_caption: widget.categories[index]['categoryName'], image_location: widget.images[index],category_images: category_images[index]);
        },
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final category_images;


  const Category({Key key, this.image_location, this.image_caption, this.category_images}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Route route = MaterialPageRoute(builder: (c) => Products(category: image_caption, category_images: category_images));
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
