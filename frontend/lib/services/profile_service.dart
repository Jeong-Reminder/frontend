import 'dart:convert';

import 'package:frontend/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  Future<void> createProfile(Profile profile) async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/member-profile';
    const String baseUrl = 'http://localhost:9000/api/v1/member-profile';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': accessToken,
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      print('생성 성공');
    } else {
      print('생성 실패: ${response.statusCode} - ${response.body}');
    }
  }
}
