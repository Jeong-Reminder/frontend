import 'package:flutter/material.dart';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';
import 'package:frontend/all/providers/announcement_provider.dart';
import 'package:frontend/screens/makeTeam_screen.dart';
import 'package:frontend/screens/recruitDetail_screen.dart';

class MemberRecruitPage extends StatefulWidget {
  const MemberRecruitPage({super.key});

  @override
  State<MemberRecruitPage> createState() => _MemberRecruitPageState();
}

// 팝업 메뉴 아이템을 생성하는 함수
PopupMenuItem<String> popUpItem(String text, String item) {
  return PopupMenuItem<String>(
    enabled: true,
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

class _MemberRecruitPageState extends State<MemberRecruitPage> {
  String selectedButton = ''; // 초기에는 아무 페이지 선택이 안 되어있는 상태
  String? name; // 사용자 이름을 저장할 변수 추가

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // 로그인 정보에서 이름을 가져옴
  }

  // 조회된 팀원 모집글을 저장하는 리스트
  List<MakeTeam> _filteredMakeTeams = [];

  // 로그인 정보에서 이름을 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      name = credentials['name']; // 로그인 정보에서 name를 가져와 저장
    });
  }

  // 버튼 클릭 시 팀원 모집글을 조회하는 함수
  void fetchMakeTeams() async {
    await Provider.of<MakeTeamProvider>(context, listen: false).fetchMakeTeam();

    setState(() {
      final makeTeams =
          Provider.of<MakeTeamProvider>(context, listen: false).makeTeams;

      // 선택된 버튼에 따라 필터링
      _filteredMakeTeams = makeTeams.where((team) {
        return selectedButton.isEmpty ||
            team.recruitmentCategory == selectedButton;
      }).toList();
    });

    if (_filteredMakeTeams.isEmpty) {
      print('선택된 카테고리에 모집글이 없습니다.');
    } else {
      print('Filtered MakeTeams: ${_filteredMakeTeams.length}');
    }
  }

  // 모집글을 지정된 형식으로 빌드하는 함수
  Widget _buildPostContent(List<MakeTeam> posts) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecruitDetailPage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: posts.map((post) {
          return Container(
            width: 341,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10), // 포스트 간격 조정
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color(0xFFFAFAFE),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.recruitmentTitle, // 모집글 제목
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      name ?? 'Unknown', // 로그인 정보에서 가져온 이름을 표시
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post.recruitmentContent, // 모집글 내용
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '모집 인원 ${post.studentCount}/4', // 모집 인원
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.endTime, // 모집 종료 시간
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // hopeField를 개별적으로 처리하여 위젯 생성
                    Wrap(
                      spacing: 6.0,
                      children: post.hopeField.split(',').map((field) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBE7FB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            field.trim(), // 각 hopeField 항목
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
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

  // 선택된 버튼에 따라 다른 콘텐츠를 반환하는 함수
  Widget buildContent() {
    if (_filteredMakeTeams.isEmpty) {
      return const Center(child: Text('선택된 카테고리에 모집글이 없습니다.'));
    }

    return _buildPostContent(_filteredMakeTeams);
  }

  @override
  Widget build(BuildContext context) {
    final categoryList =
        Provider.of<AnnouncementProvider>(context).categoryList;

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
                        onTap: () {},
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
                  PopupMenuButton<String>(
                    color: const Color(0xFFEFF0F2),
                    onSelected: (String item) {
                      if (categoryList.contains(item)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MakeTeamPage(
                              initialCategory: item, // 초기 카테고리 전달
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      final items = <PopupMenuEntry<String>>[
                        popUpItem('URL 공유', 'URL 공유'),
                        const PopupMenuDivider(),
                        popUpItem('모집글 작성', '모집글 작성'),
                        const PopupMenuDivider(),
                      ];

                      // categoryList의 각 항목에 대해 반복 작업 수행
                      for (int i = 0; i < categoryList.length; i++) {
                        // categoryList의 i번째 항목을 팝업 메뉴 항목으로 추가
                        items.add(popUpItem(categoryList[i], categoryList[i]));

                        // 마지막 항목이 아닌 경우, 항목 사이에 구분선(PopupMenuDivider)을 추가
                        if (i < categoryList.length - 1) {
                          items.add(const PopupMenuDivider());
                        }
                      }

                      return items; // 팝업 메뉴 항목 리스트를 반환
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: categoryList.map((label) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = label; // 버튼 클릭 시 선택된 버튼으로 업데이트
                        fetchMakeTeams(); // 필터링할 때마다 조회
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBE7FB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedButton == label
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
