import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class RegisterAdminPage extends StatefulWidget {
  @override
  _RegisterAdminPageState createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _registerAdmin() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Check if the admin email is already registered
        final existingAdmin = await DatabaseHelper.instance.getAdminByEmail(email);
        if (existingAdmin != null) {
          // Show a message if the email is already registered
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Admin email is already registered. Use a different email.")),
          );
        } else {
          // Add admin to the database
          await DatabaseHelper.instance.insertAdmin({
            'name': name,
            'email': email,
            'password': password,
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Admin account registered successfully!")),
          );
          Navigator.pop(context); // Go back to the previous page
        }
      } catch (e) {
        // Show error message in case of a database issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register Admin",
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
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input Admin Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Input Admin Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Input Admin Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),

              // Register Admin Button
              ElevatedButton(
                onPressed: _registerAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFAF251C),
                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: size.width * 0.245,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Register Admin",
                  style: GoogleFonts.questrial(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
