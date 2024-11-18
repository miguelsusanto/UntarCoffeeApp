import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untarfoodapp/database_helper.dart';
import 'package:untarfoodapp/menu_data.dart';
import 'insert_menu_page.dart';

class ViewMenuDatabasePage extends StatefulWidget {
  @override
  _ViewMenuDatabasePageState createState() => _ViewMenuDatabasePageState();
}

class _ViewMenuDatabasePageState extends State<ViewMenuDatabasePage> {
  List<MenuItem> menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Ambil data menu dari database menggunakan getMenuItems
      final menuList = await DatabaseHelper.instance.getMenuItems();

      // Konversi hasil map ke list of MenuItem
      final items = menuList.map((map) => MenuItem.fromMap(map)).toList();

      setState(() {
        menuItems = items; // Simpan hasil konversi
        isLoading = false;
      });

      print('Items loaded: ${items.length}');
    } catch (e) {
      print('Error loading menu items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> navigateToInsertMenuPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertMenuPage()),
    );

    // If a new menu item is added, reload the list
    if (result == true) {
      loadMenuItems();
    }
  }

  Future<void> deleteMenuItem(int id) async {
    try {
      await DatabaseHelper.instance.deleteMenu(id);
      setState(() {
        menuItems.removeWhere((item) => item.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully')),
      );
    } catch (e) {
      print('Error deleting menu item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Database',
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
          // Tombol Insert Menu
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.02,
              horizontal: size.width * 0.05,
            ),
            child: ElevatedButton(
              onPressed: navigateToInsertMenuPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAF251C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.015,
                  horizontal: size.width * 0.06,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    'Insert New Menu',
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Daftar Menu
          Expanded(
            child: menuItems.isEmpty
                ? Center(child: Text('No menu items available.'))
                : ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.01),
                    child: Row(
                      children: [
                        // Gambar item
                        Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(
                                item.imageUrl.isNotEmpty
                                    ? item.imageUrl
                                    : 'assets/default_image.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        // Detail item
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.questrial(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: size.height * 0.001),
                              Text(
                                'Rp ${item.price.toStringAsFixed(0)}',
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.03,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: size.height * 0.001),
                              Text(
                                item.description,
                                style: GoogleFonts.questrial(
                                  fontSize: size.width * 0.03,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: size.height * 0.001),
                              Row(
                                children: [
                                  Text(
                                    '${item.rating.toString()} ★',
                                    style: GoogleFonts.questrial(
                                      fontSize: size.width * 0.03,
                                      color: Color(0xFFFDCC0D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Tombol Delete
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: Color(0xFFAF251C)),
                          onPressed: () {
                            deleteMenuItem(item.id!);
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
