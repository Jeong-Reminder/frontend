import 'package:flutter/material.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/screens/makeTeam_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
  bool isLoading = false; // 로딩 상태를 관리하는 변수

  List<Map<String, dynamic>> filteredBoardList = [];
  List<Map<String, dynamic>> recruitList = []; // 조회된 팀원 모집글을 저장하는 리스트
  List<Map<String, dynamic>> cateBoardList = [];

  int? announcementId; // 모집글 작성에 사용할 게시글 아이디

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

        setState(() {
          cateBoardList =
              Provider.of<AnnouncementProvider>(context, listen: false)
                  .cateBoardList;
        });

        print('cateBoardList: $cateBoardList');
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
            print('post id: ${post['id']}');

            final result = await Get.toNamed(
              '/detail-recruit',
              arguments: {'makeTeamId': post['id']},
              preventDuplicates: false,
            );

            // 만약 전달받은 값이 true라면 해당 post를 리스트에서 제거
            if (result == true) {
              setState(() {
                recruitList.remove(post);
              });
            } else if (result is List<Map<String, dynamic>>) {
              // 만약 반환된 값이 업데이트된 acceptMemberList라면, UI를 업데이트
              setState(() {
                post['acceptMemberList'] = result;
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
                      '모집 인원 ${post['acceptMemberList'] is List ? post['acceptMemberList'].length : 0}/${post['studentCount'].toString()}', // 모집 인원
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
                    // hopeField를 개별적으로 처리하여 가로 스크롤 가능한 위젯 생성
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
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
                              .toList(), // List<Widget> 생성
                        ),
                      ),
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
    // 로딩 중일 때 로딩 인디케이터 표시
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2A72E7),
        ),
      );
    }

    // 공지글이 아예 없는 경우
    if (cateBoardList.isEmpty) {
      return const Center(
        child: Text('작성된 카테고리가 없습니다'),
      );
    }

    // 사용자가 아무 버튼도 선택하지 않은 경우
    if (selectedButton.isEmpty) {
      return const Center(child: Text('원하는 카테고리를 선택하세요'));
    }

    // 선택한 카테고리에 모집글이 없는 경우
    if (recruitList.isEmpty) {
      return const Center(child: Text('선택한 카테고리에 작성된 모집글이 없습니다'));
    }

    // 사용자가 버튼을 선택했고 모집글이 있는 경우
    return _buildPostContent(recruitList);
  }

  // 팀원 모집글 데이터를 불러오는 함수
  Future<void> fetchRecruitData(int boardId) async {
    setState(() {
      isLoading = true; // 데이터를 가져오는 동안 로딩 상태로 설정
    });

    try {
      await Provider.of<MakeTeamProvider>(context, listen: false)
          .fetchcateMakeTeam(boardId);

      setState(() {
        recruitList =
            Provider.of<MakeTeamProvider>(context, listen: false).cateList;

        // 모집글을 작성일 기준으로 내림차순 정렬 (가장 최근 글이 위로 오도록)
        recruitList.sort((a, b) {
          DateTime createdTimeA = DateTime.parse(a['createdTime']);
          DateTime createdTimeB = DateTime.parse(b['createdTime']);
          return createdTimeB.compareTo(createdTimeA); // 내림차순
        });

        // 모집 종료 날짜가 지난 글을 삭제
        DateTime now = DateTime.now();
        recruitList.removeWhere((post) {
          DateTime endTime = DateTime.parse(post['endTime']);
          return endTime.isBefore(now); // 현재 시간보다 모집 종료 날짜가 이전이면 삭제
        });

        print("Expired posts removed. Remaining posts: $recruitList");
      });
    } catch (e) {
      print("Error fetching recruit data: $e");
    } finally {
      setState(() {
        isLoading = false; // 데이터를 다 가져온 후 로딩 상태 해제
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryList =
        Provider.of<AnnouncementProvider>(context).categoryList;

    final cateBoardList =
        Provider.of<AnnouncementProvider>(context).cateBoardList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
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

                print('recruitList: $recruitList');
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
                  const Row(
                    children: [
                      Text(
                        '팀원 모집',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // 팝업 메뉴
                  PopupMenuButton<String>(
                    color: const Color(0xFFEFF0F2),
                    onSelected: (String item) async {
                      if (item == '모집글 작성') {
                        // 이전에 선택한 카테고리가 있을 경우 실행
                        if (selectedButton.isNotEmpty) {
                          final matchedBoard = cateBoardList.firstWhere(
                            // 선택한 카테고리와 일치하는 게시글을 찾음
                            (cateBoard) =>
                                selectedButton ==
                                _parseCategoryName(
                                    cateBoard['announcementTitle']),
                            orElse: () =>
                                <String, dynamic>{}, // 일치하는 항목이 없으면 빈 객체 반환
                          );
                          final announcementId =
                              matchedBoard['id'] as int? ?? 0; // null이면 0으로 처리
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MakeTeamPage(
                                initialCategory: selectedButton,
                                announcementId: announcementId,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      // userRole에 따라 메뉴 항목을 다르게 표시
                      if (userRole == 'ROLE_ADMIN') {
                        return <PopupMenuEntry<String>>[
                          popUpItem('URL 공유', 'URL 공유'),
                          const PopupMenuDivider(), // 구분선 추가
                          if (selectedButton.isEmpty)
                            // 선택된 카테고리가 없을 경우, 모집글 전체 삭제 버튼만 표시 (구분선 없음)
                            popUpItem('모집글 전체 삭제', '모집글 전체 삭제'),
                          if (selectedButton.isNotEmpty) ...[
                            // 선택한 카테고리가 있을 경우, 해당 카테고리 삭제 버튼 표시 및 구분선 추가
                            popUpItem('모집글 전체 삭제', '모집글 전체 삭제'),
                            const PopupMenuDivider(), // 구분선 추가
                            popUpItem('$selectedButton 삭제', '카테고리 삭제'),
                          ]
                        ];
                      } else {
                        // 일반 사용자일 경우 표시되는 메뉴 항목
                        return <PopupMenuEntry<String>>[
                          popUpItem('URL 공유', 'URL 공유'),
                          if (selectedButton.isNotEmpty) ...[
                            const PopupMenuDivider(),
                            popUpItem('모집글 작성', '모집글 작성'),
                          ]
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
                children: categoryList.toSet().map((label) {
                  // 중복 제거를 위해 toSet() 사용
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = label;
                        recruitList.clear(); // 이전 모집글을 지워줌
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

  // recruitment 전체 삭제 다이얼로그
  Future<dynamic> deleteDialog(BuildContext context, String range,
      [String? category]) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: const Icon(
            Icons.question_mark_rounded,
            size: 40,
            color: Color(0xFF2A72E7),
          ),
          // 메인 타이틀
          title: const Column(
            children: [
              Text("정말 삭제하시겠습니까?"),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "실수일 수도 있으니까요",
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 20),
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // 전체 삭제일 경우
                    if (range == 'total') {
                      await AdminProvider().deleteAllRecruitments();
                    }
                    // 개별 삭제일 경우
                    else if (range == 'individual' && category != null) {
                      await AdminProvider().deleteCateRecruitment(category);
                    }

                    if (context.mounted) {
                      // Future.wait : 여러 비동기 작업을 병렬로 실행
                      await Future.wait([
                        Provider.of<AnnouncementProvider>(context,
                                listen: false)
                            .fetchContestCate(),

                        // for문을 돌려 계속 카테고리별 조회 api를 사용해서 id만 가져와 fetchcateMakeTeam api 호출
                        for (var cateBoard in cateBoardList)
                          Provider.of<MakeTeamProvider>(context, listen: false)
                              .fetchcateMakeTeam(cateBoard['id']),
                      ]);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 20),
                  ),
                  child: const Text(
                    '삭제',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
