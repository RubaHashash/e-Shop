import 'package:e_shop_app/Driver/DriverHomePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class DriverProfilePage extends StatefulWidget {

  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _editDriveID = TextEditingController();
  final TextEditingController _editDriveName = TextEditingController();
  final TextEditingController _editDrivePassword = TextEditingController();


  bool edit = false;

  UpdateUserProfile(){
    if (_formKey.currentState.validate()) {

      shopApp.firestore.collection("drivers").document(shopApp.sharedPreferences.getString("Driver"))
          .updateData({
        'driverId': _editDriveID.text,
        'driverName': _editDriveName.text,
        'password': _editDrivePassword.text,

      });

      shopApp.sharedPreferences.setString("driverId", _editDriveID.text);
      shopApp.sharedPreferences.setString("adminName", _editDriveName.text);
      shopApp.sharedPreferences.setString("adminPassword", _editDrivePassword.text);

      setState(() {
        edit = false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                    "My Profile",
                    style: TextStyle(fontSize: 22.0, color: Palette.darkBlue, fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            leading: edit ==false?Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 16),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Palette.darkBlue),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => DriverHomePage());
                  Navigator.pushReplacement(context, route);
                },
              ),
            ): Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: IconButton(
                  icon: Icon(
                      Icons.close,
                      color: Palette.darkBlue, size: 30),
                  onPressed: (){
                    setState(() {
                      edit = false;
                    });
                  }
              ),
            ),

            actions: [
              edit == true? Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: IconButton(
                    icon: Icon(Icons.check, color: Palette.darkBlue, size: 30),
                    onPressed: (){
                      UpdateUserProfile();

                    }
                ),
              ) : Container()
            ],
          ),

        ),

        body: ListView(
          children: [
            Container(
              height: height -80,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              maxRadius: 65,
                              backgroundColor: Palette.darkBlue,
                              child: Text('${shopApp.sharedPreferences.getString("driverName")[0].toUpperCase()}',
                                  style: TextStyle(color: Colors.white, fontSize: 80.0, fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                      ),
                      edit == true?Padding(
                        padding: const EdgeInsets.only(left: 225, top: 90),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Palette.darkBlue,
                            ),
                          ),
                        ),
                      ): Container(),
                    ],
                  ),

                  Container(
                    height: 280,
                    width: width,
                    child: Column(
                      children: [
                        Container(
                          height: 280,
                          child: edit == true ? Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  width: width,
                                  child: TextFormField(
                                      controller: _editDriveID,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Enter your ID';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: shopApp.sharedPreferences.getString("driverId"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                      ),
                                      onSaved: (input) => _editDriveID.text = input
                                  ),
                                ),

                                SizedBox(height: 17),

                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  width: width,
                                  child: TextFormField(
                                      controller: _editDriveName,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Enter your Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: shopApp.sharedPreferences.getString("driverName"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                      ),
                                      onSaved: (input) => _editDriveName.text = input
                                  ),
                                ),

                                SizedBox(height: 17),

                                Container(
                                  height: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  width: width,
                                  child: TextFormField(
                                      controller: _editDrivePassword,
                                      validator: (input) {
                                        if (input.length < 6) {
                                          return 'Provide Minimum 6 Characters';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "********",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                      ),
                                      obscureText: true,
                                      onSaved: (input) => _editDrivePassword.text = input

                                  ),
                                ),
                              ],
                            ),
                          ):  Container(
                            height: 100,
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("ID",
                                            style: TextStyle(fontSize: 17, color: Palette.darkBlue)
                                        ),
                                        Text(shopApp.sharedPreferences.getString("driverId"),
                                            style: TextStyle(fontSize: 17, color: Palette.darkBlue, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 12),

                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Name",
                                            style: TextStyle(fontSize: 17, color: Palette.darkBlue)
                                        ),
                                        Text(shopApp.sharedPreferences.getString("driverName"),
                                            style: TextStyle(fontSize: 17, color: Palette.darkBlue, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 12),

                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Password",
                                            style: TextStyle(fontSize: 17, color: Palette.darkBlue)
                                        ),
                                        Text("*********",
                                            style: TextStyle(fontSize: 17, color: Palette.darkBlue, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),

                  Card(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.darkBlue
                      ),
                      width: 200,
                      child: edit == false? FlatButton(
                          color: Palette.darkBlue,
                          onPressed: (){
                            setState(() {
                              edit = true;
                            });
                          },
                          child: Text("Edit Profile", style: TextStyle(fontSize: 18, color: Colors.white),)
                      ) : Container(),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
