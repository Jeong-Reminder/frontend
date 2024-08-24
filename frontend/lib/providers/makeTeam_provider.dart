import 'package:flutter/material.dart';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/services/makeTeam_service.dart';

class MakeTeamProvider with ChangeNotifier {
  final MakeTeamService service = MakeTeamService();

  List<MakeTeam> makeTeams = [];

  final List<Map<String, dynamic>> _applyList = [];
  final List<Map<String, dynamic>> _cateList = [];

  List<Map<String, dynamic>> get applyList => _applyList;
  List<Map<String, dynamic>> get cateList => _cateList;

  Future<List<MakeTeam>> getMakeTeam() async {
    return makeTeams;
  }

  // 팀원 모집글 작성
  Future<void> createMakeTeam(MakeTeam makeTeam) async {
    try {
      int id = await service.createMakeTeam(makeTeam);
      makeTeam.id = id;
      makeTeams.add(makeTeam);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀원 모집글 아이디로 조회
  Future<void> fetchMakeTeam() async {
    try {
      final applies = await service.fetchMakeTeam();

      _applyList.clear();
      _applyList.addAll(applies);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀원 모집글 공지글 아이디로 조회(카테고리 조회)
  Future<void> fetchcateMakeTeam(int id) async {
    try {
      // 서비스로부터 데이터를 받아옴
      final List<Map<String, dynamic>> fullDetails =
          await service.fetchCateMakeTeam(id);

      // 기존 리스트를 비우고 새 데이터를 추가
      _cateList.clear();
      _cateList.addAll(fullDetails);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀원 모집글 수정
  Future<void> updateMakeTeam(MakeTeam makeTeam) async {
    try {
      await service.updateMakeTeam(makeTeam);
      makeTeams.add(makeTeam);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
