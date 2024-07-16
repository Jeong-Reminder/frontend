import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/services/projectExperience_service.dart';

class ProjectExperienceProvider with ChangeNotifier {
  final ProjectExperienceService service = ProjectExperienceService();

  List<ProjectExperience> projectExperiences =
      []; // Datatable에 표시할 프로젝트 경험 정보 리스트

  // 프로젝트 경험 정보를 담는 메소드를 호출(그래야만 프로젝트 경험 정보를 projectExperiences에 담고 반환할 수 있음)
  // projectExperiences 반환
  Future<List<ProjectExperience>> getProjectExperience() async {
    return projectExperiences;
  }

  // 프로젝트 경험 추가
  Future<void> createProjectExperience(
      ProjectExperience projectExperience) async {
    try {
      await service
          .createProjectExperience(projectExperience); // 프로젝트 경험 추가 API를 호출

      // 프로젝트 경험 정보 리스트(projectExperiences)에 추가
      projectExperiences.add(projectExperience);
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      print(e);
    }
  }
}
