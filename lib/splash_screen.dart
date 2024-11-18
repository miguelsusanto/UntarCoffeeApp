import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'shared_prefs_helper_user.dart';
import 'database_helper.dart';
import 'admin_login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLoginForm = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _prefsUser = SharedPrefsHelperUser(); // SharedPreferences khusus untuk user

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    bool isUserLoggedIn = await _prefsUser.getUserLoginStatus();

    if (isUserLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          showLoginForm = true;
        });
      });
    }
  }

  Future<void> _loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Ambil data user dari database
    final user = await DatabaseHelper.instance.getUserByEmailAndPassword(email, password);

    if (user != null) {
      // Simpan login status
      await _prefsUser.saveUserLoginStatus(true, user['id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Tampilkan pesan error jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Logo dan Teks UNTAR Coffee di tengah layar
          AnimatedPositioned(
            duration: Duration(milliseconds: 800),
            top: showLoginForm ? size.height * 0.1 : size.height * 0.4,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.5,
                  child: Image.asset(
                    'assets/logoonly.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'UNTAR Coffee',
                  style: GoogleFonts.questrial(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAF251C),
                  ),
                ),
              ],
            ),
          ),

          // Form Login muncul setelah delay
          AnimatedPositioned(
            duration: Duration(milliseconds: 800),
            top: showLoginForm ? size.height * 0.4 : size.height,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: Opacity(
              opacity: showLoginForm ? 1.0 : 0.0,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // Input Email
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

                        // Input Password
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
                        SizedBox(height: 30),

                        // Tombol Login
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _loginUser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFAF251C),
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: size.width * 0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.questrial(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Register Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.questrial(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()),
                                );
                              },
                              child: Text(
                                'Register',
                                style: GoogleFonts.questrial(
                                  fontSize: 14,
                                  color: Color(0xFFAF251C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Admin Login Option
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Are you an admin? ",
                              style: GoogleFonts.questrial(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
                                );
                              },
                              child: Text(
                                'Admin Login',
                                style: GoogleFonts.questrial(
                                  fontSize: 14,
                                  color: Color(0xFFAF251C),
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        ],
      ),
    );
  }
}
