import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AddCategoryPage.dart';
import 'package:e_shop_app/Admin/AdminDrivers.dart';
import 'package:e_shop_app/Admin/AdminStores.dart';
import 'package:e_shop_app/Authentication/MainPage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  var chartdisplay;
  List<int> countList = [];
  List listColors = [charts.MaterialPalette.green.shadeDefault,charts.MaterialPalette.pink.shadeDefault,
    charts.MaterialPalette.cyan.shadeDefault, charts.MaterialPalette.red.shadeDefault,charts.MaterialPalette.yellow.shadeDefault,
    charts.MaterialPalette.deepOrange.shadeDefault, charts.MaterialPalette.purple.shadeDefault, charts.MaterialPalette.indigo.shadeDefault, ];

  List<DocumentSnapshot> driverCount = <DocumentSnapshot> [];
  List<DocumentSnapshot> storesCount = <DocumentSnapshot> [];
  List<DocumentSnapshot> categories = <DocumentSnapshot> [];
  List<DocumentSnapshot> itemCount = <DocumentSnapshot> [];


  Future<List> getDriverCount(){
    return Firestore.instance.collection("drivers").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getStoresrCount(){
    return Firestore.instance.collection("admins").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getCategories () {
    return shopApp.firestore.collection("categories").getDocuments().then((snap){
      return snap.documents;
    });
  }

  Future<List> getClothesCount(){
    return Firestore.instance.collection("items").where("category", isEqualTo: "Clothes").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getElectronicsCount(){
    return Firestore.instance.collection("items").where("category", isEqualTo: "Electronics").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getHomeCount(){
    return Firestore.instance.collection("items").where("category", isEqualTo: "Home Decoration").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getSouvenirCount(){
    return Firestore.instance.collection("items").where("category", isEqualTo: "Souvenir").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getOthersCount(){
    return Firestore.instance.collection("items").where("category", isEqualTo: "Others").getDocuments().then((value){
      return value.documents;
    });
  }


  _getCounters() async{
    List<DocumentSnapshot> Driverdata = await getDriverCount();
    List<DocumentSnapshot> Storedata = await getStoresrCount();

    setState(() {
      driverCount = Driverdata;
      storesCount = Storedata;
    });
  }

  _getCategoriesName() async{
    List<DocumentSnapshot> data = await getCategories();
    List<DocumentSnapshot> dataCountClothes = await getClothesCount();
    List<DocumentSnapshot> dataCountElectronics = await getElectronicsCount();
    List<DocumentSnapshot> dataCountHome = await getHomeCount();
    List<DocumentSnapshot> dataCountSouvenir = await getSouvenirCount();
    List<DocumentSnapshot> dataCountOthers = await getOthersCount();

    setState(() {
      categories = data;
      itemCount = dataCountClothes;
      countList.add(itemCount.length);
      itemCount = dataCountElectronics;
      countList.add(itemCount.length);
      itemCount = dataCountSouvenir;
      countList.add(itemCount.length);
      itemCount = dataCountHome;
      countList.add(itemCount.length);
      itemCount = dataCountOthers;
      countList.add(itemCount.length);
    });

      //charts
      List<addChart> Chartdata = [];
      for(var i = 0; i<countList.length; i++){
        Chartdata.add(
          addChart(categories[i]['categoryName'], countList[i], listColors[i]));
      }

      var series = [charts.Series(
        domainFn: (addChart addChart, _) => addChart.label,
        measureFn: (addChart addChart, _) => addChart.value,
        colorFn: (addChart addChart, _) => addChart.color,
        labelAccessorFn: (addChart row, _) => "${row.label}",
        id: 'addchart',
        data: Chartdata,
      ),];

        chartdisplay = charts.PieChart(
          series,
          animationDuration: Duration(microseconds: 1500),
          animate: true,
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCounters();
    _getCategoriesName();

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
              padding: const EdgeInsets.only(top: 10.0, left: 60),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag, size: 37, color: Palette.darkBlue,),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Shopick",
                      style: TextStyle(fontSize: 47.0, color: Palette.darkBlue, fontFamily: "Signatra"),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 14.0, right: 10.0),
                    child: Icon(Icons.exit_to_app, color: Palette.darkBlue,),
                  ),
                  onPressed: (){
                    shopApp.auth.signOut().then((value){
                      Route route = MaterialPageRoute(builder: (c) => MainPage());
                      Navigator.pushReplacement(context, route);
                    });
                  }
              ),
            ],
          ),
        ),

        body: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 5),
                    InkWell(
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (c) => AdminStores());
                        Navigator.push(context, route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
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
                          width: 170,
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.store, color: Palette.darkBlue, size: 45,)
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Stores", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 20),
                                  Text(storesCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.w500),)

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (c) => AdminDriver());
                        Navigator.push(context, route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
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
                          width: 170,
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.drive_eta, color: Palette.darkBlue, size: 45,)
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Drivers", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 20),
                                  Text(driverCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.w500),)

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 5),
                    InkWell(
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (c) => AddCategoryPage(chartdisplay: chartdisplay));
                        Navigator.push(context, route);
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: 170,
                          height: 210,
                          padding: EdgeInsets.all(10.0),
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
                              Text("Categories", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                              Container(
                                height: 150,
                                child: chartdisplay,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class addChart{
  final String label;
  final int value;
  final charts.Color color;

  addChart(this.label, this.value, this.color);
}