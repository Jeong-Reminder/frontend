import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAPI {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  late PersistCookieJar cookieJar;
  static const loginAddress = 'https://reminder.sungkyul.ac.kr/login';
  static const tokenRefreshAddress =
      'https://reminder.sungkyul.ac.kr/api/v1/reissue';
  static const logoutAddress = 'https://reminder.sungkyul.ac.kr/api/v1/logout';
  static const changePasswordAddress =
      'https://reminder.sungkyul.ac.kr/api/v1/member/changePassword';

  // static const loginAddress = 'http://10.0.2.2:9000/login';
  // static const tokenRefreshAddress = 'http://10.0.2.2:9000/api/v1/reissue';
  // static const logoutAddress = 'http://10.0.2.2:9000/api/v1/logout';
  // static const changePasswordAddress =
  //     'http://10.0.2.2:9000/api/v1/member/changePassword';

  // static const loginAddress = 'http://172.30.1.8:9000/login';
  // static const tokenRefreshAddress = 'http://172.30.1.8:9000/api/v1/reissue';
  // static const logoutAddress = 'http://172.30.1.8:9000/api/v1/logout';

  // static const loginAddress = 'http://127.0.0.1:9000/login';
  // static const tokenRefreshAddress = 'http://127.0.0.1:9000/api/v1/reissue';
  // static const logoutAddress = 'http://127.0.0.1:9000/api/v1/logout';
  // static const changePasswordAddress =
  //     'http://127.0.0.1:9000/api/v1/member/changePassword';

  LoginAPI() {
    _initCookieJar();
  }

  // 쿠키 관리를 위한 초기화 함수
  Future<void> _initCookieJar() async {
    final appDocDir =
        await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리 경로 가져오기
    final appDocPath = appDocDir.path; // 디렉토리 경로 저장
    print('쿠키 저장 경로: $appDocPath/.cookies/'); // 디버그 출력
    cookieJar = PersistCookieJar(
      storage: FileStorage('$appDocPath/.cookies/'), // 파일 저장소로 쿠키 저장
    );
  }

  // refreshToken 추출 메서드
  String? extractRefreshToken(String setCookieHeader) {
    final regex = RegExp(r'refresh=([^;]+)');
    final match = regex.firstMatch(setCookieHeader);
    return match?.group(1);
  }

  // 저장된 학번과 비밀번호 불러오기
  Future<Map<String, dynamic>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('studentId');
    final name = prefs.getString('name'); // 이름 불러오기
    final status = prefs.getString('status'); // 상태 불러오기
    final password = prefs.getString('password');
    final autoLogin = prefs.getBool('isAutoLogin') ?? false;
    final level = prefs.getInt('level');
    final userRole = prefs.getString('userRole');
    final memberId = prefs.getInt('memberId');

    return {
      'studentId': studentId,
      'name': name, // 이름 추가
      'status': status, // 상태 추가
      'password': password,
      'isAutoLogin': autoLogin,
      'level': level,
      'userRole': userRole,
      'memberId': memberId,
    };
  }

  // 이전 토큰 삭제 함수
  Future<void> clearTokens({bool removeRefreshToken = true}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    if (removeRefreshToken) {
      await prefs.remove('refreshToken');
      await cookieJar.deleteAll(); // 쿠키 삭제
    }
  }

  // 앱 종료 시 로그아웃 호출
  Future<void> logoutOnExit() async {
    final prefs = await SharedPreferences.getInstance();
    final isAutoLogin = prefs.getBool('isAutoLogin') ?? false;

    if (!isAutoLogin) {
      await logout();
    }
  }

  // 토큰 재발급 API
  Future<bool> againToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken') ?? '';

      if (refreshToken.isEmpty) {
        print('invalid refresh token');
        return false;
      }

      final url = Uri.parse(tokenRefreshAddress);
      final cookieHeader = 'refresh=$refreshToken';

      final response = await http.post(url, headers: {
        'Cookie': cookieHeader,
      });

      print('토큰 재발급 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final newAccessToken = response.headers['access'];
        final setCookieHeader = response.headers['set-cookie'];
        print('새로운 엑세스 토큰 $newAccessToken');

        final newRefreshToken = setCookieHeader != null
            ? extractRefreshToken(setCookieHeader)
            : null;
        print('새로운 리프래시 토큰 $newRefreshToken');

        if (newAccessToken != null && newRefreshToken != null) {
          await clearTokens(removeRefreshToken: false);

          await prefs.setString('accessToken', newAccessToken);
          await prefs.setString('refreshToken', newRefreshToken);

          final uri = Uri.parse(tokenRefreshAddress);
          cookieJar.saveFromResponse(uri, [Cookie('refresh', newRefreshToken)]);
        } else {
          print('응답 데이터에 토큰이 없습니다');
          return false;
        }

        print('토큰 재발급 성공!');
        return true;
      } else {
        print('토큰 재발급 실패: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('토큰 재발급 요청 중 에러 발생: ${e.toString()}');
      return false;
    }
  }

  // 로그인 API
  Future<Map<String, dynamic>> handleLogin(BuildContext context,
      String studentId, String password, String fcmToken) async {
    try {
      final url = Uri.parse(loginAddress);

      // HTTP POST 요청 전송
      final response = await http.post(
        url,
        body: {
          'studentId': studentId,
          'password': password,
          'fcmToken': fcmToken,
        },
      );

      print('로그인 응답 상태 코드: ${response.statusCode}');
      print('로그인 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userRole = responseData['userRole'];
        final techStack = responseData['techStack'];
        final memberExperience = responseData['memberExperiences'];
        final name = responseData['name'];
        final status = responseData['status'];
        final level = responseData['level'];

        final accessToken = response.headers['access']; // 액세스 토큰 추출
        final setCookieHeader = response.headers['set-cookie'];
        final refreshToken = setCookieHeader != null
            ? extractRefreshToken(setCookieHeader)
            : null;

        final prefs = await SharedPreferences.getInstance();
        if (accessToken != null && refreshToken != null) {
          // 이전 토큰 삭제
          await clearTokens(removeRefreshToken: false);

          // 새 토큰 저장
          await prefs.setString('accessToken', accessToken); // 액세스 토큰 저장
          await prefs.setString('refreshToken', refreshToken); // 리프레시 토큰 저장
          await prefs.setString('studentId', studentId); // 학번 저장
          await prefs.setString('name', name); // 이름 저장
          await prefs.setString('status', status); // 재적상태 저장
          await prefs.setInt('level', level);

          // techStack이 비어있지 않을 때(사용자일 경우) 사용자 아이디를 추출해서 저장
          if (techStack != null) {
            final memberId = responseData['techStack']['memberId'];
            await prefs.setInt('memberId', memberId); // 사용자 아이디 저장
          }

          final uri = Uri.parse(loginAddress);
          cookieJar.saveFromResponse(
              uri, [Cookie('refresh', refreshToken)]); // refreshToken 쿠키 저장

          // 저장된 토큰 로그로 확인
          final savedAccessToken = prefs.getString('accessToken');
          final savedRefreshToken = prefs.getString('refreshToken');
          final savedStudentId = prefs.getString('studentId');
          final savedName = prefs.getString('name');
          final savedStatus = prefs.getString('status');
          final savedLevel = prefs.getInt('level');
          final savedMemberId = prefs.getInt('memberId');

          print('저장된 액세스 토큰: $savedAccessToken');
          print('저장된 리프레시 토큰: $savedRefreshToken');
          print('저장된 학번: $savedStudentId');
          print('저장된 이름: $savedName');
          print('저장된 상태: $savedStatus');
          print('저장된 학년: $savedLevel');
          print('저장된 사용자 아이디: $savedMemberId');

          // memberExperience 배열에서 id 값 추출하여 저장
          final memberExperienceIds = (memberExperience as List)
              .map((exp) => (exp['id'] as int).toString()) // int를 String으로 변환
              .toList();
          await prefs.setStringList('memberExperienceIds', memberExperienceIds);
          print('저장된 memberExperience id: $memberExperienceIds');
        }
        print('로그인 성공');

        return {
          'success': true,
          'accessToken': accessToken,
          'role': userRole,
          'techStack': techStack,
          'memberExperiences': memberExperience,
        };
      } else {
        print('로그인 실패: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
        };
      }
    } catch (e) {
      print('로그인 요청 중 에러 발생: ${e.toString()}');
      return {
        'success': false,
      };
    }
  }

  // 로그아웃 API
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken') ?? '';

      if (refreshToken.isEmpty) {
        print('invalid refresh token');
        return false;
      }

      final url = Uri.parse(logoutAddress);
      final cookieHeader = 'refresh=$refreshToken';

      final response = await http.post(url, headers: {
        'Cookie': cookieHeader,
      });

      print('로그아웃 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        await clearTokens();

        final isAutoLogin = prefs.getBool('isAutoLogin') ?? false;

        // 자동 로그인이 체크되지 않은 경우 리프레시 토큰도 삭제
        if (!isAutoLogin) {
          await prefs.remove('refreshToken');
          print('자동 로그인 체크 안됨: 리프레시 토큰 삭제');
        }

        print('로그아웃 성공');
        return true;
      } else {
        print('로그아웃 실패: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('로그아웃 요청 중 에러 발생: ${e.toString()}');
      return false;
    }
  }

  // 비밀번호 변경 API
  Future<bool> changePassword(
      String studentId, String password, String newPassword) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Access token을 찾을 수 없습니다.');
      }

      final url = Uri.parse(changePasswordAddress);

      final response = await http.put(
        url,
        headers: {
          'access': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'studentId': studentId,
          'password': password,
          'newPassword': newPassword,
        }),
      );

      print('비밀번호 변경 요청 바디: ${jsonEncode({
            'studentId': studentId,
            'password': password,
            'newPassword': newPassword,
          })}');
      print('비밀번호 변경 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print('비밀번호 변경 성공 : $responseData');
        return true;
      } else {
        print('비밀번호 변경 실패: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('비밀번호 변경 요청 중 에러 발생: ${e.toString()}');
      return false;
    }
  }
}
