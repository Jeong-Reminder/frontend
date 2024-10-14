import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';

// BoardAppbar 위젯 정의
class BoardAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? userRole;
  const BoardAppbar({this.userRole, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
      toolbarHeight: 70,
      leadingWidth: 140,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false);
          },
          icon: Image.asset('assets/images/logo.png'),
          color: Colors.black,
        ),
      ),
      actions: [
        // 프로필 아이콘
        Padding(
          padding: const EdgeInsets.only(right: 23.0),
          child: IconButton(
            onPressed: () async {
              if (userRole == 'ROLE_USER') {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyUserPage(),
                    ),
                  );
                }
              } else if (userRole == 'ROLE_ADMIN') {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyOwnerPage(),
                    ),
                  );
                }
              }
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  // preferredSize를 재정의하여 AppBar의 크기를 지정
  @override
  Size get preferredSize => const Size.fromHeight(70);
}
