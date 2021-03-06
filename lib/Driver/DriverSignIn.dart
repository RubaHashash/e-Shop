import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Authentication/MainPage.dart';
import 'package:e_shop_app/Authentication/background_painter.dart';
import 'package:e_shop_app/Authentication/sign_in_up_bar.dart';
import 'package:e_shop_app/Driver/DriverHomePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/decoration_functions.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverSignIn extends StatefulWidget {
  @override
  _DriverSignInState createState() => _DriverSignInState();
}

class _DriverSignInState extends State<DriverSignIn>with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _driverID = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String Driver;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  loginAdmin() async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Firestore.instance.collection("drivers").getDocuments().then((snapshot) {
        snapshot.documents.forEach((result){
          if(result.data["driverId"] != _driverID.text.trim()){
            // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your ID is incorrect.")));
          }
          else if(result.data["password"] != _password.text.trim()){
            // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your password is incorrect.")));
          }
          else{
            // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome to your shop, " + result.data["name"])));
            Driver = result.documentID;
            setState((){
              _driverID.text = "";
              _password.text = "";
            });

            shopApp.sharedPreferences.setString("Driver", Driver);
            shopApp.sharedPreferences.setString("driverId", result.data["driverId"]);
            shopApp.sharedPreferences.setString("driverName", result.data["driverName"]);
            shopApp.sharedPreferences.setString("driverPassword", result.data["password"]);


            Route route = MaterialPageRoute(builder: (c) => DriverHomePage());
            Navigator.push(context, route);
          }
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                  animation: _controller.view
              ),
            ),
          ),


          Container(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Shopick',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 38),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ListView(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: _driverID,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Enter your ID';
                                }
                                return null;
                              },
                              decoration: signInDecoration(hintText: 'ID', data: Icons.person),
                              onSaved: (input) => _driverID.text = input,

                            ),
                          ),

                          Padding(padding: EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              controller: _password,
                              validator: (input) {
                                if (input.length < 6) {
                                  return 'Provide Minimum 6 Characters';
                                }
                                return null;
                              },
                              decoration: signInDecoration(hintText: 'Password', data: Icons.lock),
                              obscureText: true,
                              onSaved: (input) => _password.text = input,

                            ),
                          ),

                          SignInBar(label: 'Sign In', isLoading: false, onPressed: loginAdmin),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  Route route = MaterialPageRoute(builder: (c) => MainPage());
                                  Navigator.pushReplacement(context, route);
                                },
                                child: const Text(
                                  "I am not a driver?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: Palette.darkBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
