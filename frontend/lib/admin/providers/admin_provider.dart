import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:frontend/admin/services/userInfo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProvider with ChangeNotifier {
  final UserService userService = UserService();

  List<Admin> admins = []; // Datatable에 표시할 회원 정보 리스트

  // 학생들 정보를 담는 메소드를 호출(그래야만 학생들 정보를 admins에 담고 반환할 수 있음)
  // admins 반환
  // 순서 : userInfo_screen에서 getMembers -> updateMember -> getMembers로 가서 admins 리턴
  Future<List<Admin>> getMembers(File file) async {
    if (await file.exists()) {
      await updateMembers(file);
    } else {
      print('File not found: $file');
    }

    print("admins: $admins");
    return admins;
  }

  Future<void> addUser(Admin admin) async {
    try {
      await userService.createUser(admin);
      admins.add(admin);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 응답 데이터에 있는 정보들을 담은 엑셀로 member 업데이트 api를 가져와 위에서 선언한 admins 리스트에 저장
  // 상태 변경 알림 호출(notifyListeners)
  Future<void> updateMembers(File file) async {
    if (!await file.exists()) {
      throw Exception('File not found at path: ${file.path}');
    }

    // 회원 정보 리스트를 받는 updateMember를 불러와 updatedAdmins에 저장 후 admins에 저장
    final List<Admin> updatedAdmins = await userService.updateMember(file);
    admins = updatedAdmins;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token); // access token 키 저장
    notifyListeners();
  }
}
