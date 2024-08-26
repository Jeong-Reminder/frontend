import 'package:flutter/material.dart';
import 'package:frontend/models/teamApply_model.dart';
import 'package:frontend/services/teamApply_service.dart';

class TeamApplyProvider with ChangeNotifier {
  final TeamApplyService service = TeamApplyService();

  List<TeamApply> teamApplys = [];
  final List<Map<String, dynamic>> _teamList = [];
  Map<String, dynamic> teams = {}; // Store team data here

  List<Map<String, dynamic>> get teamList => _teamList;

  Future<List<TeamApply>> getTeamApply() async {
    return teamApplys;
  }

  // 팀원 신청글 작성
  Future<int> createTeamApply(TeamApply teamApply) async {
    try {
      int applicationId = await service.createTeamApply(teamApply);
      print('Application ID: $applicationId');

      teamApplys.add(teamApply);
      notifyListeners();

      return applicationId;
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
      print('Application ID: $applicationId updated successfully');

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
      print('Application ID: $applicationId deleted successfully');

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

      teamApplys.removeWhere((app) => app.id == memberId);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 팀 생성
  Future<void> createTeam(
      int recruitmentId, String teamName, String kakaoUrl) async {
    try {
      // 팀 생성 후 팀 ID 반환
      int teamId = await service.createTeam(recruitmentId, teamName, kakaoUrl);
      print('Team created successfully with ID: $teamId');
    } catch (e) {
      print('Failed to create team: $e');
      rethrow;
    }
  }

  // 팀 목록 조회
  Future<void> fetchTeams(int teamId) async {
    try {
      final teamData = await service.fetchTeams(teamId);

      if (teamData.isNotEmpty) {
        print('Team data fetched successfully: $teamId');
        teams = teamData;
        print('teams : $teams');
        notifyListeners();
      } else {
        print('No data found for teamId: $teamId');
      }
    } catch (e) {
      print('Failed to fetch teams: $e');
      rethrow;
    }
  }
}
