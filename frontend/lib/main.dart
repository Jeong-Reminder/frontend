import 'package:flutter/material.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/admin/screens/addMember_screen.dart';
import 'package:frontend/admin/screens/userInfo_screen.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/settingProFile1_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/login_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final LoginAPI _loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _loginAPI.logoutOnExit(); // 앱이 종료되거나 비활성화될 때 로그아웃 호출
    }
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
      },
    );
  }
}
