import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'insert_menu_page.dart';
import 'cart_page.dart';
import 'account_page.dart';
import 'database_helper.dart';
import 'menu_data.dart';
import 'menu_detail_page.dart';
import 'splash_screen.dart';
import 'shared_prefs_helper_user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  TextEditingController _searchController = TextEditingController();
  List<MenuItem> allMenuItems = [];
  List<MenuItem> filteredMenuItems = [];
  bool isLoading = true;
  double? distanceToCampus; // Variabel untuk menyimpan jarak
  final SharedPrefsHelperUser _prefsHelper = SharedPrefsHelperUser();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    _searchController.addListener(() {
      filterMenuItems();
    });
    loadMenuItems(); // Load data when the page initializes
    getDistanceToCampus(); // Hitung jarak ke Universitas Tarumanagara
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload data when the app returns to focus
      loadMenuItems();
      getDistanceToCampus();
    }
  }

  Future<void> navigateToInsertMenuPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertMenuPage()),
    );

    // If the result is true, refresh the data
    if (result == true) {
      loadMenuItems();
    }
  }

  Future<void> loadMenuItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Ambil data menu dari database
      final menuList = await DatabaseHelper.instance.getMenuItems();

      // Konversi hasil query menjadi objek MenuItem
      final items = menuList.map((map) => MenuItem.fromMap(map)).toList();

      setState(() {
        allMenuItems = items;
        filteredMenuItems = items; // Awalnya tampilkan semua item
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


  Future<void> getDistanceToCampus() async {
    try {
      // Meminta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          distanceToCampus = null; // Tidak bisa menghitung jarak
        });
        return;
      }

      // Dapatkan lokasi pengguna
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Koordinat Universitas Tarumanagara (Kampus 1)
      const untarLatitude = -6.200918;
      const untarLongitude = 106.783268;

      // Hitung jarak
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        untarLatitude,
        untarLongitude,
      );

      // Konversi ke kilometer
      double distanceInKm = distanceInMeters / 1000;

      setState(() {
        distanceToCampus = distanceInKm; // dalam kilometer
      });

      // Periksa apakah jarak lebih dari 100 km
      if (distanceInKm > 100) {
        showDistanceAlert(distanceInKm);
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        distanceToCampus = null;
      });
    }
  }

  void showDistanceAlert(double distance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Jarak Terlalu Jauh"),
          content: Text(
            "Jarak Anda ke UNTAR Coffee adalah ${distance.toStringAsFixed(2)} km.\n"
                "Apakah Anda ingin melanjutkan memesan?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                _logout();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup pop-up
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    // Remove login status and logged-in user ID from SharedPreferences
    await _prefsHelper.clearUserLoginData();

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



  void filterMenuItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredMenuItems = allMenuItems.where((item) {
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, Untarian!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAF251C),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFAF251C), // Warna merah sesuai tema
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Membuat lebar mengikuti konten
                      children: [
                        Icon(
                          Icons.location_on, // Ikon lokasi
                          color: Colors.white, // Warna ikon putih
                          size: 16.0,
                        ),
                        SizedBox(width: 8.0), // Spasi antara ikon dan teks
                        Text(
                          distanceToCampus == null
                              ? 'Calculating distance...'
                              : 'Distance to UNTAR : ${distanceToCampus!.toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _searchController,
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
          Flexible(
            child: filteredMenuItems.isEmpty
                ? Center(child: Text('No menu items available.'))
                : GridView.builder(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.06,
              ),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: size.width * 0.03,
                mainAxisSpacing: size.width * 0.03,
              ),
              itemCount: filteredMenuItems.length,
              itemBuilder: (context, index) {
                final item = filteredMenuItems[index];
                return MenuCard(menuItem: item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFAF251C),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
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
            Container(
              height: size.height * 0.12,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                    menuItem.imageUrl.isNotEmpty
                        ? menuItem.imageUrl
                        : 'assets/default_image.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    menuItem.description,
                    style: GoogleFonts.questrial(
                      fontSize: size.width * 0.025,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rp ${menuItem.price.toStringAsFixed(0)}',
                          style: GoogleFonts.questrial(
                            fontSize: size.width * 0.03,
                            color: Color(0xFFAF251C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.01),
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
