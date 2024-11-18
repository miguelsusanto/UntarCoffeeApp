import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelperUser {
  static const String _isLoggedInKey = 'userIsLoggedIn';
  static const String _loggedInUserIdKey = 'userLoggedInId';

  // Simpan status login user
  Future<void> saveUserLoginStatus(bool isLoggedIn, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
    await prefs.setInt(_loggedInUserIdKey, userId);
  }

  // Dapatkan status login user
  Future<bool> getUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Dapatkan ID user yang sedang login
  Future<int?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_loggedInUserIdKey);
  }

  // Logout user
  Future<void> clearUserLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_loggedInUserIdKey);
  }
}
