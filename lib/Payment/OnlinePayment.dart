import 'package:e_shop_app/Address/Address.dart';
import 'package:e_shop_app/config/decoration_functions.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class OnlinePayment extends StatefulWidget {

  final totalAmount;
  final addressID;

  const OnlinePayment({Key key, this.totalAmount, this.addressID}) : super(key: key);

  @override
  _OnlinePaymentState createState() => _OnlinePaymentState();
}

class _OnlinePaymentState extends State<OnlinePayment> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _NameOnCard = TextEditingController();
  final TextEditingController _CardNumber = TextEditingController();
  final TextEditingController _ExpDate = TextEditingController();
  final TextEditingController _CVV = TextEditingController();
  // final DateTime _ExpiryDate;
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
                    "Pay Invoice",
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
                  Route route = MaterialPageRoute(builder: (c) => Address());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(_formKey.currentState.validate()) {
              addOrderDetails(context, widget.addressID, widget.totalAmount);
            }
          },
          label: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Cabin", fontSize: 16.0)),
          backgroundColor: Palette.darkBlue,
          icon: Icon(Icons.check, size: 18),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _CardNumber,
                          keyboardType: TextInputType.number,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Card Number is Required';
                            }
                            if (input.length < 16) {
                              return 'Number should be of 16 bits';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Card Number', data: Icons.phone_android),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _CardNumber.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _NameOnCard,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Name on Card is Required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Name on Card', data: Icons.person),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _NameOnCard.text = input,
                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _ExpDate,
                          keyboardType: TextInputType.datetime,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Expiry Date is Required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Expiry Date', data: Icons.calendar_today),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _ExpDate.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _CVV,
                          keyboardType: TextInputType.number,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'CVV is Required';
                            }
                            if (input.length < 3) {
                              return 'Number should be of 3 bits';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'CVV', data: Icons.code),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _CVV.text = input,

                        ),


                        SizedBox(height: 30),


                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
