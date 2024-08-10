import 'dart:convert';
import 'dart:io';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  // 회원 추가 API
  Future<void> createUser(Admin admin) async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/admin/admin-insert';
    const String baseUrl = 'http://localhost:9000/api/v1/admin/admin-insert';

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
      body: jsonEncode(admin.toJson()),
    );

    if (response.statusCode == 200) {
      // 성공 처리
      print('회원 추가 성공');
      print('회원 목록: ${response.body}');
    } else {
      // 실패 처리
      throw Exception('회원 추가 실패: ${response.body}');
    }
  }

  // 엑셀로 member 업데이트 API
  Future<void> updateMember(File file) async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/admin/member-update';
    const String baseUrl = 'http://localhost:9000/api/v1/admin/member-update';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    // 파일이 존재하지 않으면 에러 발생
    if (!await file.exists()) {
      throw Exception('해당 경로의 파일을 찾을 수 없음: ${file.path}');
    }

    final url = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', url);

    request.headers['access'] = accessToken;

    // 선택한 파일명 생성
    final fileName = path.basename(file.path);

    // 파일 내용을 바이트 배열로 읽어옴
    final fileBytes = await file.readAsBytes();

    // 파일을 요청 바디에 추가
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    ));

    // 요청 전송, 응답
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      print('성공');
      print('responseBody: ${data['data']}');

      // 응답 데이터를 가져와 updatedAdmins에 저장
      List<Admin> updatedAdmins = (data['data'] as List)
          .map((adminData) => Admin.fromJson(adminData))
          .toList();

      print('파일안의 회원정보들: $updatedAdmins');
    } else {
      print('실패: ${response.statusCode} - $responseBody');
    }
  }

  // member 전체 조회 API
  Future<List<Admin>> fetchMembers() async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/admin/members-get';
    const String baseUrl = 'http://localhost:9000/api/v1/admin/members-get';

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
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      // 응답 데이터를 가져와 updatedAdmins에 저장
      List<Admin> updatedAdmins = (responseData['data'] as List)
          .map((adminData) => Admin.fromJson(adminData))
          .toList();

      print("조회 성공: $updatedAdmins");
      return updatedAdmins;
    } else {
      print("조회 실패");
      return [];
    }
  }

  // member 삭제 API
  Future<void> deleteMembers(List<String> studentIds) async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/admin/member-delete';
    const String baseUrl = 'http://localhost:9000/api/v1/admin/member-delete';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': accessToken,
      },
      body: jsonEncode(studentIds),
    );

    if (response.statusCode == 200) {
      print('회원 삭제 성공');
    } else {
      print('회원 삭제 실패: ${response.statusCode}');
      throw Exception('회원 삭제 실패: ${response.body}');
    }
  }

  // 회원 정보 수정 API 호출
  Future<void> editMember(Admin admin) async {
    // const String baseUrl =
    //     'https://reminder.sungkyul.ac.kr/api/v1/admin/member-update';
    const String baseUrl = 'http://localhost:9000/api/v1/admin/member-update';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse(baseUrl);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': accessToken,
      },
      body: jsonEncode(admin.toJson()),
    );

    if (response.statusCode == 200) {
      print('회원 수정 성공: $admin');
    } else {
      print('회원 수정 실패: ${response.statusCode} - ${response.body}');
    }
  }
}
