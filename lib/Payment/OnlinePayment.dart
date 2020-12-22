// import 'package:e_shop_app/Address/Address.dart';
// import 'package:e_shop_app/Store/StoreHome.dart';
// import 'package:e_shop_app/config/decoration_functions.dart';
// import 'package:e_shop_app/config/palette.dart';
// import 'package:flutter/material.dart';
//
// class OnlinePayment extends StatefulWidget {
//   @override
//   _OnlinePaymentState createState() => _OnlinePaymentState();
// }
//
// class _OnlinePaymentState extends State<OnlinePayment> {
//
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _NameOnCard = TextEditingController();
//   final TextEditingController _CardNumber = TextEditingController();
//   final DateTime _ExpiryDate;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[200],
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(70.0),
//           child: AppBar(
//             flexibleSpace: Container(
//               decoration:  BoxDecoration(
//                   color: Colors.white
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.only(top: 15.0),
//               child: Text(
//                 "Shopick",
//                 style: TextStyle(fontSize: 55.0, color: Palette.darkBlue, fontFamily: "Signatra"),
//               ),
//             ),
//             centerTitle: true,
//             leading: Padding(
//               padding: const EdgeInsets.only(top: 15.0),
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 color: Palette.darkBlue,
//                 onPressed: (){
//                   Route route = MaterialPageRoute(builder: (c) => Address());
//                   Navigator.pushReplacement(context, route);
//                 },
//               ),
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: (){
//             Route route = MaterialPageRoute(builder: (c) => Address());
//             Navigator.pushReplacement(context, route);
//           },
//           label: Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "PatrickHand", fontSize: 20.0)),
//           backgroundColor: Palette.darkBlue,
//           icon: Icon(Icons.check),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
//                   child: Text("Online Payment", style: TextStyle(color: Palette.darkBlue,
//                       fontWeight: FontWeight.bold, fontSize: 30.0, fontFamily: "PatrickHand")),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _NameOnCard,
//                         validator: (input) {
//                           if (input.isEmpty) {
//                             return 'Name on Card is Required';
//                           }
//                           return null;
//                         },
//                         decoration: inputDecoration(hintText: 'Name on Card', data: Icons.person),
//                         style: TextStyle(color: Palette.darkBlue),
//                         onSaved: (input) => _NameOnCard.text = input,
//                       ),
//                       SizedBox(height: 5),
//                       TextFormField(
//                         controller: _CardNumber,
//                         keyboardType: TextInputType.number,
//                         validator: (input) {
//                           if (input.isEmpty) {
//                             return 'Card Number is Required';
//                           }
//                           if (input.length < 16) {
//                             return 'Number should be of 16 bits';
//                           }
//                           return null;
//                         },
//                         decoration: inputDecoration(hintText: 'Card Number', data: Icons.phone_android),
//                         style: TextStyle(color: Palette.darkBlue),
//                         onSaved: (input) => _CardNumber.text = input,
//
//                       ),
//
//                       SizedBox(height: 5),
//
//                       TextFormField(
//                         controller: _cDetails,
//
//                         validator: (input) {
//                           if (input.isEmpty) {
//                             return 'Address details is required';
//                           }
//                           return null;
//                         },
//                         decoration: inputDecoration(hintText: 'Address Details', data: Icons.details),
//                         style: TextStyle(color: Palette.darkBlue),
//                         onSaved: (input) => _cDetails.text = input,
//
//                       ),
//
//                       SizedBox(height: 5),
//
//
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
