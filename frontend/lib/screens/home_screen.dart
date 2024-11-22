import 'package:flutter/material.dart';
import 'package:frontend/admin/screens/dashboard_screen.dart';
import 'package:frontend/models/notification_model.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/providers/notification_provider.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/contestBoard_screen.dart';
import 'package:frontend/screens/corSeaBoard_screen.dart';
import 'package:frontend/screens/gradeBoard_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/screens/notificationList_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  List<NotificationModel> notifyList = [];
  List<Map<String, dynamic>> boardList = [];
  List<Vote> voteList = []; // 투표 전체 조회 리스트
  List<Map<String, dynamic>> selectedBoardList = []; // 달력에서 선택한 해당 날짜의 게시글

  // 위젯의 상태 초기화
  @override
  void initState() {
    super.initState();
    _selectedDay = _focuseDay;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards();

      if (context.mounted) {
        await Provider.of<NotificationProvider>(context, listen: false)
            .fetchNotification();
        if (context.mounted) {
          await Provider.of<VoteProvider>(context, listen: false).fetchVotes();
        }
      }

      setState(() {
        boardList =
            Provider.of<AnnouncementProvider>(context, listen: false).boardList;
        notifyList = Provider.of<NotificationProvider>(context, listen: false)
            .notificationList;
        voteList =
            Provider.of<VoteProvider>(context, listen: false).allVoteList;
      });
    });
    getData();

    _loadCredentials();
  }

  Future<List<Map<String, dynamic>>> getData() async {
    return Provider.of<AnnouncementProvider>(context, listen: false).boardList;
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

  // 국제 표준시간에서 한국시간으로 변환 메서드
  // 만든 이유: 앱에서 설정한 시간은 한국시간으로 잘 받아지는데 작성 api 성공 후 서버에서 받은 시간에서는 국제 표준 시간으로 받아 만들게 됨
  String convertUtcToKst(String utcTimeString) {
    DateTime utcTime = DateTime.parse(utcTimeString);
    DateTime kstTime = utcTime.add(const Duration(hours: 9));
    return DateFormat("yyyy-MM-dd HH:mm").format(kstTime);
  }

  // 날짜가 선택되었을 때 실행되는 콜백 메서드
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay; // 선택한 날짜를 새로운 선택한 날짜로 설정
      _focuseDay = focusedDay; // 포커스된 날짜를 새로운 포커스된 날짜로 설정
    });
    _showEventsForSelectedDay(
        selectedDay); // 선택한 날짜에 대한 이벤트를 표시하기 위해 _showEventsForSelectedDay 메서드 호출
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
  Future<void> _showEventsForSelectedDay(DateTime selectedDay) async {
    int id = 0;
    List<Map<String, dynamic>> calendarBoardList =
        []; // 학생의 해당 학년 게시글 혹은 관리자가 작성한 게시글
    print(
        '선택한 날짜: $selectedDay'); // 2024-11-18 00:00:00.000Z  "2024-09-09T05:34:37"

    setState(() {
      if (userRole == 'ROLE_USER') {
        calendarBoardList = boardList
            .where((board) =>
                level == board['announcementLevel'] ||
                board['announcementLevel'] == 0)
            .toList();
      } else {
        calendarBoardList = boardList;
      }
    });

    for (var selectedBoard in calendarBoardList) {
      DateTime boardCreatedTime = DateTime.parse(selectedBoard['createdTime']);

      if ((boardCreatedTime.year == selectedDay.year) &&
          (boardCreatedTime.month == selectedDay.month) &&
          (boardCreatedTime.day == selectedDay.day)) {
        print('두 날짜는 같다');
        setState(() {
          id = selectedBoard['id'];
          print('게시글 id: $id');
        });
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchOneBoard(id);
        if (context.mounted) {
          Map<String, dynamic> board =
              Provider.of<AnnouncementProvider>(context, listen: false).board;
          setState(() {
            // 게시글 생성 시간과 달력 선택 날짜와 동일하더라도 투표가 있으면 selctedBoardList에 추가
            if (board['votes'].isNotEmpty) {
              selectedBoardList.add(board);
            }
          });
        }
      }
    }

    // 해당 게시글이 있는 경우 모달 바텀 시트로 표시
    if (selectedBoardList.isNotEmpty) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일 이벤트',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // 날 / 월 / 년
                  const SizedBox(height: 20),

                  // 투표
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true, // ListView의 크기를 제한
                      physics: const BouncingScrollPhysics(), // 부드러운 스크롤
                      itemCount: selectedBoardList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> board =
                            selectedBoardList[index]; // 해당 게시글

                        return (board['votes'].isNotEmpty)
                            ? ListTile(
                                leading: Image.asset('assets/images/vote.png'),
                                title: Text(
                                  board['votes'][0]['subjectTitle'],
                                ),
                                subtitle: Text(
                                  '${convertUtcToKst(board['createdTime'])} ~ ${board['votes'][0]['endDateTime']}',
                                  style: const TextStyle(
                                    color: Color(0xFFD9D9D9),
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  // 꺽새 아이콘을 통해 투표가 들어가있는 게시글 이동
                                  onPressed: () async {
                                    Get.toNamed(
                                      '/detail-board',
                                      arguments: {
                                        'announcementId': board['id'],
                                        'category': 'HOME',
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              )
                            : null;
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ).whenComplete(
          () => selectedBoardList
              .clear(), // 바텀 시트 닫을 때 selectedBoardList의 내용 제거(제거하지 않으면 다른 날에도 보임)
        );
      }
    } else {
      // 선택된 날짜에 이벤트가 없는 경우 알림 표시
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일 이벤트',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // 날 / 월 / 년
                  const SizedBox(height: 20),
                  const Text('해당 날짜에는 이벤트가 없습니다.'),
                ],
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 아직 읽지 않았고 전체 게시글과 알림 리스트 아이디가 서로 동일한 리스트 출력
    List<NotificationModel> falseList = notifyList.where((notify) {
      return notify.read == false;
    }).where((bd) {
      return boardList.any((b) => b['id'] == bd.targetId);
    }).toList();

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
            if (userRole == 'ROLE_USER')
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationListPage(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.add_alert,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    if (falseList.isNotEmpty) // 알림이 있으면 숫자를 표시
                      Positioned(
                        right: 12,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 6,
                            minHeight: 6,
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
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xFF2A72E7),
                        ),
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

                Container(
                  // 세 번째 위젯 박스
                  width: MediaQuery.of(context).size.width,

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
                    locale: 'ko_KR',
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
                      markerDecoration: BoxDecoration(
                        // 마커 색상
                        color: Color(0xFF2A72E7),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        // 선택 날짜 색상
                        color: Color(0xFF2A72E7),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        // 오늘 날짜 색상
                        color: Color(0xFF94B8F3),
                        shape: BoxShape.circle,
                      ),
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

                      // 계정이 학생일 경우 게시글의 설정 학년과 학생의 학년과 게시글의 아이디와 투표에 들어있는 게시글 아이디가 동일하면
                      // events에 추가하는 작업 진행
                      for (var vote in voteList) {
                        for (var board in boardList) {
                          if ((userRole == 'ROLE_USER')
                              ? (board['announcementLevel'] == level ||
                                      board['announcementLevel'] == 0) &&
                                  board['id'] == vote.announcementId
                              : board['id'] == vote.announcementId) {
                            // voteList의 각 요소에 대해 반복
                            // DateTime.parse 함수를 사용하여 문자열 형태의 날짜를 DateTime 객체로 변환
                            DateTime startDate =
                                DateTime.parse(board['createdTime']);
                            DateTime endDate =
                                DateTime.parse(vote.endDateTime!);
                            // 현재 날짜가 해당 이벤트의 시작일 이후이고, 종료일 이전인지 확인
                            if (day.isAfter(startDate.add(const Duration(
                                    hours: -9))) // 달력 마커에는 9시간 빠르게 설정
                                &&
                                day.isBefore(endDate)) {
                              // 현재 날짜가 해당 이벤트의 기간 내에 있는 경우, 이벤트 이름을 리스트에 추가
                              events.add(vote.subjectTitle);
                            }
                          }
                        }
                      }
                      return events; // voteList에 정의된 이벤트가 있는 날짜에만 해당 이벤트가 표시
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonTextStyle: TextStyle(
                        // 주차(week) 색상
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ),
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
