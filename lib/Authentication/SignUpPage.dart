import 'package:e_shop_app/AdminHomePage.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/sign_in_up_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String _email,_password, _name;
  AnimationController _controller;

  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user) async{
      if(user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
      }
    });
  }

  @override
  void initState(){
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    this.checkAuthentication();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  signUp() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      try{
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)) as FirebaseUser;
        if(user != null){
          UserUpdateInfo updateuser = UserUpdateInfo();
          updateuser.displayName = _name;
          user.updateProfile(updateuser);
        }
      }catch(e){
        showError(e.errormessage);
      }
    }
  }
  showError(String errormessage){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('OK'))
            ],
          );
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

                    Padding(padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter your Name';
                          }
                          return null;
                        },
                        decoration: signInNameDecoration(),
                        onSaved: (input) => _name = input,

                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Enter your E-mail';
                          }
                          return null;
                        },
                        decoration: signInEmailDecoration(),
                        onSaved: (input) => _email = input,

                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (input) {
                          if (input.length < 6) {
                            return 'Provide Minimum 6 Characters';
                          }
                          return null;
                        },
                        decoration: signInPasswordDecoration(),
                        obscureText: true,
                        onSaved: (input) => _password = input,

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