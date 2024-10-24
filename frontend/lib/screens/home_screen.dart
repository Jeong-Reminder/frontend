import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/admin/screens/dashboard_screen.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/screens/boardDetail_screen.dart';
import 'package:frontend/screens/contestBoard_screen.dart';
import 'package:frontend/screens/corSeaBoard_screen.dart';
import 'package:frontend/screens/gradeBoard_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/totalBoard_screen.dart';
import 'package:frontend/screens/memberRecruit_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Widget homeItem({required String imgPath, required String title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        imgPath,
        width: 50, // 이미지 너비
        height: 50, // 이미지 높이
      ),
      const SizedBox(height: 2),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF374AA3).withOpacity(0.66), // title 색상
        ),
      ),
    ],
  );
}

class _HomePageState extends State<HomePage> {
  // 달력 형식과 초기 선택된 날짜 설정
  CalendarFormat _calendarFomat = CalendarFormat.month;
  DateTime _focuseDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  String userRole = '';

  int? level;
  int notificationCount = 0; // 알림 카운트를 위한 변수

  List<Map<String, dynamic>> voteList = [
    {
      "name": "1차 증원 투표",
      "start_day": "2024-05-07",
      "end_day": "2024-05-08",
    },
    {
      "name": "2차 증원 투표",
      "start_day": "2024-05-10",
      "end_day": "2024-05-11",
    },
    {
      "name": "팀원 모집 기간",
      "start_day": "2024-05-21",
      "end_day": "2024-05-25",
    },
  ];

  Future<List<Map<String, dynamic>>>? boardList;

