import 'package:flutter/material.dart';
import 'package:frontend/screens/makeTeam_screen.dart';
import 'package:frontend/screens/recruitDetail_screen.dart';

class MemberRecruitPage extends StatefulWidget {
  const MemberRecruitPage({super.key});

  @override
  State<MemberRecruitPage> createState() => _MemberRecruitPageState();
}

// 모집글 클래스 정의
class RecruitmentPost {
  final String title;
  final String author;
  final String date;
  final String time;
  final String content;
  final int currentMembers;
  final int maxMembers;

  RecruitmentPost({
    required this.title,
    required this.author,
    required this.date,
    required this.time,
    required this.content,
    required this.currentMembers,
    required this.maxMembers,
  });
}

// 팝업 메뉴 아이템을 생성하는 함수
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

// 팝업 메뉴 항목 열거형 정의
enum PopUpItem { popUpItem1, popUpItem2 }

class _MemberRecruitPageState extends State<MemberRecruitPage> {
  String selectedButton = ''; // 초기에는 아무 페이지 선택이 안 되어있는 상태
  List<RecruitmentPost> iotPosts = [
    // IOT 경진대회 모집글 리스트
    RecruitmentPost(
      title: '[ IoT 통합 설계 경진대회 ] 팀원 모집합니다!!',
      author: '이승욱',
      date: '23/10/21',
      time: '10:57',
      content: '경진대회 나가고 싶은데 인원이 부족해서 관심 있으신 분들과 같이 나가고 싶어요',
      currentMembers: 3,
      maxMembers: 4,
    ),
    RecruitmentPost(
      title: '[ IoT 통합 설계 경진대회 ] 팀원 모집합니다!!',
      author: '소진수',
      date: '23/10/21',
      time: '10:57',
      content: '경진대회 나가고 싶은데 인원이 부족해서 관심 있으신 분들과 같이 나가고 싶어요',
      currentMembers: 2,
      maxMembers: 4,
    ),
    RecruitmentPost(
      title: '[ IoT 통합 설계 경진대회 ] 팀원 모집합니다!!',
      author: '민택기',
      date: '23/10/21',
      time: '10:57',
      content: '경진대회 나가고 싶은데 인원이 부족해서 관심 있으신 분들과 같이 나가고 싶어요',
      currentMembers: 4,
      maxMembers: 4,
    ),
  ];

  // 모집글 리스트를 현재 모집 인원 수 기준으로 정렬하는 함수
  void sortPostsByMembers() {
    setState(() {
      if (selectedButton == 'IOT') {
        iotPosts.sort((a, b) => a.currentMembers.compareTo(b.currentMembers));
      }
      // 뉴테크, 보안 때도 필요하다면 같은 형식으로 코드 구현
    });
  }

  // 선택된 버튼에 따라 다른 콘텐츠를 반환하는 함수
  Widget buildContent() {
    switch (selectedButton) {
      case 'IOT':
        return _buildIOTContent();
      case '뉴테크':
        return _buildNewTechContent();
      case '보안':
        return _buildSecurityContent();
      default:
        return Container();
    }
  }

  // IOT 콘텐츠를 빌드하는 함수
  Widget _buildIOTContent() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecruitDetailPage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: iotPosts.map((post) {
          return Container(
            width: 341,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10), // 포스트 사이의 간격 조정
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color(0xFFFAFAFE),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.date,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      post.time,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '모집 인원 ${post.currentMembers}/${post.maxMembers}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '~10/28까지',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBE7FB),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    '벡엔드',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBE7FB),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    '프론트',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 20,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBE7FB),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    '디자이너',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 뉴테크 콘텐츠를 빌드하는 함수
  Widget _buildNewTechContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 341,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xFFFAFAFE),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '[ 뉴테크 경진대회 ] 팀원 모집합니다!!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Row(
                children: [
                  Text(
                    '장찬현',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '23/10/21 ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    '10:57 ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '경진대회 나가고 싶은데 인원이 부족해서 관심 있으신 분들과 같이 나가고 싶어요',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '모집 인원 2/4',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '~10/28까지',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '벡엔드',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '프론트',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 90,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '디자이너',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 보안 콘텐츠를 빌드하는 함수
  Widget _buildSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 341,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xFFFAFAFE),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '[ 보안 경진대회 ] 팀원 모집합니다!!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Row(
                children: [
                  Text(
                    '유다은',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '23/10/21 ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    '10:57 ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '경진대회 나가고 싶은데 인원이 부족해서 관심 있으신 분들과 같이 나가고 싶어요',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '모집 인원 2/4',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '~10/28까지',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '벡엔드',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '프론트',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 90,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '디자이너',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        leadingWidth: 120,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/myuser');
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        '팀원 모집',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          sortPostsByMembers();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Image(
                            image: AssetImage('assets/images/filtering.png'),
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<PopUpItem>(
                    color: const Color(0xFFEFF0F2),
                    onSelected: (PopUpItem item) {
                      if (item == PopUpItem.popUpItem2) {
                        // 모집글 작성 PopUpItem 클릭 시 팀원 모집글 작성 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MakeTeamPage(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        popUpItem('URL 공유', PopUpItem.popUpItem1),
                        const PopupMenuDivider(),
                        popUpItem('모집글 작성', PopUpItem.popUpItem2),
                      ];
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = 'IOT'; // IOT 경진대회 클릭 시
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE7FB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'IOT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedButton == 'IOT'
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = '뉴테크'; // 뉴테크 경진대회 클릭 시
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE7FB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '뉴테크',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedButton == '뉴테크'
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = '보안'; // 보안 경진대회 클릭 시
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE7FB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '보안',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedButton == '보안'
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildContent(), // 해당 경진대회에 따라 다른 콘텐츠 표시
            ],
          ),
        ),
      ),
    );
  }
}
