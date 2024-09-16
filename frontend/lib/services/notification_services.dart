import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  Future<void> notification(
      Map<String, dynamic> notificationData, String fcmToken) async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/notifications/test-send';
    // const String baseUrl =
    //     'http://10.0.0.2:9000/api/v1/notifications/test-send';
    // const String baseUrl =
    //     'http://10.0.2.2:9000/api/v1/notifications/test-send';
    // const String baseUrl =
    //     'http://127.0.0.1:9000/api/v1/notifications/test-send';

    print('fcmToken: $fcmToken');

    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('$baseUrl?targetToken=$fcmToken');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': accessToken,
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      print('푸쉬 알림 성공: ${response.body}');
    } else {
      print('푸쉬 알림 실패: ${response.statusCode} - ${response.body}');
    }
  }
}
