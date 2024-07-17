import 'dart:convert';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectExperienceService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  // 프로젝트 경험 추가 API
  Future<void> createProjectExperience(
      ProjectExperience projectExperience) async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/member-experience';

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
      body: jsonEncode(projectExperience.toJson()), // 인스턴스를 사용하여 toJson 메서드를 호출
    );

    if (response.statusCode == 200) {
      // 성공 처리
      print('프로젝트 경험 추가 성공');
      print('프로젝트 경험 목록: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      throw Exception('프로젝트 경험 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  // 프로젝트 경험 여러개 추가 API
  Future<void> createProjectExperiences(
      List<ProjectExperience> projectExperiences) async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/member-experience/list';

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
      body: jsonEncode(projectExperiences // ProjectExperience 객체의 리스트
          .map((e) => e.toJson()) // toJson 메서드를 호출하여 해당 객체를 JSON으로 변환
          .toList()), // JSON -> List 형식으로 변환
    );

    if (response.statusCode == 200) {
      // 성공 처리
      print('프로젝트 경험 여러 개 추가 성공');
      print('프로젝트 경험 목록: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      throw Exception('프로젝트 경험 여러 개 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
