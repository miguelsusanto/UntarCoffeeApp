import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class ViewUserAccountPage extends StatefulWidget {
  @override
  _ViewUserAccountPageState createState() => _ViewUserAccountPageState();
}

class _ViewUserAccountPageState extends State<ViewUserAccountPage> {
  List<Map<String, dynamic>> userAccounts = []; // List of user accounts
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Load user data from database
  Future<void> loadUserData() async {
    try {
      // Fetch user data from the database
      final users = await DatabaseHelper.instance.getUsers();

      // Make sure we are working with a mutable list
      setState(() {
        userAccounts = List<Map<String, dynamic>>.from(users); // Ensure it's mutable
        userAccounts.sort((a, b) {
          if (a['role'] == 'pending') return -1;
          if (b['role'] == 'pending') return 1;
          return 0;
        });
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  // Function to handle promoting user to admin
  Future<void> promoteToAdmin(int userId) async {
    try {
      await DatabaseHelper.instance.promoteUserToAdmin(userId);
      loadUserData(); // Reload data after the update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User promoted to admin')),
      );
    } catch (e) {
      print('Error promoting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to promote user')),
      );
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await DatabaseHelper.instance.deleteUser(userId);
      loadUserData(); // Reload data after the update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User successfully deleted')),
      );
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  // Function to handle demoting admin to user
  Future<void> demoteToUser(int userId) async {
    try {
      await DatabaseHelper.instance.demoteAdminToUser(userId);
      loadUserData(); // Reload data after the update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin demoted to user')),
      );
    } catch (e) {
      print('Error demoting admin: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to demote admin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accounts',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // List of user accounts
          Expanded(
            child: userAccounts.isEmpty
                ? Center(child: Text('No user accounts available.'))
                : ListView.builder(
              itemCount: userAccounts.length,
              itemBuilder: (context, index) {
                final user = userAccounts[index];
                bool isPending = user['role'] == 'pending';
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isPending ? Colors.red.shade200 : Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Row(
                      children: [
                        // User details
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'] ?? 'Unknown Name',
                                style: GoogleFonts.questrial(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.045,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                user['email'] ?? 'Unknown Email',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.03,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Phone: ${user['phone'] ?? 'Unknown'}',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.03,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Role: ${user['role'] ?? 'Unknown'}',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.03,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Buttons to change user role
                        Row(
                          children: [
                            // If role is pending, show promotion/demotion buttons
                            if (isPending)
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.check, color: Colors.green),
                                    onPressed: () => promoteToAdmin(user['id']),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () => demoteToUser(user['id']),
                                  ),
                                ],
                              ),
                            // If role is admin or user, allow promote/demote buttons and delete button
                            if (!isPending)
                              Row(
                                children: [
                                  // Show promote button if the user is a regular user
                                  if (user['role'] == 'user')
                                    IconButton(
                                      icon: Icon(Icons.arrow_upward, color: Colors.blue),
                                      onPressed: () => promoteToAdmin(user['id']),
                                    ),
                                  // Show demote button if the user is an admin
                                  if (user['role'] == 'admin')
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward, color: Colors.orange),
                                      onPressed: () => demoteToUser(user['id']),
                                    ),
                                  // Delete button that is visible for both 'user' and 'admin' roles
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Color(0xFFAF251C)),
                                    onPressed: () => deleteUser(user['id']),
                                  ),
                                ],
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
        ],
      ),
    );
  }
}
