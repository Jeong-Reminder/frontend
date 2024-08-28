import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/widgets/account_widget.dart';
import 'package:frontend/widgets/profile_widget.dart';

class MyOwnerPage extends StatefulWidget {
  const MyOwnerPage({super.key});

  @override
  State<MyOwnerPage> createState() => _MyOwnerPageState();
}

class _MyOwnerPageState extends State<MyOwnerPage> {
  bool isOpened = false;

  List<dynamic> pickedHistory = [];
  List<Map<String, dynamic>> history = [
    {
      'year': '2020년도',
      'board': [
        {
          'category': '전체 공지',
          'title': '수강신청 하는 법',
        },
        {
          'category': '전체 공지',
          'title': '중간강의평가',
        },
        {
          'category': '경진 대회',
          'title': 'IOT 경진대회 참가 모집',
        }
      ],
    },
    {
      'year': '2021년도',
      'board': [],
    },
    {
      'year': '2022년도',
      'board': [],
    },
    {
      'year': '2023년도',
      'board': [],
    },
  ];

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: pickedHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.edit),
                          title: Text(
                            '[ ${pickedHistory[index]['category']} ]',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(pickedHistory[index]['title']),
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
            itemExtent: 50,
            childCount: history.length,
            onSelectedItemChanged: (i) {
              if (i >= 0 && i < history.length) {
                setState(() {
                  pickedHistory = history[i]['board'];
                });
              }
            },
            itemBuilder: (context, index) {
              if (index >= 0 && index < history.length) {
                return Center(
                  child: Text(history[index]['year']),
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
