import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'menu_data.dart';

class InsertMenuPage extends StatefulWidget {
  @override
  _InsertMenuPageState createState() => _InsertMenuPageState();
}

class _InsertMenuPageState extends State<InsertMenuPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insert New Menu',
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
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
        child: ListView(
          children: [
            SizedBox(height: size.height * 0.02),
            _buildTextField(_nameController, 'Menu Name'),
            _buildTextField(_descriptionController, 'Description'),
            _buildTextField(_priceController, 'Price (Rp)', isNumber: true),
            _buildTextField(_ratingController, 'Rating (1-5)', isNumber: true),
            _buildTextField(_imageUrlController, 'Image URL'),
            SizedBox(height: size.height * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02, horizontal: size.width * 0.32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _insertMenu,
              child: Text('Insert Menu',
                style: GoogleFonts.questrial(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _insertMenu() async {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double rating = double.tryParse(_ratingController.text) ?? 0.0;
    String imageUrl = _imageUrlController.text.trim().isNotEmpty
        ? _imageUrlController.text.trim()
        : 'assets/default_image.jpg';

    if (name.isEmpty || description.isEmpty || price <= 0 || rating < 1 || rating > 5) {
      _showErrorDialog('Please fill all fields correctly.');
      return;
    }

    bool isMenuExists = await _checkIfMenuExists(name);
    if (isMenuExists) {
      _showErrorDialog('A menu item with this name already exists.');
      return;
    }

    MenuItem menuItem = MenuItem(
      name: name,
      description: description,
      price: price,
      rating: rating,
      imageUrl: imageUrl,
    );

    try {
      await DatabaseHelper.instance.insertMenu(menuItem.toMap());
      _showSuccessDialog('Menu item has been added successfully.');
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  Future<bool> _checkIfMenuExists(String name) async {
    return await DatabaseHelper.instance.isMenuExistsByName(name);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Add Another'),
            onPressed: () {
              Navigator.of(context).pop();
              _clearFields();
            },
          ),
          TextButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _ratingController.clear();
    _imageUrlController.clear();
  }
}
