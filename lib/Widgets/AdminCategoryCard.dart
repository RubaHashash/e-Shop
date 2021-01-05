import 'package:e_shop_app/Admin/AdminAddProduct.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class AdminCategoryCard extends StatelessWidget {

  final category_index;
  final images;
  const AdminCategoryCard({Key key, this.category_index, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Material(
          child: InkWell(
            onTap: (){
              Route route = MaterialPageRoute(builder: (c) => AdminAddProduct(category_name: category_index));
              Navigator.pushReplacement(context, route);
            },
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(category_index, style: TextStyle(fontWeight: FontWeight.bold, color: Palette.darkBlue,
                      fontSize: 20, fontFamily: "Cabin"),),
                ),
              ),
              child: Image.asset(images, fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );
  }
}
