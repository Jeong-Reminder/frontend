import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/widgets/account_widget.dart';
import 'package:frontend/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOwnerPage extends StatefulWidget {
  const MyOwnerPage({super.key});

  @override
  State<MyOwnerPage> createState() => _MyOwnerPageState();
}

class _MyOwnerPageState extends State<MyOwnerPage> {
  final FixedExtentScrollController controller =
      FixedExtentScrollController(initialItem: 1); // 초기값 지정

  bool isOpened = false;

  List<String> semesterList = []; // 연도-학기 리스트
  List<String> createdTimeList = []; // 게시글 생성 리스트
  List<Map<String, dynamic>> boardList = []; // 전체 게시글
  List<Map<String, dynamic>> selectedBoardList = []; // 선택된 학기에 해당하는 게시글 리스트

  // 영어 카테고리를 한국어로 전환하는 문자열 함수
  String engToKorCate(String engCategory) {
    if (engCategory == 'SEASONAL_SYSTEM') {
      return '계절제';
    } else if (engCategory == 'CONTEST') {
      return '경진대회';
    } else if (engCategory == 'ACADEMIC_ALL') {
      return '학년';
    } else if (engCategory == 'CORPORATE_TOUR') {
      return '기업';
    } else {
      return 'null';
    }
  }

  // 연도와 학기를 추출하는 함수
  List<String> formatYearSemester(List<String> dateTimeList) {
    Set<String> semesterSet = {}; // 중복을 제거하기 위해 Set 사용

    for (var dateTime in dateTimeList) {
      DateTime parsedDateTime =
          DateTime.parse(dateTime); // String을 DateTime 객체로 변환
      final DateFormat formatter = DateFormat('yyyy'); // 연도 추출
      String year = formatter.format(parsedDateTime); // 예: 2024

      // 학기 분류
      int month = parsedDateTime.month; // 월 출력
      int day = parsedDateTime.day; // 일 출력
      String semester; // 학기

      if (month < 7 || (month == 7 && day <= 15)) {
        semester = '$year년 1학기';
      } else {
        semester = '$year년 2학기';
      }

      semesterSet.add(semester); // Set에 학기 추가
    }

    List<String> semesterList = semesterSet.toList();
    semesterList.sort(); // 학기 리스트를 오름차순으로 정렬

    return semesterList; // 정렬된 리스트를 반환
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards(); // 전체 게시글 조회 호출

      setState(() {
        boardList = Provider.of<AnnouncementProvider>(context, listen: false)
            .boardList; // 전체 게시글 생성

        createdTimeList = boardList
            .map((board) => board['createdTime'] as String)
            .toList(); // 게시글 생성시간 생성

        semesterList = formatYearSemester(createdTimeList); // 학기 리스트 생성
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        leadingWidth: 120, // leading에 있는 위젯 크게 만들기 위한 코드
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              print('semesterList: ${formatYearSemester(createdTimeList)}');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필
                  const Profile(
                    profileUrl: 'assets/images/profile.png',
                    name: '홍길동',
                    status: 'Admin',
                    showSubTitle: false,
                    studentId: '2090',
                  ),
                  const SizedBox(height: 25),

                  // 작성 내역 버튼
                  Row(
                    children: [
                      const Text(
                        '작성 내역',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isOpened = true;
                          });

                          if (isOpened == true) {
                            boardHistory(context).whenComplete(() {
                              // 바텀 모달시트를 닫을 때 whenComplete 메서드를 통해 isOpened를 false로 설정
                              setState(() {
                                isOpened = false;
                              });
                            });
                          }
                        },
                        icon: Icon(
                          isOpened ? Icons.expand_less : Icons.expand_more,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 선택된 게시글
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedBoardList.length,
                      itemBuilder: (context, index) {
                        final selectedBoard = selectedBoardList[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                '[ ${engToKorCate(selectedBoard['announcementCategory'])} ]',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text(selectedBoard['announcementTitle']),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: AccountWidget(),
          ),
        ],
      ),
    );
  }

  // 작성 내역 선택 함수
  Future<dynamic> boardHistory(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: CupertinoPicker.builder(
            scrollController: controller,
            itemExtent: 50,
            childCount: semesterList.length,
            onSelectedItemChanged: (i) {
              String selectedSemester = semesterList[i];

              setState(() {
                // 게시글 생성시간을 연도-학기로 추출해 semesterList와 동일한 요소가 있는지 확인
                // 동일한게 확인되면 selectedBoardList에 저장
                selectedBoardList = boardList.where((board) {
                  DateTime parsedDateTime =
                      DateTime.parse(board['createdTime']);
                  String year = DateFormat('yyyy').format(parsedDateTime);
                  String semester;

                  int month = parsedDateTime.month;
                  int day = parsedDateTime.day;

                  if (month < 7 || (month == 7 && day <= 15)) {
                    semester = '$year년 1학기';
                  } else {
                    semester = '$year년 2학기';
                  }

                  return selectedSemester == semester;
                }).toList();
              });
            },
            itemBuilder: (context, index) {
              if (index >= 0 && index < semesterList.length) {
                return Center(
                  child: Text(semesterList[index]),
                );
              } else {
                return null; // 혹시 잘못된 인덱스를 참조할 경우 null 반환
              }
            },
          ),
        );
      },
    );
  }
}
