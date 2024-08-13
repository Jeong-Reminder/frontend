import 'package:flutter/material.dart';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/services/makeTeam_service.dart';

class MakeTeamProvider with ChangeNotifier {
  final MakeTeamService service = MakeTeamService();

  List<MakeTeam> makeTeams = [];

  final List<Map<String, dynamic>> _applyList = [];

  List<Map<String, dynamic>> get applyList => _applyList;

  Future<List<MakeTeam>> getMakeTeam() async {
    return makeTeams;
  }

  // 팀원 모집글 작성
  Future<void> createMakeTeam(MakeTeam makeTeam) async {
    try {
      int id = await service.createMakeTeam(makeTeam);
      print('Set ID: $id'); // 추가된 디버깅 코드
      makeTeam.id = id; // MakeTeam 객체에 ID 설정
      makeTeams.add(makeTeam);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀원 모집글 수정
  Future<void> updateMakeTeam(MakeTeam makeTeam) async {
    try {
      int? id = await service.getId(); // SharedPreferences에서 ID 가져오기
      if (id == null) {
        throw Exception('저장된 MakeTeam ID를 찾을 수 없습니다.');
      }
      makeTeam.id = id; // MakeTeam 객체에 ID 설정

      // 서비스 호출하여 팀원 모집글 수정
      await service.updateMakeTeam(makeTeam);
      makeTeams.add(makeTeam);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀원 모집글 조회
  Future<void> fetchMakeTeam() async {
    try {
      final applies = await service.fetchMakeTeam();

      _applyList.clear();

      for (var apply in applies) {
        _applyList.add(apply);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
