import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/all/providers/announcement_provider.dart';
import 'package:frontend/providers/teamApply_provider.dart';
import 'package:frontend/screens/boardDetail_screen.dart';
import 'package:frontend/screens/corSeaBoard_screen.dart';
import 'package:frontend/screens/gradeBoard_screen.dart';
import 'package:frontend/screens/contestBoard_screen.dart';
import 'package:frontend/screens/editField_screen.dart';
import 'package:frontend/screens/editTool_screen.dart';
import 'package:frontend/screens/hiddenList_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/totalBoard_screen.dart';
import 'package:frontend/screens/write_screen.dart';
import 'package:get/get.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/admin/screens/addMember_screen.dart';
import 'package:frontend/admin/screens/dashboard_screen.dart';
import 'package:frontend/admin/screens/userInfo_screen.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/screens/experience_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/screens/settingProFile1_screen.dart';
import 'package:frontend/screens/settingProfile2_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';

// 알림 플러그인 인스턴스 생성
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 백그라운드에서 수신된 FCM 메시지 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  _showNotification(message); // 수정된 부분: 이제 전역 함수로 접근 가능
}

// 전역 함수로 이동
void _showNotification(RemoteMessage message) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    icon: '@mipmap/ic_launcher',
  );
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    badgeNumber: 1,
    subtitle: 'the subtitle',
    sound: 'slow_spring_board.aiff',
  );
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 알림 초기화 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // 알림 초기화
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (response) {
    if (response.payload != null) {
      Get.to(const HomePage(), arguments: response.payload); // 임시로 홈페이지 이동
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ProjectExperienceProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MakeTeamProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => TeamApplyProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // 백그라운드 메시지 클릭 액션 설정
  await setupInteractedMessage();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LoginAPI loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 라이프사이클 이벤트 관찰 시작

    // 알림 채널 설정
    _createNotificationChannel();

    // 포그라운드 메시지 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}, ${message.notification!.body}');
        _showNotification(message);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 앱 라이프사이클 이벤트 관찰 중지
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("AppLifecycleState changed: $state");
    if (state == AppLifecycleState.detached) {
      print("App is detaching, calling logout");
      // _loginAPI.logoutOnExit(); // 앱이 종료될 때 로그아웃 호출
    }
  }

  void _createNotificationChannel() async {
    var channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
        '/myuser': (context) => const MyUserPage(),
        '/myowner': (context) => const MyOwnerPage(),
        '/member-experience': (context) => const SettingProfile2Page(),
        '/experience': (context) => const ExperiencePage(
              experiences: [],
              name: '',
            ),
        '/homepage': (context) => const HomePage(),
        '/dashboard': (context) => const DashBoardPage(),
        '/edit-field': (context) => const EditFieldPage(),
        '/edit-tool': (context) => const EditToolPage(),
        '/total-board': (context) => const TotalBoardPage(),
        '/write-board': (context) => const BoardWritePage(),
        '/contest-board': (context) => const ContestBoardPage(),
        '/grade-board': (context) => const GradeBoardPage(),
        '/corSea-board': (context) => const CorSeaBoardPage(),
        '/detail-board': (context) => BoardDetailPage(),
        '/hidden-board': (context) => HiddenPage(),
      },
    );
  }
}

// 백그라운드 메시지 클릭 액션 설정
Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // 종료상태에서 클릭한 푸시 알림 메시지 핸들링
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메시지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  print('message = ${message.notification!.title}');
  if (message.data['type'] == 'chat') {
    Get.toNamed('/detail-board', arguments: message.data);
  }
}
