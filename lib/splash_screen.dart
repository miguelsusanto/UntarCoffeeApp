import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            width: size.width * 0.5,
            child: Image.asset(
              'assets/logoonly.png',
              fit: BoxFit.cover, // Fill the space while maintaining aspect ratio
            ),
          ),
            SizedBox(height: 30),
            Text(
              'UNTAR Coffee',
              style: GoogleFonts.afacad(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAF251C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
