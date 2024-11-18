import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelperAdmin {
  static const String _isLoggedInKey = 'adminIsLoggedIn';
  static const String _loggedInAdminIdKey = 'adminLoggedInId';

  // Simpan status login admin
  Future<void> saveAdminLoginStatus(bool isLoggedIn, int adminId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
    await prefs.setInt(_loggedInAdminIdKey, adminId);
  }

  // Dapatkan status login admin
  Future<bool> getAdminLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Dapatkan ID admin yang sedang login
  Future<int?> getLoggedInAdminId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_loggedInAdminIdKey);
  }

  // Logout admin
  Future<void> clearAdminLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_loggedInAdminIdKey);
  }
}
