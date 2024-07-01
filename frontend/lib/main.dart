import 'package:flutter/material.dart';
import 'package:frontend/screens/competitionNotice_screen.dart';
import 'package:frontend/screens/experience_screen.dart';
import 'package:frontend/screens/makeTeam_screen.dart';
import 'package:frontend/screens/recruitDetail_screen.dart';
import 'package:frontend/screens/write_screen.dart';

void main() {
  // GetX 서비스 초기화
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BoardWritePage(),
    );
  }
}
