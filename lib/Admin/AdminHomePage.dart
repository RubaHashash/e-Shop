import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminShiftOrders.dart';
import 'package:e_shop_app/Authentication/LoginPage.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  File file;
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _shortInfo = TextEditingController();
  String productID = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayHomeScreen() : displayUploadFormScreen();
  }


  displayHomeScreen(){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
                color: Colors.white
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: IconButton(
              icon: Icon(Icons.border_color, color: Palette.darkBlue),
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
                Navigator.pushReplacement(context, route);
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: FlatButton(
                  onPressed: (){
                    Route route = MaterialPageRoute(builder: (c) => LoginPage());
                    Navigator.pushReplacement(context, route);
                  },
                  child: Text('Logout', style: TextStyle(color: Palette.darkBlue, fontSize: 16.0, fontWeight: FontWeight.bold))
              ),
            )
          ],
        ),
      ) ,

      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody(){
    return Container(
      decoration:  BoxDecoration(
          color: Colors.white
      ),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two, color: Palette.darkBlue, size: 200.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0)),
                  child: Text("Add New Items", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                  color: Palette.darkBlue,
                  onPressed: ()=> takeImage(context),
                ),
              ),
          ],
        ),
      ),
    );
  }


  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (con){
        return SimpleDialog(
          title: Row(
            children: [
              Text("Item Image", style: TextStyle(color: Palette.darkBlue, fontWeight: FontWeight.bold, fontSize: 25)),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.add_a_photo),
                    SizedBox(width: 12),
                    Text("Capture with Camera", style: TextStyle(color: Palette.darkBlue, fontSize: 22, fontFamily: "PatrickHand")),
                  ],
                ),
                onPressed: capturePhotoWithCamera,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 12),
                    Text("Select from Gallery", style: TextStyle(color: Palette.darkBlue, fontSize: 22, fontFamily: "PatrickHand")),
                  ],
                ),
                onPressed: pickPhotoFromGallery,
              ),
            ),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Palette.darkBlue, fontSize: 16), textAlign: TextAlign.right),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }


  capturePhotoWithCamera() async{

    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });

  }

  pickPhotoFromGallery() async{

    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });

  }




  displayUploadFormScreen(){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
                color: Colors.white
            ),
          ),

          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Palette.darkBlue),
              onPressed: clearFormInfo,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text("New Product", style: TextStyle(color: Palette.darkBlue, fontSize: 55.0, fontWeight: FontWeight.bold, fontFamily: "Signatra"),),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 8.0),

              child: IconButton(
                icon: Icon(Icons.add, color: Palette.darkBlue, size: 25),
                onPressed: uploading ? null :  () => uploadImageAndSaveItemInfo(),
              ),
            )
          ],
        ),
      ),

      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12)),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Palette.darkBlue,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                controller: _shortInfo,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Palette.darkBlue),


          ListTile(
            leading: Icon(Icons.perm_device_information, color: Palette.darkBlue,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                controller: _title,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Palette.darkBlue),


          ListTile(
            leading: Icon(Icons.perm_device_information, color: Palette.darkBlue,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                controller: _description,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Palette.darkBlue),


          ListTile(
            leading: Icon(Icons.perm_device_information, color: Palette.darkBlue,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Palette.darkBlue, fontSize: 17),
                controller: _price,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Palette.darkBlue, fontSize: 17),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Palette.darkBlue),
        ],
      ),
    );
  }


  clearFormInfo(){

    setState(() {
      file = null;
      _description.clear();
      _title.clear();
      _price.clear();
      _shortInfo.clear();
    });

  }

  uploadImageAndSaveItemInfo() async{

    setState(() {
      uploading = true;
    });

    String imageDowloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDowloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async{

    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productID.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }

  saveItemInfo(String downloadUrl){

    final itemRef = Firestore.instance.collection("items");
    itemRef.document(productID).setData({
      "shortInfo": _shortInfo.text.trim(),
      "longDescription": _description.text.trim(),
      "price": int.parse(_price.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _title.text.trim(),

    });

    setState(() {
      file = null;
      uploading = false;
      productID = DateTime.now().millisecondsSinceEpoch.toString();
      _description.clear();
      _title.clear();
      _shortInfo.clear();
      _price.clear();
    });
  }
}
