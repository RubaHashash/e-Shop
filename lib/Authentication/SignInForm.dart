import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/config/decoration_functions.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/sign_in_up_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AdminHomePage.dart';
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
  String _email, _password;


  checkAuthentification() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.push(
            this.context,
            MaterialPageRoute(builder: (context) => AdminHomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }


  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password)) as FirebaseUser;
      } catch (e) {
        showError(e.errormessage);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(onPressed: () {
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
                flex: 3,
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text(
                      'Quick Shop',
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
