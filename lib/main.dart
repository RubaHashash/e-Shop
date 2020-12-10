import 'package:e_shop_app/Counters/ItemQuantity.dart';
import 'package:e_shop_app/Counters/cartCounter.dart';
import 'package:e_shop_app/Counters/changeAddress.dart';
import 'package:e_shop_app/Counters/totalMoney.dart';
import 'package:e_shop_app/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authentication/LoginPage.dart';
import 'config/palette.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  shopApp.auth = FirebaseAuth.instance;
  shopApp.sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),

      ],
      child: MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.muliTextTheme(),
          accentColor: Palette.darkOrange,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: Palette.darkBlue,
          ),
        ),

        home: LoginPage(),
      ),
    );
  }
}
