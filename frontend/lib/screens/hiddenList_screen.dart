import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/screens/contestBoard_screen.dart';
import 'package:frontend/screens/corSeaBoard_screen.dart';
import 'package:frontend/screens/gradeBoard_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/totalBoard_screen.dart';
import 'package:frontend/widgets/board_widget.dart';
import 'package:provider/provider.dart';

class HiddenPage extends StatefulWidget {
  String? category;
  HiddenPage({this.category, super.key});

  @override
  State<HiddenPage> createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  String? category;
  bool isShowed = false;
  List<Map<String, dynamic>> selectedHiddenItems = [];
  Map<String, dynamic>? selectedBoard;
  bool isHidDel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchHiddenBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hiddenList = Provider.of<AnnouncementProvider>(context).hiddenList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: BackButton(
          onPressed: () {
            if (widget.category == 'TOTAL') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const TotalBoardPage(), // 페이지로 직접 이동
                ),
                (route) => false, // 이전 모든 라우트를 제거
              );
            } else if (widget.category == 'ACADEMIC_ALL') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const GradeBoardPage(), // 페이지로 직접 이동
                ),
                (route) => false, // 이전 모든 라우트를 제거
              );
            } else if (widget.category == 'CONTEST') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContestBoardPage(), // 페이지로 직접 이동
                ),
                (route) => false, // 이전 모든 라우트를 제거
              );
            } else if (widget.category == 'CORSEA') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const CorSeaBoardPage(), // 페이지로 직접 이동
                ),
                (route) => false, // 이전 모든 라우트를 제거
              );
            }
          },
          color: Colors.black,
        ),
        actions: [
          // 프로필 아이콘
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () async {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyOwnerPage(),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.black,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '숨김 목록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Board(
                boardList: hiddenList,
                total: false,
                onBoardSelected: (board) {
                  setState(() {
                    selectedBoard = board;
                    isHidDel = !isHidDel;
                  });
                },
                category: 'HIDDEN',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isHidDel
          ? ElevatedButton(
              onPressed: () async {
                if (selectedBoard != null) {
                  print('selectedBoardId: ${selectedBoard!['id']}');
                  await Provider.of<AnnouncementProvider>(context,
                          listen: false)
                      .showedBoard(selectedBoard!['id']);

                  if (context.mounted) {
                    await Provider.of<AnnouncementProvider>(context,
                            listen: false)
                        .fetchHiddenBoard();

                    // 숨김 해제 후 새로고침할 때 숨김 해제 버튼 없애기 위해 isHidDel를 false로 설정
                    setState(() {
                      isHidDel = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedHiddenItems.isNotEmpty
                    ? const Color(0xFF2B72E7)
                    : const Color(0xFFFAFAFE),
                minimumSize: const Size(205, 75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                '숨김 해제',
                style: TextStyle(
                  color: selectedHiddenItems.isNotEmpty
                      ? Colors.white
                      : Colors.black.withOpacity(0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
