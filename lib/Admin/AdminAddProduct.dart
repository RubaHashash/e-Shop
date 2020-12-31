import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_app/Admin/AdminHomePage.dart';
import 'package:e_shop_app/Widgets/loadingWidget.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:e_shop_app/config/palette.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddProduct extends StatefulWidget {

  final category_name;

  const AdminAddProduct({Key key, this.category_name}) : super(key: key);


  @override
  _AdminAddProductState createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {

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
            padding: const EdgeInsets.only(top: 17.0, left: 70),
            child: Row(
              children: [
                Text(
                  "New Product",
                  style: TextStyle(fontSize: 35.0, color: Palette.darkBlue, fontFamily: "Signatra"),
                ),
              ],
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Palette.darkBlue),

          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Palette.darkBlue,
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => AdminHomePage());
                Navigator.pushReplacement(context, route);
              },
            ),
          ),
        ),
      ) ,

      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody(){
    return Container(
      decoration:  BoxDecoration(
          color: Colors.grey[100]
      ),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two, color: Palette.darkBlue, size: 200.0),
            InkWell(
              onTap: (){
                takeImage(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.darkBlue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3.0
                      ),
                    ]
                ),
                child: Center(
                  child: Text(
                    "Add New Product",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "PatrickHand", fontSize: 25.0),
                  ),
                ),
                width: 180,
                height: 40,
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
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
                color: Colors.white
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Palette.darkBlue,
              onPressed: clearFormInfo,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 70),
            child: Row(
              children: [
                Text(
                  "New Product",
                  style: TextStyle(fontSize: 35.0, color: Palette.darkBlue, fontFamily: "Signatra"),
                ),
              ],
            ),
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
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.fitHeight), color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12)),

          ListTile(
            leading: Icon(Icons.info, color: Palette.darkBlue,),
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
            leading: Icon(Icons.info, color: Palette.darkBlue,),
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
            leading: Icon(Icons.info, color: Palette.darkBlue,),
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
            leading: Icon(Icons.info, color: Palette.darkBlue,),
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
      "price": double.parse(_price.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _title.text.trim(),
      "store": shopApp.sharedPreferences.getString("storeID"),
      "category": widget.category_name

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
