import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AddDriverPage.dart';
import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class AdminDriver extends StatefulWidget {
  @override
  _AdminDriverState createState() => _AdminDriverState();
}

class _AdminDriverState extends State<AdminDriver> {

  List<DocumentSnapshot> drivers = <DocumentSnapshot> [];

  Future<List> getDrivers () {
    return shopApp.firestore.collection("drivers").getDocuments().then((snap){
      return snap.documents;
    });
  }

  _getDriversName() async{
    List<DocumentSnapshot> data = await getDrivers();
    setState(() {
      drivers = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDriversName();
  }


  @override
  Widget build(BuildContext context) {
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
                    "Drivers",
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

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => AddDriverPage());
            Navigator.pushReplacement(context, route);
          },
          child: Icon(Icons.add),
          backgroundColor: Palette.darkBlue,
        ),

        body: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: drivers.length,
          itemBuilder: (BuildContext context, int index){
            return Drivers(driverName: drivers[index]['driverName'], ID: drivers[index].documentID);
          },
        ),
      ),
    );
  }
}


class Drivers extends StatelessWidget {
  final String driverName;
  final String ID;

  const Drivers({Key key, this.driverName, this.ID}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
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
          SizedBox(height: 10),
          Container(
            width: 120, height: 70,
            child: CircleAvatar(
              maxRadius: 15,
              backgroundColor: Palette.darkBlue,
              child: Center(
                child: Text(driverName[0].toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w500, fontFamily: "Signatra")),
              ),
            ),
          ),
          SizedBox(height: 14),
          Text(driverName, style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontWeight: FontWeight.bold),),

          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  ConfimDeleteDialog(context,driverName, ID);
                }
            ),
          ),

        ],
      ),
    );
  }
}


ConfimDeleteDialog(mContext, String driverName, String ID){
  return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SimpleDialogOption(
                child: Text("Are you sure you want to remove the driver "+ driverName,
                    style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontFamily: "Cabin")),
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
                  child: Text("Delete", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
                  onPressed: (){
                    shopApp.firestore.collection("drivers").document(ID).delete();
                    Route route = MaterialPageRoute(builder: (c) => AdminHomePage());
                    Navigator.pushReplacement(mContext, route);
                  },
                ),
              ],
            ),
          ],
        );
      }
  );
}
