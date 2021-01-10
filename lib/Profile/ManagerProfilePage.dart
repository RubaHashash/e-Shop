import 'package:e_shop_app/StoreManager/ManagerHomePage.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:flutter/material.dart';

class ManagerProfilePage extends StatefulWidget {

  @override
  _ManagerProfilePageState createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _editAdminID = TextEditingController();
  final TextEditingController _editAdminName = TextEditingController();
  final TextEditingController _editAdminPassword = TextEditingController();


  bool edit = false;

  UpdateUserProfile(){
    if (_formKey.currentState.validate()) {

      shopApp.firestore.collection("admins").document(shopApp.sharedPreferences.getString("storeID"))
          .updateData({
        'id': _editAdminID.text,
        'name': _editAdminName.text,
        'password': _editAdminName.text,

      });

      shopApp.sharedPreferences.setString("adminId", _editAdminID.text);
      shopApp.sharedPreferences.setString("adminName", _editAdminName.text);
      shopApp.sharedPreferences.setString("adminPassword", _editAdminName.text);

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
                  Route route = MaterialPageRoute(builder: (c) => ManagerHomePage());
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
                              child: Text('${shopApp.sharedPreferences.getString("adminName")[0].toUpperCase()}',
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
                                      controller: _editAdminID,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Enter your ID';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: shopApp.sharedPreferences.getString("adminId"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                      ),
                                      onSaved: (input) => _editAdminID.text = input
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
                                      controller: _editAdminName,
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Enter your Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: shopApp.sharedPreferences.getString("adminName"),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                      ),
                                      onSaved: (input) => _editAdminName.text = input
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
                                      controller: _editAdminPassword,
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
                                      onSaved: (input) => _editAdminPassword.text = input

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
                                        Text(shopApp.sharedPreferences.getString("adminId"),
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
                                        Text(shopApp.sharedPreferences.getString("adminName"),
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

                  Container(
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

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
