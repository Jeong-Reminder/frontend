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

  // 팀원 신청글 삭제
  Future<void> deleteTeamApply(int applicationId) async {
    try {
      await service.deleteTeamApply(applicationId);
      print(
          'Application ID: $applicationId deleted successfully'); // 디버깅을 위한 로그

      // 로컬 리스트에서 해당 신청글을 삭제하고 리스너들에게 알림
      teamApplys.removeWhere((app) => app.id == applicationId);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀원 신청글 수락 및 거절
  Future<void> processTeamApply(
      int memberId, int recruitmentId, bool accept) async {
    try {
      await service.processTeamApply(memberId, recruitmentId, accept);
      print('Team member processed: $memberId for recruitment: $recruitmentId');

      // 처리된 팀원 신청글을 리스트에서 제거하고 리스너들에게 알림
      teamApplys.removeWhere(
          (app) => app.id == memberId); // ID 비교 로직은 실제 응답에 따라 수정 가능
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀 생성
  Future<void> createTeam(
      int recruitmentId, String teamName, String kakaoUrl) async {
    try {
      await service.createTeam(recruitmentId, teamName, kakaoUrl);
      print('Team created successfully for recruitment: $recruitmentId');

      // 팀 생성 후 추가적인 로직 (필요에 따라)
      notifyListeners();
    } catch (e) {
      print('Failed to create team: $e');
      rethrow;
    }
  }
}
