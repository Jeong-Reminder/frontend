import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VoteProvider with ChangeNotifier {
  final List<Vote> _voteList = [];
  final List<Map<String, dynamic>> _contentList = [];

  List<Vote> get voteList => _voteList;
  List<Map<String, dynamic>> get contentList => _contentList;

  // 엑세스 토큰 할당
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  final String baseUrl = 'http://10.0.2.2:9000/api/v1/votes/';
  // final String baseUrl = 'http://127.0.0.1:9000/api/v1/votes/';

  // 투표 생성
  Future<void> createVote(Vote vote) async {
    try {
      final accessToken = await getToken();
      if (accessToken == null) {
        throw Exception('엑세스 토큰을 찾을 수 없음');
      }

      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'access': accessToken,
        },
        body: jsonEncode(vote.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);

        final dataResponse = jsonResponse['data'];
        print('투표 생성 성공: $dataResponse');
      } else {
        print('투표 생성 실패: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // 투표 항목 추가
  Future<void> addVoteItem(int voteId, String content) async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('$baseUrl$voteId/items');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'access': accessToken,
      },
      body: jsonEncode({'content': content}), // JSON 형식으로 데이터를 전달
    );

    final utf8Response = utf8.decode(response.bodyBytes);

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(utf8Response);
      final dataResponse = jsonResponse['data'];

      _contentList.add(dataResponse);
      notifyListeners();

      // 투표 항목 추가 후 해당 투표 항목을 다시 조회하여 UI 갱신
      await fetchVote(voteId);
      print('투표 항목 추가 성공: $_contentList');
    } else {
      print('투표 항목 추가 실패: ${response.statusCode} - $utf8Response');
    }
  }

  // 투표 조회
  Future<void> fetchVote(int voteId) async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('$baseUrl$voteId');
    final response = await http.get(
      url,
      headers: {
        'access': accessToken,
      },
    );

    _voteList.clear();

    if (response.statusCode == 200) {
      final utf8Response = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(utf8Response);

      final dataResponse = jsonResponse['data'];

      if (dataResponse is List) {
        // dataResponse가 List일 경우 각각의 item을 Vote 객체로 변환
        for (var data in dataResponse) {
          _voteList.add(Vote.fromJson(data));
        }
      } else if (dataResponse is Map<String, dynamic>) {
        // dataResponse가 Map일 경우 직접 Vote 객체로 변환하여 추가
        _voteList.add(Vote.fromJson(dataResponse));
      }
      print('투표 조회 성공: $_voteList');
    } else {
      print("투표 조회 실패: ${response.body}");
    }
  }

  // 투표하기
  Future<void> vote(int voteId, int voteItemId) async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('$baseUrl$voteId/vote/$voteItemId');
    final response = await http.post(
      url,
      headers: {
        'access': accessToken,
      },
    );

    if (response.statusCode == 200) {
      print('투표 성공: ${response.body}');
    } else {
      print('투표 실패: ${response.statusCode} - ${response.body}');
    }
  }

  // 투표 항목 강제 삭제
  Future<void> deleteVoteItem(int voteItemId) async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse('${baseUrl}items/$voteItemId');
    final response = await http.delete(
      url,
      headers: {
        'access': accessToken,
      },
    );

    if (response.statusCode == 204) {
      // 응답데이터 수정되면 작성 예정

      print('투표 항목 강제 삭제 성공');
    } else {
      print('투표 항목 강제 삭제 실패');
    }
  }
}
