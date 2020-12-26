import 'package:e_shop_app/Address/Address.dart';
import 'package:e_shop_app/Models/address.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/decoration_functions.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cPhoneNumber = TextEditingController();
  final TextEditingController _cHomeNumber = TextEditingController();
  final TextEditingController _cCity = TextEditingController();
  final TextEditingController _cState = TextEditingController();
  final TextEditingController _cDetails = TextEditingController();
  final TextEditingController _cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        key: _scaffoldKey,
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
                    "Add New Address",
                    style: TextStyle(fontSize: 35.0, color: Palette.darkBlue, fontFamily: "Signatra"),
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
            if(_formKey.currentState.validate()){

              final model = AddressModel(
                name: _cName.text.trim(),
                phoneNumber: _cPhoneNumber.text,
                homeNumber: _cHomeNumber.text,
                city: _cCity.text.trim(),
                state: _cState.text.trim(),
                addressDetails: _cDetails.text.trim(),
                pincode: _cPinCode.text
              ).toJson();

              // add to firebase
              shopApp.firestore.collection("users").document(shopApp.sharedPreferences.getString("uid"))
                  .collection("address").document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model).then((value){

                    // final snack = SnackBar(content: Text("New Address Added Successfully."));
                    // _scaffoldKey.currentState.showSnackBar(snack);
                    // FocusScope.of(context).requestFocus(FocusNode());
                    // _formKey.currentState.reset();
                Fluttertoast.showToast(msg: "New Address Added Successfully.");

              });
              Route route = MaterialPageRoute(builder: (c) => Address());
              Navigator.pushReplacement(context, route);
            }


          },
          label: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "PatrickHand", fontSize: 18.0)),
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
                          controller: _cName,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Name is Required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Name', data: Icons.person),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cName.text = input,
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _cPhoneNumber,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Phone Number is Required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Phone Number', data: Icons.phone_android),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cPhoneNumber.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _cHomeNumber,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Home Phone is required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Home Phone Number', data: Icons.phone),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cHomeNumber.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _cCity,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'City is required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'City', data: Icons.location_city),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cCity.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _cState,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'State / City is required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'State / Country', data: Icons.add_location_alt),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cState.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _cDetails,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Address details is required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Address Details', data: Icons.details),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cDetails.text = input,

                        ),

                        SizedBox(height: 5),

                        TextFormField(
                          controller: _cPinCode,

                          validator: (input) {
                            if (input.isEmpty) {
                              return 'PinCode is required';
                            }
                            return null;
                          },
                          decoration: inputDecoration(hintText: 'Pin Code', data: Icons.qr_code),
                          style: TextStyle(color: Palette.darkBlue),
                          onSaved: (input) => _cPinCode.text = input,

                        ),

                        SizedBox(height: 30.0)

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
