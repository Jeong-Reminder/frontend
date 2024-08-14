import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecommendProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _recommendList = [];

  List<Map<String, dynamic>> get recommendList => _recommendList;

// 엑세스 토큰 할당
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  final String baseUrl = 'http://10.0.2.2:9000/api/v1/recommend/';
  // final String baseUrl = 'http://127.0.0.1:9000/api/v1/recommend/';

  // 추천
  Future<bool> recommend(int announcementId) async {
    try {
      final accessToken = await getToken();
      if (accessToken == null) {
        throw Exception('엑세스 토큰을 찾을 수 없음');
      }

      final url = Uri.parse('$baseUrl$announcementId/toggle');
      final response = await http.post(
        url,
        headers: {
          'access': accessToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'announcementId': announcementId}),
      );

      final dataResponse = json.decode(response.body)['data'];

      if (response.statusCode == 200) {
        print('추천 성공: $dataResponse');

        return dataResponse['status'];
      } else {
        print('추천 실패');
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }

  // 추천 조회
  Future<void> fetchRecommend() async {
    try {
      final accessToken = await getToken();
      if (accessToken == null) {
        throw Exception('엑세스 토큰을 찾을 수 없음');
      }

      final url = Uri.parse('${baseUrl}my-recommends');
      final response = await http.get(
        url,
        headers: {
          'access': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = json.decode(utf8Response);

        final dataResponse = jsonResponse['data'];
        for (var data in dataResponse) {
          _recommendList.add(data);
        }
        notifyListeners();
        print('추천 조회 성공: $dataResponse');
      } else {
        print('추천 조회 실패: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
