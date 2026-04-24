import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/app_exception.dart';
import '../models/user_model.dart';

/// Local data source for authentication persistence
class AuthLocalDataSource {
  static const String _authBoxName = 'auth_cache';
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  /// Save user data locally
  Future<void> saveUser(UserModel user) async {
    try {
      final box = await Hive.openBox<String>(_authBoxName);
      await box.put(_userKey, jsonEncode(user.toJson()));
      if (user.token != null) {
        await box.put(_tokenKey, user.token!);
      }
    } catch (e) {
      throw const CacheException(message: 'Failed to save user data');
    }
  }

  /// Get cached user data
  Future<UserModel?> getUser() async {
    try {
      final box = await Hive.openBox<String>(_authBoxName);
      final json = box.get(_userKey);
      if (json == null || json.isEmpty) return null;
      return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get cached auth token
  Future<String?> getToken() async {
    try {
      final box = await Hive.openBox<String>(_authBoxName);
      return box.get(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save auth token
  Future<void> saveToken(String token) async {
    try {
      final box = await Hive.openBox<String>(_authBoxName);
      await box.put(_tokenKey, token);
    } catch (e) {
      throw const CacheException(message: 'Failed to save token');
    }
  }

  /// Clear all auth data (logout)
  Future<void> clearAuth() async {
    try {
      await Hive.deleteBoxFromDisk(_authBoxName);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear auth data');
    }
  }

  /// Check if user is authenticated locally
  Future<bool> isAuthenticated() async {
    try {
      final box = await Hive.openBox<String>(_authBoxName);
      return box.containsKey(_tokenKey);
    } catch (e) {
      return false;
    }
  }

  /// Save language preference
  Future<void> saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  /// Get saved language preference
  Future<String> getLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'en';
  }

  /// Save theme preference
  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
  }

  /// Get saved theme preference
  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark_mode') ?? false;
  }
}
