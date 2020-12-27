import 'package:e_shop_app/Admin/AdminSignIn.dart';
import 'package:e_shop_app/Driver/DriverSignIn.dart';
import '../Store/StoreHome.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/config/decoration_functions.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/sign_in_up_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/DialogBox/errorDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_shop_app/config/config.dart';
import '../config/palette.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({Key key, this.onRegisterClicked}) : super(key: key);
  final VoidCallback onRegisterClicked;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>  {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      FirebaseUser firebaseUser;
      await _auth.signInWithEmailAndPassword(
          email: _email.text.trim(), 
          password: _password.text.trim()
      ).then((authUser){
        firebaseUser = authUser.user;
      }).catchError((error){
        showDialog(
            context: context,
            builder: (c){
              return ErrorAlertDialog(message: error.message.toString());
            }
        );
      });

      if(firebaseUser != null){
        readData(firebaseUser).then((s){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.push(context, route);
        });
      }
    }

  }

  Future readData(FirebaseUser fUser) async{

    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot) async {
      await shopApp.sharedPreferences.setString("uid", dataSnapshot.data["uid"]);
      await shopApp.sharedPreferences.setString("email", dataSnapshot.data["email"]);
      await shopApp.sharedPreferences.setString("name", dataSnapshot.data["name"]);
      List<String> cartList = dataSnapshot.data["userCart"].cast<String>();
      await shopApp.sharedPreferences.setStringList("userCart", cartList);
    });
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
                          decoration: signInDecoration(hintText: 'E-mail', data: Icons.email),
                          onSaved: (input) => _email.text = input,

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

                      SignInBar(label: 'Sign In', isLoading: false, onPressed: login),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            widget.onRegisterClicked?.call();
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Palette.darkBlue,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  Route route = MaterialPageRoute(builder: (c) => AdminSignIn());
                                  Navigator.pushReplacement(context, route);
                                },
                                child: const Text(
                                  'I have a store?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    color: Palette.darkBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("|", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  Route route = MaterialPageRoute(builder: (c) => DriverSignIn());
                                  Navigator.pushReplacement(context, route);
                                },
                                child: const Text(
                                  'I am a driver?',
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
                      )


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
