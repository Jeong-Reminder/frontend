import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/screens/totalBoard_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/notification_services.dart';
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

  // 위젯의 상태 초기화
  @override
  void initState() {
    super.initState();
    _selectedDay = _focuseDay;
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

  // 알림 버튼 누를 시  FCM 토큰 발급 함수
  Future<String> _getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    // print('FCM 토큰: $token');

    return token!;
  }

  // 알림 테스트
  // 푸시 알림 데이터
  Map<String, dynamic> notificationData = {
    "id": "1",
    "title": "Test Notification",
    "content": "This is a test notification message.",
    "category": "general",
    "targetId": 1,
    "createdAt": "2024-07-28T10:00:00"
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
          toolbarHeight: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/logo.png'),
              color: Colors.black,
            ),
          ),
          leadingWidth: 120,
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.search,
                size: 30,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () async {
                  String fcmToken = await _getFCMToken();

                  await NotificationService()
                      .notification(notificationData, fcmToken);
                },
                // badge 패키지 사용해서 다시 작성 예정
                icon: const Icon(
                  Icons.add_alert,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  final memberId =
                      Provider.of<ProfileProvider>(context, listen: false)
                          .memberId;

                  if (memberId > 0) {
                    await Provider.of<ProfileProvider>(context, listen: false)
                        .fetchProfile(memberId);
                  }

                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      '/myuser',
                    );
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
                SingleChildScrollView(
                  // 사용자가 스크롤하여 모든 위젯을 볼 수 있음
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        // 첫 번째 위젯 박스
                        width: 216,
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.only(right: 9.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBE7FB),
                          borderRadius: BorderRadius.circular(15.0), // 박스 둥근 비율
                          border: Border.all(
                            // 박스 테두리
                            color: const Color(0xFF2B72E7).withOpacity(0.25),
                            width: 1, // 두께
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '우리 학교의 모든 것',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '중요한 학교 정보 놓치지 마세요',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 29),
                            Row(
                              children: [
                                Text(
                                  '더보기',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Icon(Icons.arrow_forward_ios,
                                      size: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // 두 번째 위젯 박스
                        width: 216,
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.only(right: 9.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBE7FB),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: const Color(0xFF2B72E7).withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '졸업 이수학점 확인 공지',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '학생분들은 이수학점 및 현수강',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 29),
                            Row(
                              children: [
                                Text(
                                  '더보기',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Icon(Icons.arrow_forward_ios,
                                      size: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                // overflow 방지
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: GridView.count(
                    physics:
                        const NeverScrollableScrollPhysics(), // Gridview의 스크롤 방지
                    crossAxisCount: 5, // 1개의 행에 보여줄 item의 개수
                    crossAxisSpacing: 9.0, // 같은 행의 iteme들 사이의 간

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
                            imgPath: 'assets/images/general.png',
                            title: '전체공지'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/grade-board');
                        },
                        child: homeItem(
                            imgPath: 'assets/images/grade.png', title: '학년공지'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/contest-board',
                          );
                        },
                        child: homeItem(
                          imgPath: 'assets/images/competition.png',
                          title: '경진대회',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/corSea-board');
                        },
                        child: homeItem(
                            imgPath: 'assets/images/company.png',
                            title: '기업탐방'),
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
                              imgPath: 'assets/images/etc.png', title: '팀원모집')),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  // 세 번째 위젯 박스
                  width: 432,

                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(right: 9.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBE7FB),
                    borderRadius: BorderRadius.circular(15.0), // 박스 둥근 비율
                    border: Border.all(
                      // 박스 테두리
                      color: const Color(0xFF2B72E7).withOpacity(0.25),
                      width: 1, // 두께
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '이런 경진대회라면 놓칠 수 없지!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                '정보통신공학과 학생만 가능한 경험',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Image.asset(
                                  'assets/images/light.png',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/smile.png',
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        '커뮤니티',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text(
                            '더보기',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  // 네 번째 위젯 박스
                  width: 432,

                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(right: 9.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFE),
                    borderRadius: BorderRadius.circular(15.0), // 박스 둥근 비율
                  ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '대외 활동',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(width: 17),
                          Text(
                            '코테노이아 절찬 모집중!!!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            '취업 진로',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(width: 17),
                          Text(
                            '이거 꼭 해봐!!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            '정통 광장',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(width: 17),
                          Text(
                            '시험 범위 알려줄 사람~~',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
}
