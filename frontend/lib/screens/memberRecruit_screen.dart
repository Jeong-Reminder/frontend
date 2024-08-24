import 'package:flutter/material.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/screens/makeTeam_screen.dart';
import 'package:frontend/services/login_services.dart';
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
  String boardCategory = 'CONTEST';
  String? userRole; // 사용자의 역할을 저장할 변수

  List<Map<String, dynamic>> filteredBoardList = [];
  List<Map<String, dynamic>> recruitList = []; // 조회된 팀원 모집글을 저장하는 리스트

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // 사용자 자격증명 로드
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchCateBoard(boardCategory);

      if (context.mounted) {
        Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchContestCate();
      }
    });
  }

  // 회원 정보를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 userRole을 가져와 저장
    });
  }

  // 글 제목에서 대괄호([]) 안의 카테고리 이름을 추출하는 함수
  String _parseCategoryName(String title) {
    final RegExp regExp = RegExp(
      r'\[(.*?)\]',
      caseSensitive: false, // 대소문자 구분 없이 매칭
    );

    final match = regExp.firstMatch(title);

    if (match != null) {
      return match.group(1)?.trim() ?? ''; // 대괄호 안의 문자열을 반환하며, 공백 제거
    }
    return '';
  }

  // 날짜를 "MM/DD일" 형식으로 변환하는 함수
  String formatToMonthDay(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    return "${parsedDate.month}/${parsedDate.day}일";
  }

  // 날짜를 "YYYY/MM/DD" 형식으로 변환하는 함수
  String formatToYearMonthDay(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    return "${parsedDate.year}/${parsedDate.month}/${parsedDate.day}";
  }

  // 모집글을 지정된 형식으로 빌드하는 함수
  Widget _buildPostContent(List<Map<String, dynamic>> posts) {
    return ListView.builder(
      shrinkWrap: true, // 부모 위젯의 크기에 맞추기 위해 shrinkWrap 사용
      physics: const NeverScrollableScrollPhysics(), // 스크롤 문제를 방지하기 위해 비활성화
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        String endTime = formatToMonthDay(post['endTime'] as String);
        String createdTime =
            formatToYearMonthDay(post['createdTime'] as String);

        return GestureDetector(
          onTap: () async {
            // RecruitDetailPage로 이동할 때, await로 결과를 기다림
            final updatedAcceptMemberList = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecruitDetailPage(makeTeam: post),
              ),
            );

            // 만약 전달받은 acceptMemberList가 null이 아니라면, UI를 업데이트
            if (updatedAcceptMemberList != null) {
              setState(() {
                post['acceptMemberList'] = updatedAcceptMemberList;
              });
            }
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
                  post['recruitmentTitle'], // 모집글 제목
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      post['memberName'] ?? 'Unknown', // 모집글 작성자 이름을 표시
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      createdTime, // 생성된 시간 표시
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post['recruitmentContent'], // 모집글 내용
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '모집 인원 ${post['acceptMemberList']?.length ?? 0}/${post['studentCount'].toString()}', // 모집 인원
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '~$endTime까지', // 종료 시간 표시
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    // hopeField를 개별적으로 처리하여 위젯 생성
                    Wrap(
                      spacing: 6.0,
                      children: post['hopeField']
                          .split(',')
                          .map<Widget>((field) => Container(
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
                              ))
                          .toList(), // Make sure this is List<Widget>
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 선택된 버튼에 따라 다른 콘텐츠를 반환하는 함수
  Widget buildContent() {
    // 사용자가 아무 버튼도 선택하지 않은 경우
    if (selectedButton.isEmpty) {
      return const Center(child: Text('원하는 카테고리를 선택하세요'));
    }

    // 선택한 카테고리에 모집글이 없는 경우
    if (recruitList.isEmpty) {
      return const Center(child: Text('선택한 카테고리에 작성된 모집글이 없습니다'));
    }

    return _buildPostContent(recruitList);
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

  // 팀원 모집글 데이터를 불러오는 함수
  Future<void> fetchRecruitData(int boardId) async {
    try {
      await Provider.of<MakeTeamProvider>(context, listen: false)
          .fetchcateMakeTeam(boardId);

      setState(() {
        recruitList =
            Provider.of<MakeTeamProvider>(context, listen: false).cateList;
      });
    } catch (e) {
      print("Error fetching recruit data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryList =
        Provider.of<AnnouncementProvider>(context).categoryList;

    final cateBoardList =
        Provider.of<AnnouncementProvider>(context).cateBoardList;

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
                      // userRole에 따라 메뉴 항목을 다르게 표시
                      if (userRole == 'ROLE_ADMIN') {
                        return <PopupMenuEntry<String>>[
                          popUpItem('URL 공유', 'URL 공유'),
                          const PopupMenuDivider(),
                        ];
                      } else {
                        return <PopupMenuEntry<String>>[
                          popUpItem('URL 공유', 'URL 공유'),
                          const PopupMenuDivider(),
                          popUpItem('모집글 작성', '모집글 작성'),
                        ];
                      }
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
                        selectedButton = label;
                      });

                      filteredBoardList.clear();

                      for (var board in cateBoardList) {
                        if (board['announcementTitle']
                            .contains('[$selectedButton]')) {
                          filteredBoardList.add(board);
                        }
                      }

                      if (filteredBoardList.isNotEmpty) {
                        final boardId = filteredBoardList[0]['id'] is int
                            ? filteredBoardList[0]['id'] as int
                            : int.parse(filteredBoardList[0]['id'].toString());

                        fetchRecruitData(boardId);
                      }
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
