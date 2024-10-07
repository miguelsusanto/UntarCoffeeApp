import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: GoogleFonts.questrial(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFAF251C),

        iconTheme: IconThemeData(
        color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: size.width * 0.15, // Adjust the size of the profile picture
              backgroundImage: AssetImage('assets/williamgunawan.jpg'), // Replace with actual image
            ),
            SizedBox(height: size.height * 0.03),

            // User Information
            Text(
              'William Gunawan',
              style: GoogleFonts.questrial(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'william.gunawan@gmail.com',
              style: GoogleFonts.questrial(
                fontSize: size.width * 0.04,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              '+62 123 456 789',
              style: GoogleFonts.questrial(
                fontSize: size.width * 0.04,
                color: Colors.grey[700],
              ),
            ),

            SizedBox(height: size.height * 0.04), // Add some space before wallets

            // Wallets Section
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GoPay Wallet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GoPay Wallet',
                        style: GoogleFonts.questrial(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp 150,000',
                        style: GoogleFonts.questrial(
                          fontSize: size.width * 0.04,
                          color: Color(0xFFAF251C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),

                  // OVO Wallet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OVO Wallet',
                        style: GoogleFonts.questrial(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp 120,000',
                        style: GoogleFonts.questrial(
                          fontSize: size.width * 0.04,
                          color: Color(0xFFAF251C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
