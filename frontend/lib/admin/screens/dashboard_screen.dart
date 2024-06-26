import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 제목 상단바
          Container(
            height: 167,
            decoration: const BoxDecoration(
              color: Color(0xFF8FB6F6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reminder\n      DashBoard',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        scale: 2.0, // 크기 감소
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 72),

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // 회원 정보 목록 버튼
                  dashboardBtn(
                    () {},
                    'assets/images/userInfoImg.png',
                    '회원 정보 목록',
                  ),

                  // 팀원 모집글 버튼
                  dashboardBtn(
                    () {},
                    'assets/images/teamRecruitImg.png',
                    '팀원 모집글',
                  ),

                  // 경진대회 버튼
                  dashboardBtn(
                    () {},
                    'assets/images/contestImg.png',
                    '경진대회',
                  ),
                ],
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget dashboardBtn(VoidCallback onTap, String imageAsset, String title) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 154,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFE),
              image: DecorationImage(
                image: AssetImage(imageAsset),
                opacity: 0.3,
                alignment: const Alignment(-0.65, -0.5), // 이미지의 위치 조정
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
