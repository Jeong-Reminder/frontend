import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/providers/teamApply_provider.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/boardDetail_screen.dart';
import 'package:frontend/screens/corSeaBoard_screen.dart';
import 'package:frontend/screens/gradeBoard_screen.dart';
import 'package:frontend/screens/contestBoard_screen.dart';
import 'package:frontend/screens/editField_screen.dart';
import 'package:frontend/screens/editTool_screen.dart';
import 'package:frontend/screens/hiddenList_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/totalBoard_screen.dart';
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
import 'package:frontend/screens/setProfile_screen.dart';
import 'package:frontend/screens/setExperience_screen.dart';
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

  // iOS 알림 권한 요청
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 알림 초기화 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) async {
      // iOS에서 로컬 알림을 받을 때 처리할 작업
      print('Notification received: $title $body');
      // 여기에 필요한 동작을 추가하세요.
    },
  );
  InitializationSettings initializationSettings = InitializationSettings(
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
        ChangeNotifierProvider(create: (_) => VoteProvider()),
        ChangeNotifierProvider(create: (_) => TeamApplyProvider()),
      ],
      child: const MyApp(),
    ),
  );
  // 앱이 종료된 상태에서 알림을 클릭했을 때
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('App launched from notification while app was terminated.');
    _handleMessage(initialMessage); // 종료 상태에서 알림 클릭 시 처리
  }
  // 앱이 백그라운드에 있을 때 알림을 클릭했을 때
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('App opened from background due to a notification tap.');
    _handleMessage(message); // 백그라운드 상태에서 알림 클릭 시 처리
  });
  // 앱이 포그라운드에 있을 때 알림 수신
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message in the foreground.');
    _handleMessage(message); // 포그라운드 상태에서 알림 수신 시 처리
  });
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // 가로모드 방지(세로모드 지원)
    _screenSize();

    return GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/add_member': (context) => const AddMemberPage(),
        '/user-info': (context) => const UserInfoPage(),
        '/myuser': (context) => const MyUserPage(),
        '/myowner': (context) => const MyOwnerPage(),
        '/set-profile': (context) => const SetProfilePage(),
        '/member-experience': (context) => const SetExperiencePage(),
        '/experience': (context) => const ExperiencePage(
              experiences: [],
              name: '',
            ),
        '/homepage': (context) => const HomePage(),
        '/dashboard': (context) => const DashBoardPage(),
        '/edit-field': (context) => const EditFieldPage(),
        '/edit-tool': (context) => const EditToolPage(),
        '/total-board': (context) => const TotalBoardPage(),
        '/contest-board': (context) => const ContestBoardPage(),
        '/grade-board': (context) => const GradeBoardPage(),
        '/corSea-board': (context) => const CorSeaBoardPage(),
        '/detail-board': (context) => const BoardDetailPage(),
        '/hidden-board': (context) => HiddenPage(),
      },
    );
  }

  _screenSize() {
    MediaQueryData mediaQueryData = MediaQueryData.fromView(View.of(context));
    // 화면의 가로 및 세로 크기를 가져옵니다.
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    if (screenWidth > 600) {
      // print('pad 에서 접속했습니다. 가로세로모두 적용');
    } else {
      // print('phone 에서 접속했습니다. 세로모드만 적용');
    }
    // print('>>screenWidth');
    print(screenWidth);
    print(screenHeight);
  }
}

// 알림 수신 시 처리 로직
void _handleMessage(RemoteMessage message) {
  if (message.data.containsKey('targetId')) {
    int announcementId = int.parse(message.data['targetId'].toString());
    Get.to(BoardDetailPage(announcementId: announcementId, category: 'ALARM'));
  }
}
