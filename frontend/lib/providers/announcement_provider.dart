import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/board_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class AnnouncementProvider with ChangeNotifier {
  late Board _board;

  Board get board => _board;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // accessToken 키로 저장된 문자열 값을 가져옴
  }

  final String baseUrl = 'http://10.0.2.2:9000/api/v1/announcement';

  Future<int> createBoard(
      Board board, List<File> pickedImages, List<File> pickedFiles) async {
    final accessToken = await getToken();
    if (accessToken == null) {
      throw Exception('엑세스 토큰을 찾을 수 없음');
    }

    final url = Uri.parse(baseUrl);
    final boardInfo = http.MultipartRequest('POST', url);

    // 엑세스 토큰 추가
    boardInfo.headers['access'] = accessToken;

    // 텍스트 데이터 추가
    boardInfo.fields['announcementCategory'] = board.announcementCategory!;
    boardInfo.fields['announcementTitle'] = board.announcementTitle!;
    boardInfo.fields['announcementContent'] = board.announcementContent!;
    boardInfo.fields['announcementImportant'] =
        board.announcementImportant.toString();
    boardInfo.fields['visible'] = board.visible.toString();
    boardInfo.fields['announcementLevel'] = board.announcementLevel.toString();

    // 이미지 파일 추가
    if (pickedImages.isNotEmpty) {
      for (var img in pickedImages) {
        var multipartFile = await http.MultipartFile.fromPath(
          'img',
          img.path,
          filename: path.basename(img.path),
        );
        boardInfo.files.add(multipartFile);
      }
    }

    // 일반 파일 추가
    if (pickedFiles.isNotEmpty) {
      print('pickedFiles: $pickedFiles');
      for (var file in pickedFiles) {
        var bytes = await file.readAsBytes();

        var multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: path.basename(file.path),
        );
        boardInfo.files.add(multipartFile);
      }
    }

    try {
      final response = await boardInfo.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(responseString);

        print('작성 성공: $responseBody');
        _board = Board.fromJson(responseBody['data']);
        print(_board);
        notifyListeners();

        return _board.id!;
      } else {
        print('작성 실패: ${response.statusCode} - $responseString');
        throw Exception();
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception();
    }
  }
}
