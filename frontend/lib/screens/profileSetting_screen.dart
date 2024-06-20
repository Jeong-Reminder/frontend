import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  // build 메서드 안에 선언을 하면 상태가 변경될 때마다 변수가 초기화되기 때문에 null 체크가 항상 true로 평가되서 build 메서드 밖에서 정의
  XFile? pickedImage; // 파일 받을 변수

  // 카메라 연동 함수
  void getCameraImage() async {
    final pickedCamera =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedCamera != null) {
      setState(() {
        pickedImage = pickedCamera;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  // 갤러리 연동 함수
  void getGalleryImage() async {
    final pickedGallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedGallery != null) {
      setState(() {
        pickedImage = pickedGallery;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4; // 전체 화면 너비의 4분의 1

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Center(
          child: Column(
            children: [
              const Text(
                '프로필 설정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '나중에 언제든지 변경할 수 있습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF808080),
                ),
              ),
              const SizedBox(height: 45),

              // 프로필
              if (pickedImage == null)
                IconButton(
                  onPressed: () {
                    wayToChooseImage(context);
                  },
                  icon: Icon(
                    Icons.account_circle,
                    size: imageSize,
                  ),
                )
              else
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    image: DecorationImage(
                      image: FileImage(
                        File(pickedImage!.path),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 74),

              // 알리미 시작하기 버튼
              ElevatedButton(
                onPressed: () {
                  // 이미지 설정해야만 이동
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDBE7FB),
                  minimumSize: const Size(211, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  '알리미 시작하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 이미지 선택 함수
  Future<dynamic> wayToChooseImage(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      // backgroundColor: Colors.white,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 카메라 버튼
            TextButton.icon(
              onPressed: () {
                getCameraImage();
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
              ),
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              label: const Text(
                '카메라',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(
              thickness: 3,
            ),

            // 라이브러리 버튼
            TextButton.icon(
              onPressed: () {
                getGalleryImage();
              },
              style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0))),
              icon: const Icon(
                Icons.photo_album_outlined,
                color: Colors.black,
              ),
              label: const Text(
                '갤러리',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
