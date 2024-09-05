import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileService profileService = ProfileService();
  Map<String, dynamic>? _techStack;
  int? _memberId;
  List<Map<String, dynamic>> _teams = []; // 팀 정보를 저장할 리스트

  // memberId 꺼내기
  int get memberId => _memberId!;

  // 프로필 techStack 꺼내기
  Map<String, dynamic> get techStack => _techStack!;

  // 프로필 team 정보 꺼내기
  List<Map<String, dynamic>> get teams => _teams;

  // memberId 저장
  set memberId(int id) {
    _memberId = id;
    notifyListeners();
  }

  // 프로필 techStack 저장
  set techStack(Map<String, dynamic> tech) {
    _techStack = tech;
    notifyListeners();
  }

  // 팀 저장
  set teams(List<Map<String, dynamic>> teamData) {
    _teams = teamData;
    notifyListeners();
  }

  // 프로필 생성
  Future<int> createProfile(Profile profile) async {
    try {
      int profileId = await profileService.createProfile(profile);
      return profileId;
    } catch (e) {
      throw Exception('에러: ${e.toString()}');
    }
  }

  // 프로필 조회
  Future<void> fetchProfile(int memberId) async {
    try {
      Map<String, dynamic> profile =
          await profileService.fetchProfile(memberId);
      techStack = profile;

      // 프로필에서 team 정보 추출
      if (profile.containsKey('team') && profile['team'] is List) {
        teams = List<Map<String, dynamic>>.from(profile['team']);
      } else {
        teams = []; // 팀 정보가 없을 때 빈 리스트로 설정
      }

      notifyListeners();
      print('techStack: $techStack');
      print('teams: $teams');
    } catch (e) {
      print('프로필 조회 중 에러 발생: ${e.toString()}');
      teams = []; // 에러 발생 시에도 빈 리스트로 초기화
      notifyListeners();
    }
  }
}
