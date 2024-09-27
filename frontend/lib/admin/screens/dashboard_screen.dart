import 'package:flutter/material.dart';
import 'package:frontend/admin/screens/contestTeamList_screen.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 제목 상단바
            Container(
              height: screenHeight / 6,
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
                    SizedBox(height: screenHeight / 14),
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
                    // 홈가기 버튼
                    dashboardBtn(
                      () {
                        Navigator.pushNamed(context, '/homepage');
                      },
                      'assets/images/homeImg.png',
                      '홈으로 가기',
                    ),

                    // 회원 정보 목록 버튼
                    dashboardBtn(
                      () {
                        Navigator.pushNamed(context, '/user-info');
                      },
                      'assets/images/userInfoImg.png',
                      '회원 정보 목록',
                    ),

                    // 경진대회 버튼
                    dashboardBtn(
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContestTeamListPage(),
                          ),
                        );
                      },
                      'assets/images/contestImg.png',
                      '팀',
                    ),
                  ],
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget dashboardBtn(VoidCallback onTap, String imageAsset, String title) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.height / 7,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 25 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Opacity(
                    opacity: 0.3,
                    child: Image.asset(imageAsset),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
