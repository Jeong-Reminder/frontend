import 'package:flutter/material.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:frontend/admin/services/userInfo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider with ChangeNotifier {
  final UserService _apiService = UserService();
  List<Admin> admins = [];

  List<Admin> get users => admins;

  Future<void> addUser(Admin admin) async {
    try {
      await _apiService.createUser(admin);
      admins.add(admin);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token); // access token 키 저장
    notifyListeners();
  }
}
