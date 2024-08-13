import 'dart:convert';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakeTeamService {
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

  // 팀원 모집글 작성 API
  Future<int> createMakeTeam(MakeTeam makeTeam) async {
    const String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment';

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

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      print('팀원 모집글 작성 성공');
      print('responseData: $responseData');
      int id = responseData['data']['id']; // 백엔드에서 반환된 id 추출
      print('Returned ID: $id'); // 반환된 id 출력

      await saveId(id); // 반환된 ID를 SharedPreferences에 저장

      return id;
    } else {
      throw Exception('팀원 모집글 작성 실패: ${response.body}');
    }
  }

  // 팀원 모집글 아이디로 조회 API
  Future<List<Map<String, dynamic>>> fetchMakeTeam() async {
    final int? id = await getId();
    if (id == null) {
      throw Exception('저장된 MakeTeam ID를 찾을 수 없습니다.');
    }
    final String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final dataResponse = responseData['data'];
      final List<dynamic> applyResponse = dataResponse['teamApplicationList'];

      print('팀원 모집글 조회 성공: $applyResponse');

      return applyResponse.map((item) => item as Map<String, dynamic>).toList();
    } else {
      print('팀원 모집글 조회 실패: ${response.body}');
      throw Exception();
    }
  }

  // 팀원 모집글 수정 API
  Future<void> updateMakeTeam(MakeTeam makeTeam) async {
    final int? id = await getId();
    if (id == null) {
      throw Exception('저장된 MakeTeam ID를 찾을 수 없습니다.');
    }
    final String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    // id를 제외한 요청 바디 생성
    final requestBody = makeTeam.toJson();
    requestBody.remove('id');

    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(requestBody),
    );

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      print('팀원 모집글 수정 성공');
      print('responseData: $responseData');
    } else {
      throw Exception('팀원 모집글 수정 실패: ${response.body}');
    }
  }
}
