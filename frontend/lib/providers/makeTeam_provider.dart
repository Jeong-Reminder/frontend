import 'package:flutter/material.dart';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/services/makeTeam_service.dart';

class MakeTeamProvider with ChangeNotifier {
  final MakeTeamService service = MakeTeamService();

  List<MakeTeam> makeTeams = [];

  final List<Map<String, dynamic>> _applyList = [];
  final List<Map<String, dynamic>> _cateList = [];
  final List<Map<String, dynamic>> _acceptMemberList = [];
  Map<String, dynamic> _recruitList = {};

  List<Map<String, dynamic>> get applyList => _applyList;
  List<Map<String, dynamic>> get cateList => _cateList;
  List<Map<String, dynamic>> get acceptMemberList => _acceptMemberList;
  Map<String, dynamic> get recruitList => _recruitList;

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
      // fetchMakeTeam 메서드에서 applyResponse와 acceptMemberList를 모두 가져옴
      final result = await service.fetchMakeTeam();

      // applyResponse와 acceptMemberList를 분리해서 처리
      final applies = result['applyResponse'] as List<Map<String, dynamic>>;
      final acceptMemberList = result['acceptMemberList'] as List<dynamic>;
      final data = result['data'] as Map<String, dynamic>;

      _applyList.clear();
      _applyList.addAll(applies);

      // acceptMemberList를 필요한 곳에서 처리
      // 예시: _acceptMemberList라는 내부 변수에 저장한다고 가정
      _acceptMemberList.clear();
      _acceptMemberList.addAll(acceptMemberList.cast<Map<String, dynamic>>());

      _recruitList.clear;
      _recruitList = data;

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

  // 팀원 모집글 삭제
  Future<void> deleteMakeTeam() async {
    try {
      await service.deleteMakeTeam(); // 서비스에서 팀원 모집글 삭제
      // 삭제된 팀원 모집글을 리스트에서 제거
      int? id = await service.getId(); // 저장된 팀원 모집글 ID를 가져옴
      if (id != null) {
        makeTeams.removeWhere((team) => team.id == id);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
