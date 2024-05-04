import 'package:flutter/material.dart';
import 'package:frontend/screens/level_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const GradePage(),
      theme: ThemeData(
        dividerTheme:
            const DividerThemeData(color: Colors.white), // 팝업 메뉴 경계선 색상 설정
      ),
    );
  }
}
