import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {

  final double totalAmount;
  final String addressID;

  PaymentPage({Key key, this.totalAmount, this.addressID}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
