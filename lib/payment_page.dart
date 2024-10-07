import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'paymentsuccesspage.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'Cash'; // Default payment method

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Column(
                              children: [
                                Text(
                                  '${item.quantity}',
                                  style: GoogleFonts.questrial(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text('Choose Payment Method:',
              style: GoogleFonts.questrial(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _customElevatedButton('Cash', () {
                setState(() {
                  _paymentMethod = 'Cash';
                });
              }, _paymentMethod == 'Cash'),
              _customElevatedButton('Gopay', () {
                setState(() {
                  _paymentMethod = 'Gopay';
                });
              }, _paymentMethod == 'Gopay'),
              _customElevatedButton('OVO', () {
                setState(() {
                  _paymentMethod = 'OVO';
                });
              }, _paymentMethod == 'OVO'),
            ],
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.04,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAF251C),
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.06),
                    textStyle: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Color(0xFF545454);
                        }
                        return Color(0xFF989898);
                      },
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white;
                        }
                        return Colors.white;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentSuccessPage()),
                    );
                  },
                  child: Text(
                    'Pay - Rp ${cartProvider.totalPrice}',
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.04,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAF251C),
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.17),
                    textStyle: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ).copyWith(
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
                          return Colors.white;
                        }
                        return Colors.white;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customElevatedButton(String label, VoidCallback onPressed, bool isSelected) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFFAF251C) : Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xFFAF251C),
          fontSize: 18,
        ),
      ),
    );
  }
}