  // 위젯의 상태 초기화
  @override
  void initState() {
    super.initState();
    _selectedDay = _focuseDay;

    // Firebase 메시지 초기화
    _initializeFirebaseMessaging();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards();

      setState(() {
        boardList = getData();
      });
    });

    _loadCredentials();
  }

  // // 비동기 초기화 메서드
  // Future<void> _initializeData() async {
  //   await Provider.of<AnnouncementProvider>(context, listen: false)
  //       .fetchAllBoards();
  //   getData(); // 전체 공지 api가 먼저 호출되어야 홈화면에 공지를 띄울 수 있음.
  // }

  // Firebase 메시지 수신을 위한 초기화 함수
  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notificationCount += 1; // 알림이 수신되면 카운트를 증가시킴
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        notificationCount += 1; // 앱이 열릴 때도 알림 카운트 증가
      });
    });
  }

  // 알림 카운트 리셋 함수 (사용자가 알림 아이콘을 눌렀을 때 호출)
  void _resetNotificationCount() {
    setState(() {
      notificationCount = 0; // 알림 카운트 초기화
    });
  }

  // 역할을 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 level를 가져와 저장
      level = credentials['level'];
    });
  }

  // 날짜가 선택되었을 때 실행되는 콜백 메서드
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      // 만약 선택한 날짜가 이전에 선택한 날짜와 다른 날짜라면 실행
      setState(() {
        _selectedDay = selectedDay; // 선택한 날짜를 새로운 선택한 날짜로 설정
        _focuseDay = focusedDay; // 포커스된 날짜를 새로운 포커스된 날짜로 설정
      });
      _showEventsForSelectedDay(
          selectedDay); // 선택한 날짜에 대한 이벤트를 표시하기 위해 _showEventsForSelectedDay 메서드 호출
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focuseDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  // 선택된 날짜에 해당하는 이벤트 표시
  void _showEventsForSelectedDay(DateTime selectedDay) {
    // 선택된 날짜에 해당하는 이벤트 확인
    List<String> eventsForSelectedDay = [];
    for (var vote in voteList) {
      // voteList의 각 요소에 대해 반복
      // DateTime.parse 함수를 사용하여 문자열 형태의 날짜를 DateTime 객체로 변환
      DateTime startDate = DateTime.parse(vote['start_day']);
      DateTime endDate = DateTime.parse(vote['end_day']);
      // 현재 날짜가 해당 이벤트의 시작일 이후이고, 종료일 이전인지 확인
      if (selectedDay.isAfter(startDate) &&
          selectedDay.isBefore(endDate.add(const Duration(days: 1)))) {
        // 선택한 날짜가 해당 이벤트의 기간 내에 있는 경우, 이벤트 이름을 리스트에 추가
        eventsForSelectedDay.add(vote['name']);
      }
    }
    // 이벤트가 있는 경우 모달 다이얼로그로 표시
    if (eventsForSelectedDay.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFDBE7FB), // 모달창 배경색
            title: Text(
                '${selectedDay.year}년${selectedDay.month}월${selectedDay.day}일 이벤트'), // 날 / 월 / 년
            titleTextStyle: const TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: eventsForSelectedDay
                  .map((event) => Text(
                        event,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black), // 텍스트 스타일
                      ))
                  .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // 선택된 날짜에 이벤트가 없는 경우 알림 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFDBE7FB), // 모달창 배경색
            title: Text(
                '${selectedDay.year}년${selectedDay.month}월${selectedDay.day}일 이벤트'),
            titleTextStyle: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold), // 날 / 월 / 년
            content: const Text('해당 날짜에는 이벤트가 없습니다.'),
            // 텍스트 스타일
            contentTextStyle:
                const TextStyle(fontSize: 16, color: Colors.black),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
          toolbarHeight: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              onPressed: () {
                if (userRole == 'ROLE_ADMIN') {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashBoardPage(),
                      ),
                      (route) => false);
                }
              },
              icon: Image.asset('assets/images/logo.png'),
              color: Colors.black,
            ),
          ),
          leadingWidth: 120,
          actions: [
            // 알림 아이콘
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      _resetNotificationCount(); // 알림 아이콘을 클릭하면 카운트를 초기화
                    },
                    icon: const Icon(
                      Icons.add_alert,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  if (notificationCount > 0) // 알림이 있으면 숫자를 표시
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 프로필 아이콘
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  print('알림 수: $notificationCount');

                  if (userRole == 'ROLE_USER') {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyUserPage(),
                        ),
                      );
                    }
                  } else if (userRole == 'ROLE_ADMIN') {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyOwnerPage(),
                        ),
                      );
                    }
                  }
                },
                child: const Icon(
                  Icons.account_circle,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '정보통신공학과',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 필독 공지들
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: boardList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('데이터를 불러오는 도중 오류가 발생했습니다.'),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      List<Map<String, dynamic>> boardList = snapshot.data!;

                      // 게시글을 작성 시간 순서대로 정렬
                      boardList.sort((a, b) {
                        DateTime createdTimeA = DateTime.parse(
                            a['createdTime']); // 작성 시간은 DateTime으로 변환
                        DateTime createdTimeB =
                            DateTime.parse(b['createdTime']);
                        return createdTimeB.compareTo(
                            createdTimeA); // b가 a보다 더 최근일 경우 양수를 반환(즉, 최신순 정렬)
                        // 반환값이 양수이면, 순서가 바뀌고 음수이면, 순서가 바뀌지 않음
                      });

                      List<Map<String, dynamic>> userBoardList =
                          []; // 학생에게 보여질 공지글(해당 학년의 공지글만 보여주기 위해)
                      List<Map<String, dynamic>> mustBoardList = [];

                      // 전체 공지에서 필독 상태인 공지만 필터링한 공지
                      if (userRole == 'ROLE_ADMIN') {
                        mustBoardList = boardList.where((board) {
                          return board['announcementImportant'] == true;
                        }).toList();
                      }

                      // 학생일 경우에는 학년까지 필터링해야 함
                      if (userRole == 'ROLE_USER') {
                        userBoardList = boardList.where((board) {
                          return (board['announcementLevel'] == level ||
                                  board['announcementLevel'] == 0) &&
                              board['announcementImportant'] == true;
                        }).toList();
                      }

                      return (userBoardList.isNotEmpty ||
                              mustBoardList.isNotEmpty)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 6,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (userRole == 'ROLE_USER')
                                    ? userBoardList.length
                                    : mustBoardList.length,
                                shrinkWrap: true, // 높이를 제한하는 데 도움을 줌
                                itemBuilder: (context, index) {
                                  final board = (userRole == 'ROLE_USER')
                                      ? userBoardList[index]
                                      : mustBoardList[index];

                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            '/detail-board',
                                            arguments: {
                                              'announcementId': board['id'],
                                              'category': 'HOME',
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDBE7FB),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                              color: const Color(0xFF2B72E7)
                                                  .withOpacity(0.25),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // 컨테이너 크기에 맞게 줄임표를 사용하여 텍스트가 오버플로되었음을 나타냄
                                              // 공지글 제목
                                              RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  text: board[
                                                      'announcementTitle'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              // 공지글 내용
                                              RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text: board[
                                                      'announcementContent'],
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 29),
                                              const Row(
                                                children: [
                                                  Text(
                                                    '더보기',
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 30.0),
                                                    child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 14,
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 9),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            );
                    } else {
                      return Container();
                    }
                  },
                ),

                const SizedBox(height: 20),

                // 공지 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TotalBoardPage(),
                          ),
                        );
                      },
                      child: homeItem(
                          imgPath: 'assets/images/general.png', title: '전체공지'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GradeBoardPage(),
                          ),
                        );
                      },
                      child: homeItem(
                          imgPath: 'assets/images/grade.png', title: '학년공지'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContestBoardPage(),
                          ),
                        );
                      },
                      child: homeItem(
                          imgPath: 'assets/images/competition.png',
                          title: '경진대회'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CorSeaBoardPage(),
                          ),
                        );
                      },
                      child: homeItem(
                          imgPath: 'assets/images/company.png', title: '기업탐방'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemberRecruitPage(),
                          ),
                        );
                      },
                      child: homeItem(
                          imgPath: 'assets/images/etc.png', title: '팀원모집'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 달력
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '달력',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 3, 14), //  달력의 시작 날짜
                    lastDay: DateTime.utc(2030, 3, 14), // 달력의 종료 날짜
                    focusedDay: _focuseDay, // 초기로 포커스된 날짜
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day), // 날짜 선택의 조건
                    calendarFormat:
                        _calendarFomat, // 달력의 형식 ->  (예: 'month', 'twoWeeks', 'week')
                    startingDayOfWeek: StartingDayOfWeek.monday, // 주의 시작 요일
                    onDaySelected: _onDaySelected, // 날짜가 선택되었을 때의 콜백 함수
                    rangeStartDay: _rangeStart, // 선택된 범위의 시작일
                    rangeSelectionMode: RangeSelectionMode.toggledOff,
                    onRangeSelected:
                        _onRangeSelected, // 일정 범위의 날짜가 선택되었을 때의 콜백 함수
                    rangeEndDay: _rangeEnd, // 선택된 범위의 종료일
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                    ),
                    onFormatChanged: (format) {
                      if (_calendarFomat != format) {
                        setState(() {
                          _calendarFomat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      focusedDay = focusedDay;
                    },
                    eventLoader: (day) {
                      // day = 달력에서 확인하려는 날짜
                      List<dynamic> events = []; // 이벤트를 저장할 빈 리스트를 초기화
                      for (var vote in voteList) {
                        // voteList의 각 요소에 대해 반복
                        // DateTime.parse 함수를 사용하여 문자열 형태의 날짜를 DateTime 객체로 변환
                        DateTime startDate = DateTime.parse(vote['start_day']);
                        DateTime endDate = DateTime.parse(vote['end_day']);
                        // 현재 날짜가 해당 이벤트의 시작일 이후이고, 종료일 이전인지 확인
                        if (day.isAfter(startDate) &&
                            day.isBefore(
                                endDate.add(const Duration(days: 1)))) {
                          // 현재 날짜가 해당 이벤트의 기간 내에 있는 경우, 이벤트 이름을 리스트에 추가
                          events.add(vote['name']);
                        }
                      }
                      return events; // voteList에 정의된 이벤트가 있는 날짜에만 해당 이벤트가 표시
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    return Provider.of<AnnouncementProvider>(context, listen: false).boardList;
  }
}
