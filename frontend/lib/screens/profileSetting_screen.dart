import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
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
                    Icon(
                      Icons.account_circle,
                      size: imageSize,
                    )
                  else
                    Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2),
                        image: DecorationImage(
                          image: FileImage(
                            File(pickedImage!.path),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 74),

                  // 카메라와 갤러리 연동 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getImageButton(() {
                        getCameraImage();
                      }, Icons.camera_alt_rounded),
                      const SizedBox(width: 50),
                      getImageButton(() {
                        getGalleryImage();
                      }, Icons.photo_album_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),

            // 알리미 시작하기 버튼
            GestureDetector(
              onTap: () {
                // 프로필 설정해야만 이동
                // 설정을 안하고 이동할 시 "프로필을 설정하세요"라고 출력
                if (pickedImage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                } else {
                  // 하단 스낵바
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF2A72E7),
                      content: Center(
                        child: Text(
                          '프로필을 지정해주세요',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '알리미 시작하기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8), // 텍스트와 아이콘 사이의 간격
                  Icon(
                    Icons.chevron_right_sharp,
                    size: 40.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 카메라 / 갤러리 연동 버튼 함수
  Widget getImageButton(VoidCallback getImage, IconData icon) {
    return ElevatedButton(
      onPressed: getImage,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDBE7FB),
        minimumSize: const Size(20, 60),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
