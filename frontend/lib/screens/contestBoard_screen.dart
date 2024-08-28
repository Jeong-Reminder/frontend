import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/screens/hiddenList_screen.dart';
import 'package:frontend/screens/write_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:frontend/widgets/boardAppbar_widget.dart';
import 'package:frontend/widgets/board_widget.dart';
import 'package:provider/provider.dart';

class ContestBoardPage extends StatefulWidget {
  const ContestBoardPage({super.key});

  @override
  State<ContestBoardPage> createState() => _ContestBoardPageState();
}

enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 }

class _ContestBoardPageState extends State<ContestBoardPage> {
  String boardCategory = 'CONTEST';
  String userRole = '';
  bool isHidDel = false;
  Map<String, dynamic>? selectedBoard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchCateBoard(boardCategory);

      if (context.mounted) {
        Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchContestCate();
      }
    });

    _loadCredentials();
  }

  // 역할을 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 level를 가져와 저장
    });
  }

  // 글 제목에서 대괄호([]) 안의 경진대회 이름을 추출하는 함수
  String _parseCompetitionName(String title) {
    // 대괄호 안의 내용을 추출하는 정규 표현식을 정의
    final RegExp regExp = RegExp(
      r'\[(.*?)\]',
      caseSensitive: false, // 대소문자 구분 없이 매칭
    );

    // 정규 표현식과 일치하는 첫 번째 부분을 찾음
    final match = regExp.firstMatch(title);

    // 일치하는 부분이 있으면 대괄호 안의 텍스트를 반환, 없으면 빈 문자열 반환
    if (match != null) {
      return match.group(1)?.trim() ?? ''; // 대괄호 안의 문자열을 반환하며, 공백 제거
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final cateBoardList =
        Provider.of<AnnouncementProvider>(context).cateBoardList;

    return Scaffold(
      appBar: const BoardAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '경진대회 공지',
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
                                  const BoardWritePage(category: 'CONTEST'),
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
                                  HiddenPage(category: 'CONTEST'),
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

            // Board 위젯 안에 Listview.builder()가 있기 때문에
            // 여기서 Listview.builder() 작성할 필요가 없음
            Expanded(
              child: Board(
                boardList: cateBoardList,
                total: true, // true일 경우에는 특정 학년 게시글만 보여줌
                onBoardSelected: (board) {
                  setState(() {
                    selectedBoard = board;
                    isHidDel = !isHidDel;
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

                        if (context.mounted) {
                          await Provider.of<AnnouncementProvider>(context,
                                  listen: false)
                              .fetchCateBoard(boardCategory);
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

                        if (context.mounted) {
                          await Provider.of<AnnouncementProvider>(context,
                                  listen: false)
                              .fetchCateBoard(boardCategory);
                        }

                        setState(() {
                          selectedBoard = null;
                          isHidDel = false;
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
}
