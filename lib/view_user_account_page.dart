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

  Future<void> loadUserData() async {
    try {
      // Load all user accounts from the database
      final users = await DatabaseHelper.instance.getUsers();
      setState(() {
        userAccounts = users;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Accounts',
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
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
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
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  height: size.height * 0.005),
                              Text(
                                user['email'] ?? 'Unknown Email',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.035,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                  height: size.height * 0.005),
                              Text(
                                'Phone: ${user['phone'] ?? 'Unknown'}',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.035,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
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
