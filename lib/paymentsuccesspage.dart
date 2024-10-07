import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';  // Import the provider package
import 'cart_provider.dart';  // Import the cart provider

class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);  // Access the cart provider

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: GoogleFonts.questrial(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for your order!',
              style: GoogleFonts.questrial(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart(); // Clear the cart when payment is successful
                Navigator.popUntil(context, (route) => route.isFirst); // Navigate back to home page
              },
              child: Text(
                'Go to Home',
                style: GoogleFonts.questrial(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
