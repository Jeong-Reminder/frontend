import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/services/projectExperience_service.dart';

class ProjectExperienceProvider with ChangeNotifier {
  final ProjectExperienceService service = ProjectExperienceService();

  List<ProjectExperience> projectExperiences =
      []; // DataTable에 표시할 프로젝트 경험 정보 리스트

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

  // 프로젝트 경험 여러 개 추가
  Future<void> createProjectExperiences(
      List<ProjectExperience> projectExperienceList) async {
    try {
      await service.createProjectExperiences(
          projectExperienceList); // 프로젝트 경험 여러 개 추가 API를 호출

      // 프로젝트 경험 정보 리스트(projectExperiences)에 추가
      projectExperiences.addAll(projectExperienceList);
      notifyListeners(); // 상태 변경 알림
    } catch (e) {
      print(e);
    }
  }

  // 내 프로젝트 경험 조회
  Future<void> fetchExperiences() async {
    try {
      // ProjectExperienceService의 인스턴스를 통해 프로젝트 경험 정보를 가져옴
      List<ProjectExperience> fetchExperiences =
          await service.fetchExperiences();

      // fetchExperiences 메서드로 가져온 프로젝트 경험 정보를 projectExperiences 리스트에 할당
      projectExperiences = fetchExperiences;

      notifyListeners(); // 상태 변경을 알림
    } catch (e) {
      print(e);
    }
  }

  // 프로젝트 경험 수정
  Future<void> updateProjectExperience(
      ProjectExperience updatedProjectExperience) async {
    try {
      // 프로젝트 경험 리스트에서 수정된 항목을 찾아서 업데이트
      int index = projectExperiences
          .indexWhere((exp) => exp.id == updatedProjectExperience.id);

      if (index != -1) {
        // 프로젝트 경험 수정 API를 호출
        await service.updateProjectExperience(updatedProjectExperience);

        // 수정된 항목을 바로 리스트에 반영
        projectExperiences[index] = updatedProjectExperience;
        notifyListeners(); // 상태 변경 알림
        print('index: $index');
      } else {
        print('수정할 프로젝트 경험을 찾을 수 없습니다.');
      }
    } catch (e) {
      print(e);
    }
  }
}
