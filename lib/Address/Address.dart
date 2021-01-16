import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Address/AddAddress.dart';
import 'package:e_shop_app/Address/MapAddress.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Counters/changeAddress.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/Payment/OnlinePayment.dart';
import 'package:e_shop_app/Customer/Cart.dart';
import 'package:e_shop_app/Customer/StoreHome.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

bool onCash = true;
class Address extends StatefulWidget {

  final double totalAmount;
  const Address({Key key,this.totalAmount}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {

  bool onCash = true;

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
              padding: const EdgeInsets.only(top: 17.0, left: 50),
              child: Row(
                children: [
                  Text(
                    "Shipping Address",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,

            leading: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Palette.darkBlue,
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<AddressChanger>(builder: (context, address, c){
              return Flexible(
                // get the sequence of addresses in firebase
                child: StreamBuilder<QuerySnapshot>(
                  stream: shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                    .collection("address").snapshots(),
                  builder: (context, snapshots){
                    return !snapshots.hasData
                        ? Center(child: circularProgress())
                        : snapshots.data.documents.length == 0
                        ? noAddressCard()
                        : ListView.builder(
                          itemCount: snapshots.data.documents.length,
                          itemBuilder: (context, index){
                            return AddressCard(
                              currentIndex: address.count,
                              value: index,
                              addressID: snapshots.data.documents[index].documentID,
                              totalAmount: widget.totalAmount,
                              model: AddressModel.fromJson(snapshots.data.documents[index].data)
                            );
                          },
                        );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add New Address",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Cabin", fontSize: 15.0)),
          backgroundColor: Palette.darkBlue,
          icon: Icon(Icons.add_location, size: 18),
          onPressed: (){
            addressDialog(context);
          },
        ),
      ),
    );
  }

  noAddressCard(){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        color: Colors.white.withOpacity(0.5),
        child: Container(
          height: 100.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_location, color: Palette.darkBlue),
              Text("No shipment address has been saved.", style: TextStyle(color: Palette.darkBlue)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Please add your shipment address so that we can deliver your products.", textAlign: TextAlign.center,
                     style: TextStyle(color: Palette.darkBlue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AddressCard extends StatefulWidget {

  final AddressModel model;
  final String addressID;
  final double totalAmount;
  final int currentIndex, value;

  AddressCard({Key key, this.model, this.addressID, this.totalAmount, this.value, this.currentIndex}) : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    groupValue: widget.currentIndex,
                    value: widget.value,
                    activeColor: Palette.darkBlue,
                    onChanged: (val){
                      Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: width * 0.8,
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                Text("Name", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                Text(widget.model.name),
                              ]
                            ),

                            TableRow(
                                children: [
                                  Text("Phone Number", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                  Text(widget.model.phoneNumber),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("Home Phone Number", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                  Text(widget.model.homeNumber),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("City", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                  Text(widget.model.city),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("State", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                  Text(widget.model.state),
                                ]
                            ),

                            TableRow(
                                children: [
                                  Text("Address Details", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold)),
                                  Text(widget.model.addressDetails),
                                ]
                            ),

                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),

              // provide the select button to the address selected
              widget.value == Provider.of<AddressChanger>(context).count
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: (){
                          paymentDialog(context, widget.addressID, widget.totalAmount);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Palette.darkBlue,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 3.0
                                ),
                              ]
                          ),
                          width: 65.0,
                          height: 30.0,
                          child: Center(
                            child: Text("Select", style: TextStyle(color: Colors.white, fontFamily: "Cabin", fontSize: 15.0)),
                          ),
                        ),
                      ),
                    ),
                  )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
addressDialog(mContext){
  return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          title: Row(
            children: [
              Text("Add New Address", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 22)),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.add_location),
                    SizedBox(width: 12),
                    Text("Manual Address", style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontFamily: "Cabin")),
                  ],
                ),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => AddAddress());
                  Navigator.pushReplacement(mContext, route);
                },
              ),
            ),

            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 12),
                  Text("Use Google Maps", style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontFamily: "Cabin")),
                ],
              ),
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => MapAddress());
                Navigator.pushReplacement(mContext, route);
              },
            ),

            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
              onPressed: (){
                Navigator.pop(mContext);
              },
            ),
          ],
        );
      }
  );
}

