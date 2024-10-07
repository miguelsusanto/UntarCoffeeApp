import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'splash_screen.dart';

void main() {
  runApp(UntarFoodApp());
}

class UntarFoodApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'UNTAR Coffee',
        theme: ThemeData(
          fontFamily: "Cabin",
          primaryColor: Color(0xFFAF251C),
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      )
    );
  }
}
