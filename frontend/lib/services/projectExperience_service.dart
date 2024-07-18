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

  // 내 프로젝트 경험 조회 API
  Future<List<ProjectExperience>> fetchExperiences() async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/member-experience';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: <String, String>{
        'access': accessToken,
      },
    );

    // 응답 데이터를 UTF-8로 디코딩하고 JSON 형식으로 변환
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      // 응답 데이터에서 'data' 필드를 가져와서 리스트로 변환
      List<ProjectExperience> fetchExperiences = (responseData['data'] as List)
          .map((projectExperienceData) =>
              ProjectExperience.fromJson(projectExperienceData))
          .toList();

      print("내 프로젝트 경험 조회 성공: $fetchExperiences");
      return fetchExperiences;
    } else {
      print("내 프로젝트 경험 조회 실패");
      return [];
    }
  }
}
