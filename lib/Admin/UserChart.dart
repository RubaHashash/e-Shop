import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class UserChart extends StatelessWidget {
  final userChartdisplay;

  const UserChart({Key key, this.userChartdisplay}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                  "Users Chart",
                  style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
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
                  child: Text("Shopick Users", style: TextStyle(color: Palette.darkBlue, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 40),
                Container(
                  height: 380,
                  child: userChartdisplay,
                )
              ],
            ) ,
          ),
        ),
      ) ,
    );
  }
}
