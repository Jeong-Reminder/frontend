import 'dart:convert';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectExperienceService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<String>> getMemberExperienceIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('memberExperienceIds') ?? [];
  }

  // 프로젝트 경험 추가 API
  Future<void> createProjectExperience(
      ProjectExperience projectExperience) async {
    const String baseUrl = 'http://127.0.0.1:9000/api/v1/member-experience';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(projectExperience.toJson()),
    );

    final responseData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('프로젝트 경험 추가 성공');
      print('프로젝트 경험 목록: $responseData');
    } else {
      throw Exception('프로젝트 경험 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  // 프로젝트 경험 여러개 추가 API
  Future<void> createProjectExperiences(
      List<ProjectExperience> projectExperiences) async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/member-experience/list';
    const String baseUrl =
        'http://127.0.0.1:9000 /api/v1/member-experience/list';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(projectExperiences.map((e) => e.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      print('프로젝트 경험 여러 개 추가 성공');
      print('프로젝트 경험 목록: ${utf8.decode(response.bodyBytes)}');
    } else {
      throw Exception('프로젝트 경험 여러 개 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  // 내 프로젝트 경험 조회 API
  Future<List<ProjectExperience>> fetchExperiences() async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/member-experience';
    const String baseUrl = 'http://127.0.0.1:9000/api/v1/member-experience';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: <String, String>{
        'access': accessToken,
      },
    );

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
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

  // 프로젝트 경험 수정 API
  Future<void> updateProjectExperience(
      ProjectExperience projectExperience) async {
    final int? id = projectExperience.id; // projectExperience 객체에서 id를 추출
    if (id == null) {
      throw Exception('프로젝트 경험 ID가 존재하지 않습니다.');
    }

    // final baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/member-experience/$id';
    final baseUrl = 'http://127.0.0.1:9000/api/v1/member-experience/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final experienceIds = await getMemberExperienceIds();

    // 디버깅: experienceIds와 id 출력
    print('경험 ID 리스트: $experienceIds');
    print('수정하려는 ID: $id');

    // 경험 ID가 리스트에 포함되어 있는지 확인
    if (!experienceIds.contains(id.toString())) {
      throw Exception('유효하지 않은 경험 ID: $id');
    }

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(projectExperience.toJson()),
    );

    if (response.statusCode == 200) {
      print('프로젝트 경험 수정 성공');
      print('수정된 프로젝트 경험: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 디버깅 용도로 응답을 출력
      print(
          '프로젝트 경험 수정 실패: ${utf8.decode(response.bodyBytes)}, ${response.statusCode}');
      throw Exception('프로젝트 경험 수정 실패');
    }
  }
}
