import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'payment_page.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart',
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.015),
                    child: Column(
                      children: [
                        // Upper section with item details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Upper Left: Name, Sugar Level, Ice Level
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.questrial(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.04,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Text('Sugar Level: ${item.sugarLevel}'),
                                  Text('Ice Level: ${item.iceLevel}'),
                                ],
                              ),
                            ),

                            // Upper Right: Quantity controls
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          // Decrease the quantity by 1
                                          cartProvider.addToCart(item.copyWith(quantity: -1));
                                        } else {
                                          // Remove the item if quantity reaches 0
                                          cartProvider.removeFromCart(index);
                                        }
                                      },
                                    ),
                                    Text('${item.quantity}',
                                      style: GoogleFonts.questrial(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        // Increase the quantity by 1
                                        cartProvider.addToCart(item.copyWith(quantity: 1));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Bottom section with total price
                        SizedBox(height: size.height * 0.002), // Spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Rp ${item.price * item.quantity}',
                              style: GoogleFonts.questrial(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.04,
                                color: Color(0xFFAF251C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Total Price for the entire cart
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1, top: size.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Total Price:  Rp ${cartProvider.totalPrice}',
                  style: GoogleFonts.questrial(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Proceed to Checkout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Payment Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.22),
                textStyle: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                // Change colors based on button state
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Color(0xFF821B14);
                    }
                    return Color(0xFFAF251C);
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white; // Text color when pressed
                    }
                    return Colors.white; // Default text color
                  },
                ),
              ),

              child: Text('Proceed to Checkout',
                style: GoogleFonts.questrial(
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}