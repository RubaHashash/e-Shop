import 'package:e_shop_app/StoreManager/ManagerAddProduct.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class ManagerCategoryCard extends StatelessWidget {

  final category_index;
  final images;
  final count;
  const ManagerCategoryCard({Key key, this.category_index, this.images, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: Container(
        height: 250,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 4.0,
          child: Material(
            child: InkWell(
              onTap: (){
                Route route = MaterialPageRoute(builder: (c) => ManagerAddProduct(category_name: category_index));
                Navigator.pushReplacement(context, route);
              },
              child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: ListTile(
                    leading: Text(category_index, style: TextStyle(fontWeight: FontWeight.bold, color: Palette.darkBlue,
                        fontSize: 20, fontFamily: "Cabin"),),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text("items: " + count.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Palette.darkBlue,
                          fontSize: 16, fontFamily: "Cabin"),),
                    ),

                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(images, fit: BoxFit.fill)
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
