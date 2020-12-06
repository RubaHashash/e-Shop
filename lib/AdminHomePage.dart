import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isLoggedin = false;

  checkAuthentification() async{
    _auth.onAuthStateChanged.listen((user) {
      if(user == null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  getUser() async{
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser != null){
      setState(() {
        this.user = firebaseUser;
        this.isLoggedin=true;
      });
    }
  }


  signOut() async{
    _auth.signOut();
  }


  @override
  void initState(){
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: !isLoggedin? CircularProgressIndicator():

            Column(
              children: <Widget>[
                Container(
                  child: Text('Hello ${user.displayName} you are logged in as ${user.email}'),

                ),

                RaisedButton.icon(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: signOut,
                  icon: Icon(Icons.input, color: Colors.blue[900]),
                  label: Text('   Sign out', style: TextStyle(color: Colors.blue[900], fontSize: 20.0, fontWeight: FontWeight.bold)),
                  color:Colors.white ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.blue[900], width: 2)

                  ),
                )
              ],
            )
        ,
      ),

    );
  }
}