paymentDialog(mContext, String addressID, double totalAmount){
  return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          title: Row(
            children: [
              Text("Payment", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 25)),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.delivery_dining),
                    SizedBox(width: 12),
                    Text("Cash on Delivery", style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontFamily: "Cabin")),
                  ],
                ),
                onPressed: (){
                  onCash = true;
                  addOrderDetails(mContext, addressID,totalAmount);
                },
              ),
            ),
            SimpleDialogOption(
              child: Row(
                children: [
                  Icon(Icons.delivery_dining),
                  SizedBox(width: 12),
                  Text("Pay Online", style: TextStyle(color: Palette.darkBlue, fontSize: 18, fontFamily: "Cabin")),
                ],
              ),
              onPressed: (){
                onCash = false;
                Route route = MaterialPageRoute(builder: (c) => OnlinePayment(addressID: addressID, totalAmount: totalAmount));
                Navigator.pushReplacement(mContext, route);
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
              onPressed: (){
                Navigator.pop(mContext);
              },
            ),
          ],
        );
      }
  );
}




/////////////// PAYMENT FUNCTIONS///////////////

Future writeOrderDetailsForUser(Map<String, dynamic> data) async{
  // add an order collection to each user to store the orders he had made
  await shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
      .collection("orders").document(shopApp.sharedPreferences.getString("uid") + data['orderTime'])
      .setData(data);
}

Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async{
  // add an order collection to store all the orders from all users to the StoreAdmin
  await shopApp.firestore.collection("orders").document(shopApp.sharedPreferences
      .getString("uid") + data['orderTime']).setData(data);
}

addOrderDetails(context, String addressID, double totalAmount ) {
  if (onCash == true) {
    writeOrderDetailsForUser({
      'addressID': addressID,
      'totalAmount': totalAmount,
      'orderBy': shopApp.sharedPreferences.getString("uid"),
      'orderByName':shopApp.sharedPreferences.getString("name"),
      'productID': shopApp.sharedPreferences.getStringList("userCart"),
      'paymentDetails': "Cash on Delivery",
      'orderTime': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'orderMonth': DateTime.now().month,
      'isSuccess': "Transferred",
      'AssignedDriver': ""
    });

    writeOrderDetailsForAdmin({
      'addressID': addressID,
      'totalAmount': totalAmount,
      'orderBy': shopApp.sharedPreferences.getString("uid"),
      'orderByName':shopApp.sharedPreferences.getString("name"),
      'productID': shopApp.sharedPreferences.getStringList("userCart"),
      'paymentDetails': "Cash on Delivery",
      'orderTime': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'orderMonth': DateTime.now().month,
      'isSuccess': "Transferred",
      'AssignedDriver': "",
      'isReceived': false
    }).whenComplete(() =>
    {
      emptyCart(context)
    });
  }
  else{
    writeOrderDetailsForUser({
      'addressID': addressID,
      'totalAmount': totalAmount,
      'orderBy': shopApp.sharedPreferences.getString("uid"),
      'orderByName':shopApp.sharedPreferences.getString("name"),
      'productID': shopApp.sharedPreferences.getStringList("userCart"),
      'paymentDetails': "Online Payment",
      'orderTime': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'orderMonth': DateTime.now().month,
      'isSuccess': "Transferred",
      'AssignedDriver': ""
    });

    writeOrderDetailsForAdmin({
      'addressID': addressID,
      'totalAmount': totalAmount,
      'orderBy': shopApp.sharedPreferences.getString("uid"),
      'orderByName':shopApp.sharedPreferences.getString("name"),
      'productID': shopApp.sharedPreferences.getStringList("userCart"),
      'paymentDetails': "Online Payment",
      'orderTime': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'orderMonth': DateTime.now().month,
      'isSuccess': "Transferred",
      'AssignedDriver': "",
    'isReceived': false

    }).whenComplete(() =>
    {
      emptyCart(context)
    });
  }
}


emptyCart(context){
  shopApp.sharedPreferences.setStringList("userCart", ["garbageValue"]);
  List tempCartList = shopApp.sharedPreferences.getStringList("userCart");

  //update the list in the database
  Firestore.instance.collection("users").document(shopApp.sharedPreferences.getString("uid")).updateData({
    "userCart": tempCartList,
  }).then((value) {
    shopApp.sharedPreferences.setStringList("userCart", tempCartList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });

  Fluttertoast.showToast(msg: "Congratulations, your order has been placed successfully.");

  Route route = MaterialPageRoute(builder: (c) => StoreHome());
  Navigator.push(context, route);


}