import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
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

  @override
  void initState() {
    super.initState();
    // listen: false를 사용하여 initState에서 Provider를 호출
    // addPostFrameCallback 사용하는 이유 : initState에서 직접 Provider.of를 호출할 때 context가 아직 완전히 준비되지 않았기 때문에 발생할 수 있는 에러를 방지
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards();
    });
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
    final boardList = Provider.of<AnnouncementProvider>(context).boardList;

    return Scaffold(
      appBar: const BoardAppbar(),
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
                          Navigator.pushNamed(
                            context,
                            '/write-board',
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
              ),
            ),
          ],
        ),
      ),
      // 숨김/삭제 버튼(isEdited 값을 저장한 isHidDel)
      bottomNavigationBar: isHidDel
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 12,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedBoard != null) {
                        print('id: ${selectedBoard!['id']}');
                        await Provider.of<AnnouncementProvider>(context,
                                listen: false)
                            .hiddenBoard(selectedBoard!, selectedBoard!['id']);

                        // 전체 boardList를 다시 불러옴
                        if (context.mounted) {
                          await Provider.of<AnnouncementProvider>(context,
                                  listen: false)
                              .fetchAllBoards();
                        }
                        setState(() {
                          isHidDel = false; // 숨김/삭제 버튼 숨기기
                          selectedBoard = null; // 선택된 게시글 초기화
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFAFAFE),
                      minimumSize: const Size(205, 75),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text(
                      '숨김',
                      style: TextStyle(
                        color: Color(0xFF7D7D7F),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 12,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedBoard != null) {
                        print('id: ${selectedBoard!['id']}');
                        await Provider.of<AnnouncementProvider>(context,
                                listen: false)
                            .deletedBoard(selectedBoard!['id']);

                        // 전체 boardList를 다시 불러옴
                        if (context.mounted) {
                          await Provider.of<AnnouncementProvider>(context,
                                  listen: false)
                              .fetchAllBoards();
                        }
                        setState(() {
                          isHidDel = false; // 숨김/삭제 버튼 숨기기
                          selectedBoard = null; // 선택된 게시글 초기화
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFAFAFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text(
                      '삭제',
                      style: TextStyle(
                        color: Color(0xFF7D7D7F),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
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
