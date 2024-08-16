import 'dart:convert';
import 'package:frontend/models/teamApply_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeamApplyService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> saveId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('makeTeamId', id);
  }

  Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('makeTeamId');
  }

  // 팀원 신청글 작성 API
  Future<int> createTeamApply(TeamApply teamapply) async {
    final int? id = await getId();
    if (id == null) {
      throw Exception('저장된 모집글 ID를 찾을 수 없습니다.');
    }
    final String baseUrl =
        'http://127.0.0.1:9000/api/v1/recruitment/team-application/$id';
    // final String baseUrl =
    //     'http://10.0.2.2:9000/api/v1/recruitment/team-application/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    print('Request Body: ${jsonEncode(teamapply.toJson())}');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(teamapply.toJson()),
    );

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      // 서버 응답에서 필요한 데이터 추출
      final dataResponse = responseData['data'];

      // teamApplicationList가 null일 수 있으므로 null 체크 추가
      final List<dynamic> applyResponse =
          dataResponse['teamApplicationList'] ?? [];

      print('팀원 신청글 작성 성공 : $dataResponse');

      // teamApplicationList를 출력
      for (var application in applyResponse) {
        print('Application: ${jsonEncode(application)}');
      }

      // 서버 응답에서 id 추출 (응답 구조에 따라 수정)
      int applicationId = dataResponse['id'];

      return applicationId;
    } else {
      throw Exception('팀원 신청글 작성 실패: ${response.body}');
    }
  }
}
