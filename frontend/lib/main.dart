import 'package:flutter/material.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/admin/screens/addMember_screen.dart';
import 'package:frontend/admin/screens/userInfo_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/add_member': (context) => const AddMemberPage(),
        '/user-info': (context) => const UserInfoPage(),
      },
    );
  }
}
