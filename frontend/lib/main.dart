import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/admin/screens/addMember_screen.dart';
import 'package:frontend/admin/screens/userInfo_screen.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/settingProFile1_screen.dart';
import 'package:frontend/screens/settingProfile2_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDvy25KphqLhKRHPXA82eWLbafv883gd7Q',
          appId: '1:50450222487:android:4adeb947d058cfd45808d2',
          messagingSenderId: '50450222487',
          projectId: 'jeong-reminder',
          storageBucket: 'jeong-reminder.appspot.com',
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBZXl3f6UX_SS5HpBDicYGjCvZMq_GghxY',
          appId: '1:50450222487:ios:a87e6f088462b2815808d2',
          messagingSenderId: '50450222487',
          projectId: 'jeong-reminder',
          storageBucket: 'jeong-reminder.appspot.com',
          iosBundleId: 'com.sungkyul.reminder',
        ),
      );
    }
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ProjectExperienceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 라이프사이클 이벤트 관찰 시작
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 앱 라이프사이클 이벤트 관찰 중지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/add_member': (context) => const AddMemberPage(),
        '/user-info': (context) => const UserInfoPage(),
        '/setting-profile': (context) => const SettingProfile1Page(),
        '/member-experience': (context) => const SettingProfile2Page(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}
