import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'shared_prefs_helper_user.dart';
import 'splash_screen.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final SharedPrefsHelperUser _prefsHelper = SharedPrefsHelperUser();
  Map<String, dynamic>? user; // User data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Get the logged-in user's ID from SharedPreferences
      int? userId = await _prefsHelper.getLoggedInUserId();

      if (userId != null) {
        // Fetch user data from the database using the ID
        final fetchedUser = await DatabaseHelper.instance.getUserById(userId);

        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    // Remove login status and logged-in user ID from SharedPreferences
    await _prefsHelper.clearUserLoginData();

    if (mounted) {
      _navigateToSplashScreen();
    }
  }

  Future<void> _deleteAccount() async {
    if (user != null) {
      try {
        // Delete user account from the database
        await DatabaseHelper.instance.deleteUser(user!['id']);
        await _logout(); // Logout after deleting account
      } catch (e) {
        print('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account')),
        );
      }
    }
  }

  void _navigateToSplashScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false,
    );
  }

  void _showDeleteConfirmation() {
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
                "Delete Account?",
                style: GoogleFonts.questrial(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure to delete your account?",
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the pop-up
                      _deleteAccount(); // Delete the account
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the pop-up
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

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
      body: user == null
          ? Center(
        child: Text(
          'No user data available.',
          style: GoogleFonts.questrial(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      )
          : Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: size.width * 0.15,
              backgroundImage:
              AssetImage('assets/profilepicture.jpg'),
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              user!['name'],
              style: GoogleFonts.questrial(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              user!['email'],
              style: GoogleFonts.questrial(
                fontSize: size.width * 0.04,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              user!['phone'] ?? '',
              style: GoogleFonts.questrial(
                fontSize: size.width * 0.04,
                color: Colors.grey[700],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAF251C),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: size.width * 0.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Log Out",
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.045,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                IconButton(
                  onPressed: _showDeleteConfirmation,
                  icon: Icon(Icons.delete_forever),
                  color: Color(0xFFAF251C),
                  iconSize: 28,
                  tooltip: 'Delete Account',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
