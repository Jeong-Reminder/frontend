import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원정보',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            userInfo('이름', '민택기'),
            userInfo('학번', '20190906'),
            userInfo('재적상태', '4학년, 재학중'),
            userInfo('깃허브 링크', 'https://github.com/TaekkiMin'),
            userInfo('전화번호', '010-1234-5678'),
          ],
        ),
      ),
    );
  }

  // 회원 정보 위젯
  Widget userInfo(String title, String info) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            info,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF808080),
            ),
          ),
        ),
      ],
    );
  }
}
