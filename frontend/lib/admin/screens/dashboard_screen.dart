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

          // 회원 정보 목록 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: () {
                // 회원 정보 페이지로 이동
              },
              child: Container(
                height: 154,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFE),
                  image: DecorationImage(
                    image: AssetImage('assets/images/userInfoImg.png'),
                    opacity: 0.3,
                    alignment: Alignment(-0.65, -0.5), // 이미지의 위치 조정
                  ),
                ),
                child: const Text(
                  '회원 정보 목록',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 팀원 모집글 목록 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: () {
                // 팀원 모집글로 이동
              },
              child: Container(
                height: 154,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFE),
                  image: DecorationImage(
                    image: AssetImage('assets/images/teamRecruitImg.png'),
                    opacity: 0.3,
                    alignment: Alignment(-0.65, -0.5), // 이미지의 위치 조정
                  ),
                ),
                child: const Text(
                  '팀원 모집글',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 경진대회 목록 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: () {
                // 경진대회 페이지로 이동
              },
              child: Container(
                height: 154,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFE),
                  image: DecorationImage(
                    image: AssetImage('assets/images/contestImg.png'),
                    opacity: 0.3,
                    alignment: Alignment(-0.65, -0.5), // 이미지의 위치 조정
                  ),
                ),
                child: const Text(
                  '경진대회',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
