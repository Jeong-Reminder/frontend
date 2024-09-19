import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FileProvider with ChangeNotifier {
  // 엑세스 토큰 할당
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  final String baseUrl = 'https://reminder.sungkyul.ac.kr/api/files/download';
  // final String baseUrl = 'http://10.0.2.2:9000/api/files/download';
  // final String baseUrl = 'http://127.0.0.1:9000/api/files/download';

  Future<bool> downloadFile(String baseUrl) async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('성공: ${response.bodyBytes}');

      return true;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
