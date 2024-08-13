import 'package:flutter/material.dart';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/screens/makeTeam_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/all/providers/announcement_provider.dart';
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

  // 조회된 팀원 모집글을 저장하는 리스트
  List<MakeTeam> _filteredMakeTeams = [];

  // 버튼 클릭 시 팀원 모집글을 조회하는 함수
  void fetchMakeTeams() async {
    // await Provider.of<MakeTeamProvider>(context, listen: false).fetchMakeTeam();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: posts.map((post) {
        // endTime 리스트 형식으로 변환하여 월과 일만 추출
        List<String> endTimeParts =
            post.endTime.replaceAll(RegExp(r'\[|\]'), '').split(',');
        // createdTime을 리스트 형식으로 변환하여 년, 월, 일만 추출
        List<String>? createdTimeParts =
            post.createdTime?.replaceAll(RegExp(r'\[|\]'), '').split(',');

        return GestureDetector(
          onTap: () async {
            await Provider.of<MakeTeamProvider>(context, listen: false)
                .fetchMakeTeam();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecruitDetailPage(makeTeam: post), // MakeTeam 객체 전달
              ),
            );
          },
          child: Container(
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
                      post.memberName ?? 'Unknown', // 모집글 작성자 이름을 표시
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    if (createdTimeParts != null) ...[
                      Text(
                        '${createdTimeParts[0].trim()}/${createdTimeParts[1].trim()}/${createdTimeParts[2].trim()}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 3),
                    ],
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
                      '~${endTimeParts[1].trim()}/${endTimeParts[2].trim()}까지',
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
          ),
        );
      }).toList(),
    );
  }

  // 선택된 버튼에 따라 다른 콘텐츠를 반환하는 함수
  Widget buildContent() {
    if (_filteredMakeTeams.isEmpty) {
      return const Center(child: Text('선택된 카테고리에 모집글이 없습니다.'));
    }

    return _buildPostContent(_filteredMakeTeams);
  }

  void selectCateMenu(BuildContext context) {
    // AnnouncementProvider에서 카테고리 리스트를 가져옴
    final categoryList =
        Provider.of<AnnouncementProvider>(context, listen: false).categoryList;

    // showMenu 함수를 사용하여 팝업 메뉴를 화면에 띄움
    showMenu(
      context: context,
      // 메뉴가 화면에 나타나는 위치 RelativeRect
      position: const RelativeRect.fromLTRB(287, 200, 900, 500),
      // 팝업 메뉴에 들어갈 항목
      items: <PopupMenuEntry<String>>[
        // categoryList의 각 항목에 대해 반복 작업을 수행 후 팝업 메뉴 항목으로 추가
        for (int i = 0; i < categoryList.length; i++)
          popUpItem(categoryList[i], categoryList[i]),

        // categoryList가 비어있지 않은 경우, 마지막에 Divider를 추가
        if (categoryList.isNotEmpty) const PopupMenuDivider(),
      ],
    ).then((selectedItem) {
      // 사용자가 항목을 선택했고, 그 항목이 categoryList에 존재하는 경우
      if (selectedItem != null && categoryList.contains(selectedItem)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MakeTeamPage(
              initialCategory: selectedItem, // 선택된 항목을 초기 카테고리로 전달
            ),
          ),
        );
      }
    });
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
                      if (item == '모집글 작성') {
                        selectCateMenu(context); // 새로운 팝업 메뉴 생성
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        popUpItem('URL 공유', 'URL 공유'),
                        const PopupMenuDivider(),
                        popUpItem('모집글 작성', '모집글 작성'),
                      ];
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
