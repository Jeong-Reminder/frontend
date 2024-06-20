import 'package:flutter/material.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
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
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 카메라 버튼
                          TextButton.icon(
                            onPressed: () {},
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
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 80),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0))),
                            icon: const Icon(
                              Icons.photo_album_outlined,
                              color: Colors.black,
                            ),
                            label: const Text(
                              '라이브러리에서 불러오기',
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
                },
                icon: Icon(
                  Icons.account_circle,
                  size: imageSize,
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
}
