import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // 사용자가 화면을 터치했을 때 포커스를 해제하는 onTap 콜백 정의
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white, // 배경색 설정

          appBar: AppBar(
            toolbarHeight: 70, // 앱 바의 높이 설정
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
              // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.black,
                ),
              ),
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
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              '정보통신공학과',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
