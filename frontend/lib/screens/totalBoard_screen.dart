import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/screens/boardDetail_screen.dart';
import 'package:frontend/screens/hiddenList_screen.dart';
import 'package:frontend/screens/write_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:frontend/widgets/boardAppbar_widget.dart';
import 'package:frontend/widgets/board_widget.dart';
import 'package:provider/provider.dart';

class TotalBoardPage extends StatefulWidget {
  const TotalBoardPage({super.key});

  @override
  State<TotalBoardPage> createState() => _TotalBoardPageState();
}

enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 }

class _TotalBoardPageState extends State<TotalBoardPage> {
  String userRole = '';
  bool isHidDel = false;
  Map<String, dynamic>? selectedBoard; // 선택된 게시글을 저장할 변수

  List<Map<String, dynamic>> boardList = [];

  // 2년 된 게시글 1월 1일에 삭제되는 함수
  void delete2YearsBoard(List<Map<String, dynamic>> boardList) async {
    DateTime now = DateTime.now(); // 현재 시간 생성
    final announcementProvider =
        Provider.of<AnnouncementProvider>(context, listen: false);

    // 현재 시간이 1월 1일인지 확인
    if (now.month == 1 && now.day == 1) {
      for (var board in boardList) {
        final DateTime createdTime =
            DateTime.parse(board['createdTime']); // 게시글 생성시간 생성
        final Duration difference =
            now.difference(createdTime); // 현재시간과 게시글 생성시간 차이

        // 게시글이 2년 지나면 게시글 삭제
        if (difference.inDays >= 730) {
          await announcementProvider.deletedBoard(board['id']);
        }
      }

      // 2년 이상된 게시글을 찾아 삭제를 완료할 경우 전체 게시글 조회
      if (context.mounted) {
        await announcementProvider.fetchAllBoards();
      }
    } else {
      print('오늘은 1월 1일이 아닙니다. 게시글 삭제가 실행되지 않았습니다.');
    }
  }

  @override
  void initState() {
    super.initState();
    // listen: false를 사용하여 initState에서 Provider를 호출
    // addPostFrameCallback 사용하는 이유 : initState에서 직접 Provider.of를 호출할 때 context가 아직 완전히 준비되지 않았기 때문에 발생할 수 있는 에러를 방지
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards();

      if (context.mounted) {
        setState(() {
          boardList = Provider.of<AnnouncementProvider>(context, listen: false)
              .boardList;
        });
      }
    });
    delete2YearsBoard(boardList);
    _loadCredentials();
  }

  // 학번, 이름, 재적상태를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 level를 가져와 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BoardAppbar(
        userRole: userRole,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '전체 공지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 팝업 메뉴 창
                PopupMenuButton<PopUpItem>(
                  color: const Color(0xFFEFF0F2),
                  itemBuilder: (BuildContext context) {
                    return [
                      if (userRole == 'ROLE_ADMIN')
                        popUpItem('글쓰기', PopUpItem.popUpItem1, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BoardWritePage(category: 'TOTAL'),
                            ),
                          );
                        }),
                      if (userRole == 'ROLE_ADMIN') const PopupMenuDivider(),
                      popUpItem('새로고침', PopUpItem.popUpItem2, () {}),
                      if (userRole == 'ROLE_ADMIN') const PopupMenuDivider(),
                      if (userRole == 'ROLE_ADMIN')
                        popUpItem('숨김 관리', PopUpItem.popUpItem3, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HiddenPage(category: 'TOTAL'),
                            ),
                          );
                        }),
                    ];
                  },
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Board(
                boardList: boardList,
                total: true,
                onBoardSelected: (board) {
                  setState(() {
                    selectedBoard = board;
                    isHidDel = !isHidDel; // 숨김/삭제 버튼 표시
                  });
                },
                category: 'TOTAL',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

PopupMenuItem<PopUpItem> popUpItem(
    String text, PopUpItem item, Function() onTap) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출(ex: onTap()) 가능
    onTap: onTap,
    value: item,
    height: 25,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF787879),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
