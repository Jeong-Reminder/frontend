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
  Future<int> createTeamApply(TeamApply teamApply) async {
    try {
      int applicationId = await service.createTeamApply(teamApply);
      print('Application ID: $applicationId'); // 디버깅을 위한 로그

      // 작성된 신청글을 리스트에 추가하고 리스너들에게 알림
      teamApplys.add(teamApply);
      notifyListeners();

      return applicationId; // 작성된 신청글의 ID 반환
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // 팀원 신청글 수정
  Future<void> updateTeamApply(
      int applicationId, TeamApply updatedTeamApply) async {
    try {
      await service.updateTeamApply(applicationId, updatedTeamApply);
      print(
          'Application ID: $applicationId updated successfully'); // 디버깅을 위한 로그

      // 로컬 리스트에서 해당 신청글을 업데이트하고 리스너들에게 알림
      int index = teamApplys.indexWhere((app) => app.id == applicationId);
      if (index != -1) {
        teamApplys[index] = updatedTeamApply;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
