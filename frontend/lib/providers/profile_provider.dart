import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileService profileService = ProfileService();
  late int _memberId;
  late Profile _techStack;

  Profile get techStack => _techStack;
  int get memberId => _memberId;

  Future<Profile> getProfile() async {
    await fetchProfile(memberId);
    return techStack;
  }

  // 프로필 생성
  Future<void> createProfile(Profile profile) async {
    try {
      _memberId = await profileService.createProfile(profile);

      await fetchProfile(memberId);
    } catch (e) {
      print('에러: ${e.toString()}');
    }
    notifyListeners();
  }

  // 프로필 조회
  Future<void> fetchProfile(int memberId) async {
    _techStack = await profileService.fetchProfile(memberId);
    notifyListeners();

    print("기술 스택: $techStack");
  }
}
