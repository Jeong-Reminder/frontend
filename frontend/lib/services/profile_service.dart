import 'dart:convert';

import 'package:frontend/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  // 프로필 생성 API
  Future<void> createProfile(Profile profile) async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/member-profile';

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

    final responseData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('생성 성공: $responseData');

      final json = jsonDecode(responseData);
      final jsonData = json['data'];
      // final id = jsonData['memberId'];

      // return id;

      print('프로필 : $jsonData');
    } else {
      throw Exception('생성 실패: ${response.statusCode} - ${response.body}');
    }
  }

  // 프로필 조회 API
  Future<Map<String, dynamic>> fetchProfile(int memberId) async {
    final String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/member-profile/$memberId';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': accessToken,
      },
    );

    final responseData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      final json = jsonDecode(responseData);
      final jsonData = json['data'];

      print('조회 성공: $jsonData');
      return jsonData;
    } else {
      throw Exception('조회 실패: ${response.statusCode} - ${response.body}');
    }
  }
}
