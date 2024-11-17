import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/providers/notification_provider.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/providers/teamApply_provider.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/boardDetail_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/recruitDetail_screen.dart';
import 'package:get/get.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';

// 알림 플러그인 인스턴스 생성 (로컬 푸시 알림을 보여주기 위한 플러그인)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 알림을 보여주는 함수 (전역 함수로 설정하여 백그라운드에서도 사용 가능)
void _showNotification(RemoteMessage message) async {
  // Android용 알림 설정
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'high_importance_channel', // 채널 ID
    'High Importance Notifications', // 채널 이름
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.high, // 중요도를 high로 설정하여 헤드업 알림 활성화
    icon: '@mipmap/launcher_icon', // 알림 아이콘 설정
  );

  // iOS용 알림 설정
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    badgeNumber: 1, // 배지 번호 설정
    subtitle: 'the subtitle', // 서브 타이틀 설정
    sound: 'slow_spring_board.aiff', // 알림 사운드 설정
  );

  // 플랫폼별 알림 설정 통합
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  // payload에 targetId와 category 추가
  String payload = '${message.data['targetId']},${message.data['category']}';

  // 알림 표시
  await flutterLocalNotificationsPlugin.show(
    message.hashCode, // 알림 ID
    message.notification?.title, // 알림 제목
    message.notification?.body, // 알림 내용
    platformChannelSpecifics, // 알림 설정
    payload: payload, // 알림 탭시 사용할 데이터
  );
}

// 백그라운드 메시지 핸들러 함수 정의
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.data}');

  _showNotification(message);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter의 비동기적 초기화

  // ByteData data = await PlatformAssetBundle()
  //     .load('assets/ca/star.sungkyul.ac.kr.cert.pem');
  // SecurityContext.defaultContext
  //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Firebase 초기화 시도
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

  // 알림 초기화 설정(Android 및 iOS용)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) async {},
  );

  // 알림 초기화 설정 통합(Android 및 iOS)
  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // 알림 초기화
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (response) {
    if (response.payload != null) {
      _onNotificationTap(response.payload!); // 알림 탭시 이동 처리
    }
  });

  // 백그라운드, 포그라운드 상태에서 알림 클릭 처리 설정
  await setupInteractedMessage();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    // 알림 표시
    _showNotification(message);
  });

  // 앱이 백그라운드에 있을 때 알림 클릭 처리
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //   _showNotification(message);
  // });

  // 앱 실행 시 Provider로 여러 상태 관리 클래스 주입
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
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LoginAPI loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
  RemoteMessage? initializeMessage; // 초기 메세지 변수 선언

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 라이프사이클 이벤트 관찰 시작

    _createNotificationChannel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 앱 라이프사이클 이벤트 관찰 중지
    super.dispose();
  }

  // 앱의 라이프사이클 상태 변화 감지 (예: 앱 종료 시)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("AppLifecycleState changed: $state");
    if (state == AppLifecycleState.detached) {
      print("App is detaching");
      // _loginAPI.logoutOnExit(); // 앱이 종료될 때 로그아웃 호출
    }
  }

  // 중요한 알림을 받을 채널 생성(Android)
  void _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // 채널 ID
      'High Importance Notifications', // 채널 이름
      description: 'This channel is used for important notifications.', // 채널 설명
      importance: Importance.high, // 높은 우선순위
    );

    // Android 알림 채널 생성
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    // 세로 모드 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 화면 크기 계산
    _screenSize();

    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LoginPage()), // 로그인 페이지
        GetPage(
            name: '/detail-board',
            page: () => const BoardDetailPage()), // 추가로 명시
        GetPage(
            name: '/detail-recruit',
            page: () => const RecruitDetailPage()), // 추가로 명시
      ],
    );
  }

  // 화면 크기를 계산하여 장치에 따른 반응형 레이아웃 구현 가능
  _screenSize() {
    MediaQueryData mediaQueryData = MediaQueryData.fromView(View.of(context));
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    print('screenWidth: $screenWidth');
    print('screenHeight : $screenHeight');
  }
}

// 포그라운드, 백그라운드 메시지 클릭 시 실행되는 핸들러 설정
Future<void> setupInteractedMessage() async {
  // 앱이 종료된 상태에서 알림을 클릭하여 시작된 경우의 메시지 처리
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  print('initialMessage: $initialMessage');

  if (initialMessage != null) {
    print('Initial message received: ${initialMessage.data}');

    // 알림 데이터에서 필요한 정보를 추출하여 페이지로 이동
    _exitNavigateBoard(initialMessage.data);
  }

  _navigateBoard();
}

void _exitNavigateBoard(Map<String, dynamic> messageData) {
  final int id = int.parse(messageData['targetId'].toString());
  final String category = messageData['category'].toString();

  print("Navigating to BoardDetailPage with ID: $id, Category: $category");

  if (category == '공지') {
    navigatorKey.currentState?.pushNamed(
      '/detail-board',
      arguments: {'announcementId': id, 'category': category},
    );
  } else if (category == '팀원모집') {
    navigatorKey.currentState?.pushNamed(
      '/detail-recruit',
      arguments: {'makeTeamId': id},
    );
  }
}

// id와 category를 받아서 상세 페이지로 이동하는 메서드
void _navigateBoard() async {
  // MethodChannel을 통한 네이티브 코드에서 데이터를 수신
  const platform = MethodChannel("com.sungkyul/notification");

  platform.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'navigateToDetail') {
      print(
          "Method channel called with arguments: ${call.arguments}"); // call.arguments는 AppDelegate의 notificationData를 뜻함

      final Map<String, dynamic> args =
          Map<String, dynamic>.from(call.arguments);
      final int id = int.parse(args['id'].toString());
      final String category = args['category'].toString();

      print("Received ID: $id, Category: $category");

      if (category == '공지') {
        navigatorKey.currentState?.pushNamed(
          '/detail-board',
          arguments: {'announcementId': id, 'category': category},
        );
      } else if (category == '팀원모집') {
        navigatorKey.currentState?.pushNamed(
          '/detail-recruit',
          arguments: {'makeTeamId': id},
        );
      }
    }
  });
}

void _onNotificationTap(String payload) {
  // payload에서 targetId와 category 추출
  List<String> data = payload.split(',');
  int targetId = int.parse(data[0]);
  String category = data[1];

  print(
      "Navigating to BoardDetailPage with ID: $targetId, Category: $category");

  if (category == '공지') {
    Get.toNamed(
      '/detail-board',
      arguments: {'announcementId': targetId, 'category': category},
      preventDuplicates: false,
    );
  } else if (category == '팀원모집') {
    Get.toNamed(
      '/detail-recruit',
      arguments: {'makeTeamId': targetId},
      preventDuplicates: false,
    );
  }
}
