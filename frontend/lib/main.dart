import 'package:flutter/material.dart';
import 'package:frontend/screens/%08vote_screen.dart';

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
      home: votePage(),
    );
  }
}
