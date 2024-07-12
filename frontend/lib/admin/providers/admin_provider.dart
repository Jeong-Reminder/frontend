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
  // 순서 : userInfo_screen에서 getMembers -> fetchMembers or createUser -> getMembers로 가서 admins 리턴
  Future<List<Admin>> getMembers() async {
    await fetchMembers();
    return admins;
  }

  // 회원 추가
  Future<void> createUser(Admin admin) async {
    try {
      await userService.createUser(admin); // 회원 추가 API를 호출
      admins.add(admin); // 회원 정보 리스트(admins)에 추가
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      print(e);
    }
  }

  // 응답 데이터에 있는 정보들을 담은 엑셀로 member 업데이트 api를 가져와 위에서 선언한 admins 리스트에 저장
  // 상태 변경 알림 호출(notifyListeners)
  Future<void> fetchMembers() async {
    // 회원 정보 리스트를 받는 updateMember를 불러와 updatedAdmins에 저장 후 admins에 저장
    List<Admin> updatedAdmins = await userService.fetchMembers();
    admins = updatedAdmins;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token); // access token 키 저장
    notifyListeners();
  }
}
