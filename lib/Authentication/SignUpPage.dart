
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/AdminHomePage.dart';
import 'package:e_shop_app/DialogBox/errorDialog.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/sign_in_up_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/palette.dart';
import '../config/decoration_functions.dart';



class SignUpPage extends StatefulWidget {

  const SignUpPage({Key key, this.onSignInClicked}) : super(key: key);
  final VoidCallback onSignInClicked;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();

  AnimationController _controller;

  @override
  void initState(){
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  signUp() async{

      if(_formKey.currentState.validate()){
        _formKey.currentState.save();
        FirebaseUser firebaseUser;
        await _auth.createUserWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim())
            .then((auth) {
          firebaseUser = auth.user;
        }).catchError((error){
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (c){
                return ErrorAlertDialog(message: error.message.toString());
              }
          );
        });

        if(firebaseUser != null){
          saveUserInfoToFireStore(firebaseUser).then((value) {
            Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => AdminHomePage());
            Navigator.pushReplacement(context, route);
          });
        }
      }

  }


  Future saveUserInfoToFireStore(FirebaseUser fUser) async{
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _name.text.trim(),
      "userCart": ["garbageValue"],
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString("uid", fUser.uid);
    await sharedPreferences.setString("email", fUser.email);
    await sharedPreferences.setString("name", _name.text);
    await sharedPreferences.setStringList("userCart", ["garbageValue"]);



  }

  void displayDialog(String errormessage){
    showDialog(
        context: context,
        builder: (c)
        {
          return ErrorAlertDialog(message: errormessage);
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Align(alignment: Alignment.centerLeft,
                  child: Text(
                    'Create\nAccount',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 34),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [

                    Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _name,

                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter your Name';
                          }
                          return null;
                        },
                        decoration: signUpDecoration(hintText: 'Name', data: Icons.person),
                        style: TextStyle(color: Colors.white),
                        onSaved: (input) => _name.text = input,

                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _email,

                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter your E-mail';
                          }
                          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)){
                            return 'Invalid E-mail';
                          }
                          return null;
                        },
                        decoration: signUpDecoration(hintText: 'E-mail', data: Icons.email),
                        style: TextStyle(color: Colors.white),
                        onSaved: (input) => _email.text = input,

                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 1),
                      child: TextFormField(
                        controller: _password,
                        validator: (input) {
                          if (input.length < 6) {
                            return 'Provide Minimum 6 Characters';
                          }
                          return null;
                        },
                        decoration: signUpDecoration(hintText: 'Password', data: Icons.lock),
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        onSaved: (input) => _password.text = input,

                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _cPassword,
                        validator: (input) {
                          if (input.length < 6) {
                            return 'Provide Minimum 6 Characters';
                          }
                          if (input != _password.text) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                        decoration: signUpDecoration(hintText: 'Confirm Password', data: Icons.lock),
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        onSaved: (input) => _cPassword.text = input,

                      ),
                    ),

                    SignUpBar(label: 'Sign Up', isLoading: false, onPressed: signUp),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          widget.onSignInClicked?.call();
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: Palette.darkBlue,
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
    );
  }
}