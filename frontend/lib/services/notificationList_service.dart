import 'dart:convert';
import 'package:frontend/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationListService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // 회원별 알림 조회
  Future<List<NotificationModel>> fetchNotification() async {
    const String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/notifications';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'access': token,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final dataResponse = jsonResponse['data'];

      List<NotificationModel> notificationList = []; // 응답 데이터를 담을 알림 리스트 변수

      for (var data in dataResponse) {
        notificationList.add(
            NotificationModel.fromJson(data)); // fromJson 메서드를 통해 Map로 변환 후 저장
      }

      print('회원별 알림 조회 성공: $dataResponse');
      return notificationList;
    } else {
      throw Exception('팀원 모집글 작성 실패: ${response.body}');
    }
  }
}
