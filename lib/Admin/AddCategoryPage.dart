import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddCategoryPage extends StatefulWidget {
  final chartdisplay;

  const AddCategoryPage({Key key, this.chartdisplay}) : super(key: key);
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
                color: Colors.white
            ),
          ),
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
          title: Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 70),
            child: Row(
              children: [
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          AddDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Palette.darkBlue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Palette.darkBlue,
                      blurRadius: 10.0
                  ),
                ]
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text("All Categories", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left:40.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(".....", style: TextStyle(color: Colors.green),),
                          ),
                          SizedBox(width: 5,),
                          Text("Clothes")
                        ],
                      ),
                      SizedBox(width: 10,),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(".....", style: TextStyle(color: Colors.pink),),
                          ),
                          SizedBox(width: 5,),
                          Text("Electronics")
                        ],
                      ),
                      SizedBox(width: 10,),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(".....", style: TextStyle(color: Colors.cyan),),
                          ),
                          SizedBox(width: 5,),
                          Text("Souvenir")
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10,height: 10,),

                Padding(
                  padding: const EdgeInsets.only(left:60.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(".....", style: TextStyle(color: Colors.red),),
                          ),
                          SizedBox(width: 5,),
                          Text("Home Decoration")
                        ],
                      ),
                      SizedBox(width: 10,),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(".....", style: TextStyle(color: Colors.yellow),),
                          ),
                          SizedBox(width: 5,),
                          Text("Others")
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 350,
                  child: widget.chartdisplay,
                )
              ],
            ) ,
          ),
        ),
      ) ,
    );
  }
}

AddDialog(mContext){
  TextEditingController _CategoryName = TextEditingController();
  var uuid = Uuid();
  return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          title: Row(
            children: [
              Text("Add New Category", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 22)),
            ],
          ),
          children: [
            SimpleDialogOption(
              child: TextField(
                decoration: InputDecoration(hintText: "Category Name"),
                controller: _CategoryName,

              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SimpleDialogOption(
                  child: Text("Cancel", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
                  onPressed: (){
                    Navigator.pop(mContext);
                  },
                ),

                SimpleDialogOption(
                  child: Text("Add", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
                  onPressed: (){
                    shopApp.firestore.collection("categories").document(uuid.v4()).setData({
                      "categoryName": _CategoryName.text.trim()
                    });
                    Navigator.pop(mContext);
                  },
                ),
              ],
            ),
          ],
        );
      }
  );
}


// AddDialog(mContext){
//   TextEditingController _CategoryName = TextEditingController();
//   var uuid = Uuid();
//
//   return showDialog(
//       context: mContext,
//       builder: (con){
//         return SimpleDialog(
//           title: Row(
//             children: [
//               Text("Add New Category", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 22)),
//             ],
//           ),
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: SimpleDialogOption(
//                 child: Row(
//                   children: [
//                     TextField(
//                       style: TextStyle(color: Palette.darkBlue, fontSize: 17),
//                       controller: _CategoryName,
//                       decoration: inputDecoration(hintText: '', data: Icons.email),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SimpleDialogOption(
//                   child: Text("Cancel", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
//                   onPressed: (){
//                     Navigator.pop(mContext);
//                   },
//                 ),
//
//                 SimpleDialogOption(
//                   child: Text("Add", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
//                   onPressed: (){
//                     shopApp.firestore.collection("categories").document(uuid.v4()).setData({
//                           "categoryName": _CategoryName.text.trim()
//                         });
//                     Route route = MaterialPageRoute(builder: (c) => AdminHomePage());
//                     Navigator.pushReplacement(mContext, route);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         );
//       }
//   );
// }
