import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminStores.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';


class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  List<DocumentSnapshot> RequestedOrderCount = <DocumentSnapshot> [];
  List<DocumentSnapshot> InProgressOrderCount = <DocumentSnapshot> [];
  List<DocumentSnapshot> DeliveredOrderCount = <DocumentSnapshot> [];
  List<DocumentSnapshot> ReceivedOrderCount = <DocumentSnapshot> [];

  Future<List> getRequestedOrderCount(){
    return Firestore.instance.collection("orders").where("isSuccess", isEqualTo: "Requested").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getInProgressOrderCount(){
    return Firestore.instance.collection("orders").where("isSuccess", isEqualTo: "In Progress").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getDeliveredOrderCount(){
    return Firestore.instance.collection("orders").where("isSuccess", isEqualTo: "Delivered").getDocuments().then((value){
      return value.documents;
    });
  }

  Future<List> getReceivedOrderCount(){
    return Firestore.instance.collection("orders").where("isSuccess", isEqualTo: "Done").getDocuments().then((value){
      return value.documents;
    });
  }

  _getCounters() async{
    List<DocumentSnapshot> Requesteddata = await getRequestedOrderCount();
    List<DocumentSnapshot> InProgressdata = await getInProgressOrderCount();
    List<DocumentSnapshot> Delivereddata = await getDeliveredOrderCount();
    List<DocumentSnapshot> Receiveddata = await getReceivedOrderCount();

    setState(() {
      RequestedOrderCount = Requesteddata;
      InProgressOrderCount = InProgressdata;
      DeliveredOrderCount = Delivereddata;
      ReceivedOrderCount = Receiveddata;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCounters();
  }
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
                Route route = MaterialPageRoute(builder: (c) => AdminStores());
                Navigator.pushReplacement(context, route);
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 90),
            child: Row(
              children: [
                Text(
                  "Orders",
                  style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.centerLeft,
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
                width: 300,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_dissatisfied, color: Palette.darkBlue, size: 30),
                        SizedBox(width: 15),
                        Text("Requested Orders", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(RequestedOrderCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),)

                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.centerRight,
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
                width: 300,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_neutral, color: Palette.darkBlue, size: 30),
                        SizedBox(width: 15),
                        Text("In Progress Orders", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(InProgressOrderCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),)

                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.centerLeft,
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
                width: 300,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_satisfied_alt, color: Palette.darkBlue, size: 30),
                        SizedBox(width: 15),
                        Text("Delivered Orders", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DeliveredOrderCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),)

                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.centerRight,
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
                width: 300,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_very_satisfied, color: Palette.darkBlue, size: 30),
                        SizedBox(width: 15),
                        Text("Received Orders", style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ReceivedOrderCount.length.toString(), style: TextStyle(fontSize: 20, color: Palette.darkBlue, fontWeight: FontWeight.bold),)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
