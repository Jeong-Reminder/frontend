import 'package:flutter/material.dart';
import 'package:frontend/all/providers/announcement_provider.dart';
import 'package:frontend/screens/write_screen.dart';
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
  @override
  void initState() {
    super.initState();
    // listen: false를 사용하여 initState에서 Provider를 호출
    // addPostFrameCallback 사용하는 이유 : initState에서 직접 Provider.of를 호출할 때 context가 아직 완전히 준비되지 않았기 때문에 발생할 수 있는 에러를 방지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final boardList = Provider.of<AnnouncementProvider>(context).boardList;
    print('boardList: $boardList');

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
                      popUpItem('글쓰기', PopUpItem.popUpItem1, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BoardWritePage()),
                        );
                      }),
                      const PopupMenuDivider(),
                      popUpItem('새로고침', PopUpItem.popUpItem2, () {}),
                      const PopupMenuDivider(),
                      popUpItem('숨김 관리', PopUpItem.popUpItem3, () {
                        // 숨김 페이지로 이동
                      }),
                    ];
                  },
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 20),
            boardList.isEmpty
                ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때
                : Board(boardList: boardList),
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
