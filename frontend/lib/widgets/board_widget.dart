import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/screens/boardDetail_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Board extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;
  final bool
      total; // level과 memberLevel이 맞는 공지사항만 필터링하는 작업을 할 것인지 여부(true일 때 필터링 작업 진행)
  final Function(Map<String, dynamic> board)? onBoardSelected; // 선택된 게시글 콜백 함수
  // bool? isHidden =
  //     false; // 숨긴 게시글인지 아닌지 여부(숨긴 게시글일 경우 detailBoard 페이지로 이동 못하게 설정)
  final String category;

  const Board({
    super.key,
    required this.boardList,
    required this.total,
    this.onBoardSelected,
    required this.category,
  });

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final prefs = SharedPreferences.getInstance();
  bool isPressed = false; // 길게 눌렀는지 여부

  int count = 4; // 좋아요 개수
  int? level;
  int? selectedBoardIndex; // 선택된 게시글의 인덱스를 저장할 변수

  String userRole = '';

  List<Map<String, dynamic>> boardList = []; // widget.boardList 저장할 변수
  List<Map<String, dynamic>> filteredBoardList = [];

  @override
  void initState() {
    super.initState();
    // boardList = widget.boardList;
    _loadCredentials(); // 학번을 로드하는 메서드 호출
  }

  // 학번, 이름, 재적상태를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      level = credentials['level']; // 로그인 정보에 있는 level(학년)을 가져와 저장
      userRole = credentials['userRole'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // 필터링 여부가 true와 사용자일 경우에만 공지사항 필터링 진행(관리자는 모든 공지를 다 보여줘야하기 때문에 필터링 진행할 이유 없음)
    if (widget.total && userRole == 'ROLE_USER') {
      setState(() {
        // 공지글이 사용자의 학년과 같거나 공지 설정 학년이 0일때 filteredBoardList에 저장
        filteredBoardList = widget.boardList.where((board) {
          final announcementLevel = board['announcementLevel'];
          return announcementLevel == level || announcementLevel == 0;
        }).toList();
      });

      // 만약 필터링된 리스트가 비어 있다면 텍스트 표시
      if (filteredBoardList.isEmpty) {
        return const Center(
          child: Text(
            '해당 학생의 공지가 없습니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        );
      }
    } else if (widget.boardList.isEmpty) {
      return const Center(
        child: Text(
          '해당 학생의 공지가 없습니다.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );
    }

    // 공지사항을 createdTime으로 정렬 (내림차순으로 최신부터)
    final sortedBoardList = (widget.total && userRole == 'ROLE_USER')
        ? filteredBoardList
        : widget.boardList;
    sortedBoardList.sort((a, b) {
      DateTime createdTimeA =
          DateTime.parse(a['createdTime']); // 작성 시간은 DateTime으로 변환
      DateTime createdTimeB = DateTime.parse(b['createdTime']);
      return createdTimeB
          .compareTo(createdTimeA); // b가 a보다 더 최근일 경우 양수를 반환(즉, 최신순 정렬)
      // 반환값이 양수이면, 순서가 바뀌고 음수이면, 순서가 바뀌지 않음
    });

    // 필터링된 공지사항 리스트를 화면에 표시
    return ListView.builder(
      itemCount: sortedBoardList.length,
      shrinkWrap: true, // 높이를 자동으로 조절
      itemBuilder: (context, index) {
        final board = sortedBoardList[index];
        final category = _getCategoryName(board['announcementCategory']);
        // final isSelected = selectedBoardIndex == index; // 현재 게시글이 선택된 게시글인지 확인

        return Column(
          children: [
            GestureDetector(
              // 게시글 들어갈 때
              onTap: () async {
                await Provider.of<AnnouncementProvider>(context, listen: false)
                    .fetchOneBoard(board['id']);

                if (context.mounted) {
                  if (widget.category == 'HIDDEN') {
                    alertSnackBar(context, '숨긴 게시글은 조회할 수 없습니다.');
                  } else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardDetailPage(
                          announcementId: board['id'],
                          category: widget.category,
                        ),
                      ),
                    );
                  }
                }
              },

              // 숨김/삭제 버튼 띄울 때
              onLongPress: () async {
                if (widget.category == 'HIDDEN') {
                  if (selectedBoardIndex != null) {
                    setState(() {
                      selectedBoardIndex = null;
                    });
                  } else {
                    setState(() {
                      selectedBoardIndex = index; // 선택된 게시글의 인덱스를 저장
                    });
                  }
                  print('selectedBoardIndex: $selectedBoardIndex');

                  if (widget.onBoardSelected != null) {
                    widget.onBoardSelected!(board); // 선택된 게시글 콜백 호출
                  }

                  print('selectedBoard: ${board['announcementTitle']}');
                }
              },
              child: Card(
                color: const Color(0xFFFAFAFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: (selectedBoardIndex == index)
                        ? Colors.blue
                        : Colors.transparent, // 선택된 경우 테두리 색상 적용
                    width: 1.0,
                  ),
                ),
                elevation: 0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 18.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Flexible 위젯을 사용하는 이유는 제목 옆에 카테고리가 붙어있어야 하기 때문
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: board['announcementTitle'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF7D7D7F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                          text: board['announcementContent'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'CONTEST':
        return '경진대회';
      case 'CORPORATE_TOUR':
        return '기업';
      case 'SEASONAL_SYSTEM':
        return '계절제';
      case 'ACADEMIC_ALL':
        return '학년';
      default:
        return category; // 변환되지 않은 경우 원래 값을 반환
    }
  }
}

// 팝업 알림 위젯
void alertSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: const Duration(seconds: 3), //올라와있는 시간
    ),
  );
}
