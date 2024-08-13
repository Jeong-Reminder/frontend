import 'package:flutter/material.dart';
import 'package:frontend/models/teamApply_model.dart';
import 'package:frontend/services/teamApply_service.dart';

class TeamApplyProvider with ChangeNotifier {
  final TeamApplyService service = TeamApplyService();

  List<TeamApply> teamApplys = [];

  Future<List<TeamApply>> getTeamApply() async {
    return teamApplys;
  }

  // 팀원 신청글 작성
  Future<void> createTeamApply(TeamApply teamApply) async {
    try {
      int applicationId = await service.createTeamApply(teamApply);
      print('Application ID: $applicationId'); // 디버깅을 위한 로그

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
