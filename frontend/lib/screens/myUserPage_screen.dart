import 'package:flutter/material.dart';

class MyUserPage extends StatelessWidget {
  const MyUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        leadingWidth: 120,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필
            Card(
              color: const Color(0xFFFAFAFE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 26.0),
                child: ListTile(
                  leading: ClipRRect(
                    child: Image.asset('assets/images/profile.png'),
                  ),
                  title: const Text(
                    '민택기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Row(
                    children: [
                      Text('20190906'),
                      SizedBox(width: 5),
                      CircleAvatar(
                        radius: 2,
                        backgroundColor: Color(0xFF808080),
                      ),
                      SizedBox(width: 5),
                      Text('재학생'),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()), // 빈 공간을 차지해서 맨 밑으로 적용이 되도록 구현
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '계정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '비밀번호 변경',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                logoutDialog(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 로그아웃 다이얼로그 함수
  Future<dynamic> logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: const Icon(
            Icons.question_mark_rounded,
            size: 40,
            color: Color(0xFF2A72E7),
          ),
          // 메인 타이틀
          title: const Column(
            children: [
              Text("정말 로그아웃 하실 건가요?"),
            ],
          ),
          //
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "실수일 수도 있으니까요",
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 20),
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 로그인 화면으로 이동
                  },
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 20),
                  ),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
