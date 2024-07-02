import 'package:flutter/material.dart';
import 'package:frontend/screens/memberRecruit_screen.dart';
import 'package:frontend/screens/teamMember_screen.dart';

class CompetitionNoticePage extends StatefulWidget {
  const CompetitionNoticePage({super.key});

  @override
  State<CompetitionNoticePage> createState() => _CompetitionNoticePageState();
}

PopupMenuItem<PopUpItem> popUpItem(String text, PopUpItem item) {
  return PopupMenuItem<PopUpItem>(
    enabled: true,
    onTap: () {},
    value: item,
    height: 25,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

enum PopUpItem { popUpItem1 }

class _CompetitionNoticePageState extends State<CompetitionNoticePage> {
  int? _selectedIndex = 0; // 유효한 인덱스 계산

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // index 0인 경우 팀원 모집 페이지로 이동 -> 팀원 모집 클릭 시
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MemberRecruitPage()),
        );
        break;
      case 1: // index 1인 경우 팀원 현황 페이지로 이동 -> 팀원 현황 클릭 시
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeamMemberPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(right: 40.0),
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        leadingWidth: 120,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'IoT 통합 설계 경진대회',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<PopUpItem>(
                    color: const Color(0xFFEFF0F2),
                    itemBuilder: (BuildContext context) {
                      return [
                        popUpItem('URL 공유', PopUpItem.popUpItem1),
                      ];
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 341,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xFFFAFAFE),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            height: 1.8,
                          ),
                          children: [
                            TextSpan(
                              text: '- 신청기간: ~4/12(금)\n',
                              style: TextStyle(
                                color: Color(0xFFF70716),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '- 대회 목적: 서로 다른 학년끼리 팀을 이뤄 IT, 정보통신 관련(앱, 웹, 아두이노 등)으로 협력하는 과정에서 전공지식을 주고 받고 다양한 문제를 해결하는 능력을 기르는 것\n'
                                  '- 제출물: 설계제안서, 제안서 발표영상(5분 이내)\n\n'
                                  '* 신청방법: ',
                            ),
                            TextSpan(
                              text: '206sku@naver.com',
                              style: TextStyle(
                                color: Color(0xFF1D0AF8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '으로 학번, 학년, 이름 보내주세요.\n'
                                  '* 개인참여신청: !!신청 확인 후 팀을 묶어드립니다!!\n',
                            ),
                            TextSpan(
                              text: '* 팀 신청: 이메일로 팀원 학번, 학년, 이름을 보내주세요.\n\n'
                                  '▶ 결과물이 있을 경우 장학금에 유리합니다.\n'
                                  '▶ 다학년, 다인원(최대 5명)으로 팀원을 구성할 경우 가산점이 부여됩니다.\n'
                                  '▶ IoT 통합 설계 경진대회의 우수작 예시를 첨부해놓은 공지사항입니다. 확인 후 신청 부탁드립니다.\n'
                                  'https://www.sungkyul.ac.kr/sungkyulice/4167/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGc3VuZ2t5dWxpY2UlMkYxMzc3JTJGMzQzODclMkZhcnRjbFZpZXcuZG8lM0Y%3D',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: SizedBox(
                        width: 346,
                        height: 194,
                        child: Image.asset(
                          'assets/images/contestnotice.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFAFAFE),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '팀원 모집',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '팀원 현황',
          ),
        ],
        currentIndex: _selectedIndex ?? 0,
        selectedItemColor: const Color(0xFF2A72E7),
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
