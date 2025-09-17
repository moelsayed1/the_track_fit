import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_track_fit/features/auth/data/models/register_response.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rememberMeKey = 'remember_me';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _mainGoalKey = 'main_goal';

  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._internal();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._internal();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Token Management
  Future<void> saveToken(String token) async {
    try {
      await _prefs!.setString(_tokenKey, token);
      log('StorageService: Token saved successfully');
    } catch (e) {
      log('StorageService: Error saving token: $e');
    }
  }

  String? getToken() {
    try {
      final token = _prefs!.getString(_tokenKey);
      log('StorageService: Token retrieved: ${token != null ? 'Found' : 'Not found'}');
      return token;
    } catch (e) {
      log('StorageService: Error getting token: $e');
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      await _prefs!.remove(_tokenKey);
      log('StorageService: Token cleared');
    } catch (e) {
      log('StorageService: Error clearing token: $e');
    }
  }

  // User Data Management
  Future<void> saveUserData(UserData userData) async {
    try {
      final userJson = jsonEncode(userData.toJson());
      await _prefs!.setString(_userDataKey, userJson);
      log('StorageService: User data saved successfully');
    } catch (e) {
      log('StorageService: Error saving user data: $e');
    }
  }

  UserData? getUserData() {
    try {
      final userJson = _prefs!.getString(_userDataKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final userData = UserData.fromJson(userMap);
        log('StorageService: User data retrieved successfully');
        return userData;
      }
      log('StorageService: No user data found');
      return null;
    } catch (e) {
      log('StorageService: Error getting user data: $e');
      return null;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _prefs!.remove(_userDataKey);
      log('StorageService: User data cleared');
    } catch (e) {
      log('StorageService: Error clearing user data: $e');
    }
  }

  // Login Status Management
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _prefs!.setBool(_isLoggedInKey, isLoggedIn);
      log('StorageService: Login status set to: $isLoggedIn');
    } catch (e) {
      log('StorageService: Error setting login status: $e');
    }
  }

  bool isLoggedIn() {
    try {
      final isLoggedIn = _prefs!.getBool(_isLoggedInKey) ?? false;
      log('StorageService: Login status: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      log('StorageService: Error getting login status: $e');
      return false;
    }
  }

  // Remember Me Management
  Future<void> setRememberMe(bool rememberMe) async {
    try {
      await _prefs!.setBool(_rememberMeKey, rememberMe);
      log('StorageService: Remember me set to: $rememberMe');
    } catch (e) {
      log('StorageService: Error setting remember me: $e');
    }
  }

  bool getRememberMe() {
    try {
      final rememberMe = _prefs!.getBool(_rememberMeKey) ?? false;
      log('StorageService: Remember me: $rememberMe');
      return rememberMe;
    } catch (e) {
      log('StorageService: Error getting remember me: $e');
      return false;
    }
  }

  // Complete Auth Data Management
  Future<void> saveAuthData(AuthData authData) async {
    try {
      await saveToken(authData.token);
      await saveUserData(authData.user);
      await setLoggedIn(true);
      log('StorageService: Complete auth data saved successfully');
    } catch (e) {
      log('StorageService: Error saving complete auth data: $e');
    }
  }

  AuthData? getAuthData() {
    try {
      final token = getToken();
      final userData = getUserData();
      
      if (token != null && userData != null) {
        final authData = AuthData(user: userData, token: token);
        log('StorageService: Complete auth data retrieved successfully');
        return authData;
      }
      log('StorageService: Incomplete auth data - token: ${token != null}, user: ${userData != null}');
      return null;
    } catch (e) {
      log('StorageService: Error getting complete auth data: $e');
      return null;
    }
  }

  // Clear All Auth Data
  Future<void> clearAllAuthData() async {
    try {
      await clearToken();
      await clearUserData();
      await setLoggedIn(false);
      await setRememberMe(false);
      log('StorageService: All auth data cleared');
    } catch (e) {
      log('StorageService: Error clearing all auth data: $e');
    }
  }

  // Check if user has valid session
  bool hasValidSession() {
    try {
      final isLoggedIn = this.isLoggedIn();
      final hasToken = getToken() != null;
      final hasUserData = getUserData() != null;
      
      final isValid = isLoggedIn && hasToken && hasUserData;
      log('StorageService: Valid session check - isLoggedIn: $isLoggedIn, hasToken: $hasToken, hasUserData: $hasUserData, isValid: $isValid');
      return isValid;
    } catch (e) {
      log('StorageService: Error checking valid session: $e');
      return false;
    }
  }

  // Update specific user fields
  Future<void> updateUserField(String field, dynamic value) async {
    try {
      final userData = getUserData();
      if (userData != null) {
        final userMap = userData.toJson();
        userMap[field] = value;
        final updatedUserData = UserData.fromJson(userMap);
        await saveUserData(updatedUserData);
        log('StorageService: Updated user field $field');
      }
    } catch (e) {
      log('StorageService: Error updating user field $field: $e');
    }
  }

  // First Time User Management
  Future<void> setFirstTimeUser(bool isFirstTime) async {
    try {
      await _prefs!.setBool(_isFirstTimeKey, isFirstTime);
      log('StorageService: First time user set to: $isFirstTime');
    } catch (e) {
      log('StorageService: Error setting first time user: $e');
    }
  }

  bool isFirstTimeUser() {
    try {
      final isFirstTime = _prefs!.getBool(_isFirstTimeKey) ?? true; // Default to true for new users
      log('StorageService: Is first time user: $isFirstTime');
      return isFirstTime;
    } catch (e) {
      log('StorageService: Error getting first time user status: $e');
      return true; // Default to true if error
    }
  }

  // Mark user as no longer first time (after they tap "Start Workout")
  Future<void> markUserAsReturning() async {
    try {
      await setFirstTimeUser(false);
      log('StorageService: User marked as returning user');
    } catch (e) {
      log('StorageService: Error marking user as returning: $e');
    }
  }

  // Save profile image to SharedPreferences
  Future<void> saveProfileImage(String imagePath) async {
    try {
      await _prefs!.setString('profile_image', imagePath);
      log('StorageService: Profile image saved successfully');
    } catch (e) {
      log('StorageService: Error saving profile image: $e');
    }
  }

  // Get profile image from SharedPreferences
  String? getProfileImage() {
    try {
      final imagePath = _prefs!.getString('profile_image');
      log('StorageService: Profile image retrieved: ${imagePath != null ? 'Found' : 'Not found'}');
      return imagePath;
    } catch (e) {
      log('StorageService: Error getting profile image: $e');
      return null;
    }
  }

  // Main Goal Management
  Future<void> saveMainGoal(String goal) async {
    try {
      await _prefs!.setString(_mainGoalKey, goal);
      log('StorageService: Main goal saved successfully: $goal');
    } catch (e) {
      log('StorageService: Error saving main goal: $e');
    }
  }

  String? getMainGoal() {
    try {
      final goal = _prefs!.getString(_mainGoalKey);
      log('StorageService: Main goal retrieved: ${goal != null ? goal : 'Not found'}');
      return goal;
    } catch (e) {
      log('StorageService: Error getting main goal: $e');
      return null;
    }
  }

  Future<void> clearMainGoal() async {
    try {
      await _prefs!.remove(_mainGoalKey);
      log('StorageService: Main goal cleared');
    } catch (e) {
      log('StorageService: Error clearing main goal: $e');
    }
  }

  // Clear profile image from SharedPreferences
  Future<void> clearProfileImage() async {
    try {
      await _prefs!.remove('profile_image');
      log('StorageService: Profile image cleared');
    } catch (e) {
      log('StorageService: Error clearing profile image: $e');
    }
  }
}
