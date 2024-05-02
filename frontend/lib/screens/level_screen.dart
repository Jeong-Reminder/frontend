import 'package:flutter/material.dart';
import 'package:frontend/widgets/levelBtn_widget.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  final List<Map<String, dynamic>> oneBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
    },
    {
      'title': '새내기 게시판',
      'subtitle': '수강 신청 하는 방법 알려주세요',
      'content': '수강 신청 잘 할 수 있을까요?',
    },
    {
      'title': '제자반 채플 자주 묻는 질문',
      'subtitle': '채플 담당 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '학년 공지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                LevelBtn(level: '1학년'),
                SizedBox(width: 5),
                LevelBtn(level: '2학년'),
                SizedBox(width: 5),
                LevelBtn(level: '3학년'),
                SizedBox(width: 5),
                LevelBtn(level: '4학년'),
              ],
            ),
            const SizedBox(height: 13),
            Expanded(
              child: ListView.builder(
                itemCount: oneBoard.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        color: const Color(0xFFFAFAFE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 18.0),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                oneBoard[index]['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                oneBoard[index]['subtitle'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                oneBoard[index]['content'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7D7D7F),
                                ),
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    color: Color(0xFFEA4E44),
                                  ),
                                  Text('4'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
