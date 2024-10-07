import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart';
import 'account_page.dart';
import 'menu_data.dart';
import 'menu_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<MenuItem> filteredMenuItems = menuItems; // Initial list of menu items

  @override
  void initState() {
    super.initState();

    // Listen for changes in the search field
    _searchController.addListener(() {
      filterMenuItems();
    });
  }

  void filterMenuItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredMenuItems = menuItems.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
    });
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
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.03,
              left: size.width * 0.07,
              right: size.width * 0.07,
              bottom: size.height * 0.02,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft, // Align to the left
                  child: Text(
                    'Hello, Untarian!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAF251C),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.008),
                TextField(
                  controller: _searchController, // Attach the controller
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Color(0xFFAF251C),
                        width: 4.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Color(0xFFAF251C),
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: size.height * 0.015,
                      horizontal: size.width * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items Section
          Flexible(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.06,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio: 0.8, // Adjust this value to fit the aspect ratio
                crossAxisSpacing: size.width * 0.03, // Space between cards
                mainAxisSpacing: size.width * 0.03, // Space between rows
              ),
              itemCount: filteredMenuItems.length, // Use filtered list
              itemBuilder: (context, index) {
                final item = filteredMenuItems[index];
                return MenuCard(menuItem: item);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem menuItem;

  const MenuCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailPage(menuItem: menuItem),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed height for the image with stretching
            Container(
              height: size.height * 0.12, // Set the desired height for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(menuItem.imageUrl),
                  fit: BoxFit.cover, // Fill the space without maintaining aspect ratio
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    menuItem.name,
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.001),
                  // Description with max 2 lines
                  Text(
                    menuItem.description,
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.02,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Show "..." if overflowed
                  ),
                  SizedBox(height: size.height * 0.02),
                  // Price and Rating Section
                  Row(
                    children: [
                      Expanded( // Use Expanded to ensure the text fits
                        child: Text(
                          'Rp ${menuItem.price.toStringAsFixed(0)}',
                          style: GoogleFonts.questrial(
                            fontSize: size.width * 0.03,
                            color: Color(0xFFAF251C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.01), // Space between price and rating
                      Text(
                        '${menuItem.rating.toString()} ★',
                        style: GoogleFonts.questrial(
                          fontSize: size.width * 0.03,
                          color: Color(0xFFFDCC0D),
                          fontWeight: FontWeight.bold,
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
    );
  }
}
