import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      'https://reminder.sungkyul.ac.kr/api/v1/admin/admin-insert';

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  Future<void> createUser(Admin admin) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No access token found: $token');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(admin.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = response.body;

      // 성공 처리
      print('회원 추가 성공');
      print('회원 목록: ${response.body}');
    } else {
      // 실패 처리
      throw Exception('회원 추가 실패: ${response.body}');
    }
  }
}
