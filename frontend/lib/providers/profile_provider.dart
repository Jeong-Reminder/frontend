import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileService profileService = ProfileService();

  Profile? profile;

  // 프로필 생성
  Future<void> createProfile(Profile profile) async {
    try {
      await profileService.createProfile(profile);

      this.profile = profile;
      notifyListeners();
      print("생성된 프로필: ${this.profile}");
    } catch (e) {
      print('프로필 생성 실패 : ${e.toString()}');
    }
  }
}
