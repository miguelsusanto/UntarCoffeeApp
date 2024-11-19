import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class ViewAdminAccountPage extends StatefulWidget {
  @override
  _ViewAdminAccountPageState createState() => _ViewAdminAccountPageState();
}

class _ViewAdminAccountPageState extends State<ViewAdminAccountPage> {
  List<Map<String, dynamic>> adminAccounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    try {
      // Load all admin accounts from the database
      final admins = await DatabaseHelper.instance.getAdmins();

      setState(() {
        adminAccounts = admins;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading admin data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteAdminAccount(int id) async {
    try {
      await DatabaseHelper.instance.deleteAdmin(id);
      setState(() {
        adminAccounts.removeWhere((admin) => admin['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin account deleted successfully')),
      );
    } catch (e) {
      print('Error deleting admin account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete admin account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Accounts',
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
          // List of admin accounts
          Expanded(
            child: adminAccounts.isEmpty
                ? Center(child: Text('No admin accounts available.'))
                : ListView.builder(
              itemCount: adminAccounts.length,
              itemBuilder: (context, index) {
                final admin = adminAccounts[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Row(
                      children: [
                        // Admin details
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                admin['name'] ?? 'Unknown Name',
                                style: GoogleFonts.questrial(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                admin['email'] ?? 'Unknown Email',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.035,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                'Password: ${admin['password'] ?? 'Unknown'}',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.035,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Delete button
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: Color(0xFFAF251C)),
                          onPressed: () {
                            deleteAdminAccount(admin['id']);
                          },
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
