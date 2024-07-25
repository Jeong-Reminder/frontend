import 'package:flutter/material.dart';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/services/makeTeam_service.dart';

class MakeTeamProvider with ChangeNotifier {
  final MakeTeamService service = MakeTeamService();

  List<MakeTeam> makeTeams = []; // DataTable에 표시할 팀원 모집글 정보 리스트

  // 팀원 모집글 정보를 담는 메소드를 호출
  // makeTeams 반환
  Future<List<MakeTeam>> getMakeTeam() async {
    return makeTeams;
  }

  // 팀원 모집글 작성
  Future<void> createMakeTeam(MakeTeam makeTeam) async {
    try {
      await service.createMakeTeam(makeTeam); // 팀원 모집글 작성 API를 호출

      // 팀원 모집글 정보 리스트(makeTeams)에 추가
      makeTeams.add(makeTeam);
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      print(e);
    }
  }
}
