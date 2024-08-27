import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:frontend/admin/services/userInfo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminProvider with ChangeNotifier {
  final UserService userService = UserService();

  List<Admin> admins = []; // Datatable에 표시할 회원 정보 리스트

  // 학생들 정보를 담는 메소드를 호출(그래야만 학생들 정보를 admins에 담고 반환할 수 있음)
  // admins 반환
  // 순서 : userInfo_screen에서 getMembers -> fetchMembers or createUser -> getMembers로 가서 admins 리턴
  Future<List<Admin>> getMembers() async {
    // 수정, 삭제 혹은 추가로 DB나 응답데이터에서 바뀐 admin를 가져옴
    await fetchMembers();
    return admins;
  }

  // 엑세스 토큰 할당
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  final String baseUrl = 'http://10.0.2.2:9000/api/v1/admin/';
  // final String baseUrl = 'http://127.0.0.1:9000/api/v1/admin//';

  // 회원 추가
  Future<void> createUser(Admin admin) async {
    try {
      await userService.createUser(admin); // 회원 추가 API를 호출

      // 회원 정보 리스트(admins)에 추가
      // 그 후에 getMembers 메소드를 통해 업데이트된 admins를 반환해서 화면에 표시
      admins.add(admin);
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      print(e);
    }
  }

  // 응답 데이터에 있는 정보들을 담은 엑셀로 member 업데이트 api를 가져와 위에서 선언한 admins 리스트에 저장
  // 상태 변경 알림 호출(notifyListeners)
  Future<void> fetchMembers() async {
    // 회원 정보 리스트를 받는 updateMember를 불러와 updatedAdmins에 저장 후 admins에 저장
    // 추가, 삭제 혹은 수정으로 인해 업데이트될 때 admin도 그거에 맞게 바뀜
    // 그 후에 getMembers 메소드를 통해 업데이트된 admins를 반환해서 화면에 표시
    List<Admin> updatedAdmins = await userService.fetchMembers();
    admins = updatedAdmins;
    notifyListeners(); // 상태 변경 알림
  }

  // 회원 삭제
  Future<void> deleteMembers(List<String> studentIds) async {
    await userService.deleteMembers(studentIds);

    // 선택된 회원정보의 학번이 전체 회원정보의 학번에 포함되어 있으면 해당 회원은 삭제하고 admin 상태 변경
    // 그 후에 getMembers 메소드를 통해 업데이트된 admins를 반환해서 화면에 표시
    admins.removeWhere((admin) => studentIds.contains(admin.studentId));
    notifyListeners();
  }

  // 회원 수정 로직
  Future<void> editMemberProvider(Admin admin) async {
    try {
      await userService.editMember(admin);

      // 현재 admins 리스트 출력
      print("현재 admins 리스트:");
      for (var i = 0; i < admins.length; i++) {
        print(
            "Index $i: studentId: ${admins[i].studentId}, name: ${admins[i].name}");
      }

      // 수정된 회원 정보 출력
      print(
          "수정된 회원 정보: studentId: ${admin.studentId}, name: ${admin.name}, level: ${admin.level}, status: ${admin.status}, userRole: ${admin.userRole}");

      // 전체 리스트의 학번과 해당 회원의 학번과 동일한 요소의 index를 가져와 수정된 admin을 admins 리스트에 저장해 수정
      int index = admins.indexWhere((a) => a.studentId == admin.studentId);
      if (index != -1) {
        admins[index] = admin;
        print('수정된 회원 정보 인덱스: $index');
        notifyListeners();
      }

      // 수정 후 admins 리스트 출력
      print("수정 후 admins 리스트:");
      for (var i = 0; i < admins.length; i++) {
        print(
            "Index $i: studentId: ${admins[i].studentId}, name: ${admins[i].name}");
      }
    } catch (e) {
      print("회원 수정 오류: $e");
    }
  }

  Future<void> setAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token); // access token 키 저장
    notifyListeners();
  }

  // recruitment 전체 삭제
  Future<void> deleteAllRecruitments() async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('${baseUrl}recruitment-delete-all');
    final response = await http.delete(
      url,
      headers: {'access': accessToken},
    );

    if (response.statusCode == 200) {
      print('모집글 전체 삭제 성공: ${response.body}');
    } else {
      print('모집글 전체 삭제 실패: ${response.body}');
    }
  }

  // recruitment 카테고리 별 삭제
  Future<void> deleteCateRecruitment(String contestCate) async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('${baseUrl}recruitment-delete?category=$contestCate');
    final response = await http.delete(
      url,
      headers: {'access': accessToken},
    );

    if (response.statusCode == 200) {
      print('카테고리 별 삭제 성공: ${response.body}');
    } else {
      print('카테고리 별 삭제 실패: ${response.body}');
    }
  }

  // 팀 전제 초회
  Future<void> fetchAllTeams() async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('${baseUrl}team-get');
    final response = await http.get(
      url,
      headers: {'access': accessToken},
    );

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(utf8Response);
      final dataResponse = jsonResponse['data'];
      print('팀 전체 조회 성공: $dataResponse');
    } else {
      print('팀 전체 조회 실패: ${response.body}');
    }
  }
}
