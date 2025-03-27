import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  int _age = 0;

  String get name => _name;
  int get age => _age;

  Future<void> setUserData(String name, int age) async {
    _name = name;
    _age = age;
    notifyListeners();

    // שמירת הנתונים ב-SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setInt('age', age);

    // הדפסת מה שנשמר
    print("Saved to SharedPreferences: Name = $name, Age = $age");
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _age = prefs.getInt('age') ?? 0;
    notifyListeners();
  }
}

class UserDataStorage {
  final _storage = GetStorage(); // Initialize get_storage for Web

  // פונקציה לשמירת שם משתמש
  Future<void> saveUserName(String name) async {
    if (kIsWeb) {
      // Web storage
      await _storage.write('userName', name);
    } else {
      // Native storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
    }
  }

  // פונקציה לשליפת שם המשתמש
  Future<String> getUserName() async {
    if (kIsWeb) {
      // Web storage
      return _storage.read('name') ?? 'ילד';
    } else {
      // Native storage
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('name') ?? 'ילד';
    }
  }

  // פונקציה לשמירת גיל המשתמש
  Future<void> saveUserAge(int age) async {
    if (kIsWeb) {
      await _storage.write('userAge', age);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userAge', age);
    }
  }

  // פונקציה לשליפת גיל המשתמש
  Future<int> getUserAge() async {
    if (kIsWeb) {
      return _storage.read('userAge') ?? 0;
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('userAge') ?? 0;
    }
  }
}
