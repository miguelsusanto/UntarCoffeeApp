import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untarfoodapp/insert_menu_page.dart';
import 'view_menu_database_page.dart'; // Halaman untuk melihat database menu
import 'splash_screen.dart'; // Halaman splash screen
import 'view_user_account_page.dart';
import 'shared_prefs_helper_admin.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final SharedPrefsHelperAdmin _prefsHelper = SharedPrefsHelperAdmin();

  Future<void> _logout() async {
    await _prefsHelper.clearAdminLoginData();

    if (mounted) {
      _navigateToSplashScreen();
    }
  }

  void _navigateToSplashScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false,
    );
  }

  Future<void> navigateToInsertMenuPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertMenuPage()),
    );

    // Jika result bernilai true, lakukan sesuatu (opsional)
    if (result == true) {
      // Refresh data atau tindakan lainnya
    }
  }

  Future<void> navigateToViewMenuDatabasePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewMenuDatabasePage()),
    );
  }

  Future<void> navigateToViewUserAccountPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewUserAccountPage()),
    );
  }

  // Menampilkan konfirmasi sebelum logout
  void _showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: MediaQuery.of(context).size.height * 0.22,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Logout?",
                style: GoogleFonts.questrial(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to logout?",
                style: GoogleFonts.questrial(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Yes Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup konfirmasi
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                            (route) => false, // Menghapus semua rute sebelumnya
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAF251C),
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.015,
                        horizontal: size.width * 0.185,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Yes",
                      style: GoogleFonts.questrial(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup konfirmasi
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.015,
                        horizontal: size.width * 0.155,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.questrial(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UNTAR Coffee',
          style: GoogleFonts.questrial(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFAF251C),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutConfirmation, // Tampilkan konfirmasi logout
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.03),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello, Admin!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAF251C),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            // Tombol 1: View Menu Database
            ElevatedButton(
              onPressed: navigateToViewMenuDatabasePage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.06,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_list, color: Colors.white),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    'View Menu Database',
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.045,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            // Tombol 2: View Accounts
            ElevatedButton(
              onPressed: navigateToViewUserAccountPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.06,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.white),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    'View Accounts',
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.045,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
