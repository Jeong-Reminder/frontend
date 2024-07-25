import 'dart:convert';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakeTeamService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // 팀원 모집글 작성 API
  Future<void> createMakeTeam(MakeTeam makeTeam) async {
    const String baseUrl = 'https://reminder.sungkyul.ac.kr/api/v1/recruitment';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    print('Request Body: ${jsonEncode(makeTeam.toJson())}');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(makeTeam.toJson()),
    );

    final responseData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('팀원 모집글 작성 성공');
      print('팀원 모집글 목록: $responseData');
    } else {
      throw Exception('팀원 모집글 작성 실패: ${response.body}');
    }
  }
}
