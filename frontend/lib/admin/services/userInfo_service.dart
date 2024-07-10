import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class UserService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  // 회원 추가 API
  Future<void> createUser(Admin admin) async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/admin/admin-insert';

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
      final responseData = response.body;

      // 성공 처리
      print('회원 추가 성공');
      print('회원 목록: ${response.body}');
    } else {
      // 실패 처리
      throw Exception('회원 추가 실패: ${response.body}');
    }
  }

  Future<void> updateMember(List<File> files) async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/admin/member-update';

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', url);

    request.headers['access'] = accessToken;

    // 선택한 파일 추가
    for (var file in files) {
      // 파일명 생성
      final fileName = path.basename(file.path);

      // 파일 내용을 바이트 배열로 읽어옴
      final fileBytes = await file.readAsBytes();

      // 파일을 요청에 추가합니다.
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));

      // 요청 전송, 응답
      final response = await request.send();

      if (response.statusCode == 200) {
        print('성공');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('실패: ${response.statusCode} - $responseBody');
      }
    }
  }
}
