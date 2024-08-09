import 'package:flutter/material.dart';

// BoardAppbar 위젯 정의
class BoardAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BoardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      leadingWidth: 140,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/homepage', (route) => false);
          },
          icon: Image.asset('assets/images/logo.png'),
          color: Colors.black,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 23.0),
          child: Icon(
            Icons.search,
            size: 30,
            color: Colors.black,
          ),
        ),
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
    );
  }

  // preferredSize를 재정의하여 AppBar의 크기를 지정
  @override
  Size get preferredSize => const Size.fromHeight(70);
}
