import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'menu_data.dart';
import 'cart_item.dart';
import 'cart_provider.dart';

class MenuDetailPage extends StatefulWidget {
  final MenuItem menuItem;

  const MenuDetailPage({required this.menuItem});

  @override
  _MenuDetailPageState createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  String _sugarLevel = 'Normal Sugar';
  String _iceLevel = 'Normal Ice';
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name,
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
          // Image display
          Container(
            height: size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage(widget.menuItem.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(size.width * 0.05),
              children: [
                // Menu details
                Text(
                  widget.menuItem.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(widget.menuItem.description,
                  style: GoogleFonts.questrial(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text('Rp ${widget.menuItem.price.toStringAsFixed(0)}',
                  style: GoogleFonts.questrial(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAF251C),
                  ),
                ),
                SizedBox(height: 16),

                // Sugar Level Selection
                Text('Sugar Level:',
                  style: GoogleFonts.questrial(
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _customElevatedButton('Normal Sugar', () {
                      setState(() {
                        _sugarLevel = 'Normal Sugar';
                      });
                    }, _sugarLevel == 'Normal Sugar'),
                    _customElevatedButton('Less Sugar', () {
                      setState(() {
                        _sugarLevel = 'Less Sugar';
                      });
                    }, _sugarLevel == 'Less Sugar'),
                    _customElevatedButton('No Sugar', () {
                      setState(() {
                        _sugarLevel = 'No Sugar';
                      });
                    }, _sugarLevel == 'No Sugar'),
                  ],
                ),
                SizedBox(height: 16),

// Ice Level Selection
                Text('Ice Level:',
                  style: GoogleFonts.questrial(
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _customElevatedButton('Normal Ice', () {
                      setState(() {
                        _iceLevel = 'Normal Ice';
                      });
                    }, _iceLevel == 'Normal Ice'),
                    _customElevatedButton('Less Ice', () {
                      setState(() {
                        _iceLevel = 'Less Ice';
                      });
                    }, _iceLevel == 'Less Ice'),
                    _customElevatedButton('No Ice', () {
                      setState(() {
                        _iceLevel = 'No Ice';
                      });
                    }, _iceLevel == 'No Ice'),
                  ],
                ),

                SizedBox(height: 16),

                // Quantity Selection
                Text('Quantity:',
                  style: GoogleFonts.questrial(
                    fontSize: 14,
                  ),),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Text('$_quantity',
                      style: GoogleFonts.questrial(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing before the button
              ],
            ),
          ),

          // Add to Cart Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Create a new CartItem with the current configurations
                CartItem cartItem = CartItem(
                  name: widget.menuItem.name,
                  price: widget.menuItem.price,
                  sugarLevel: _sugarLevel,
                  iceLevel: _iceLevel,
                  quantity: _quantity,
                );

                // Add the item to the cart provider
                Provider.of<CartProvider>(context, listen: false).addToCart(cartItem);

                // Optionally, show a snackbar message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.menuItem.name} added to cart!')),
                );

                // Go back to the previous screen
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.32),
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
              child: Text('Add to Cart',
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

Widget _customElevatedButton(String label, VoidCallback onPressed, bool isSelected) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Color(0xFFAF251C) : Colors.white,
      elevation: 0, // Remove elevation
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      )
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : Color(0xFFAF251C)
      ),
    ),
  );
}