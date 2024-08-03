import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileService profileService = ProfileService();
  Map<String, dynamic>? _techStack;
  int? _memberId;

  // memberId 꺼내기
  int get memberId => _memberId!;

  // 프로필 techStack 꺼내기
  Map<String, dynamic> get techStack => _techStack!;

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
    Map<String, dynamic> profile = await profileService.fetchProfile(memberId);
    techStack = profile;
    notifyListeners();

    print('techStack: $techStack');
  }
}
