import 'package:flutter/material.dart';
import 'package:frontend/all/providers/announcement_provider.dart';
import 'package:frontend/widgets/board_widget.dart';
import 'package:provider/provider.dart';

class HiddenPage extends StatefulWidget {
  const HiddenPage({super.key});

  @override
  State<HiddenPage> createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  bool isShowed = false;
  List<Map<String, dynamic>> selectedHiddenItems = [];

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
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // // selectedHiddenItems에 있는 항목들을 hiddenList에 제거해 숨김 목록 취소
          // widget.onUnhide!(selectedHiddenItems);
          // setState(() {
          //   widget.hiddenList!.removeWhere((item) =>
          //       selectedHiddenItems.contains(
          //           item)); // selectedHiddenItems에 있는 항목들을 필터링해 숨김 목록 화면에 제거
          //   // 그 이후에 selectedHiddenItems에 있는 항목들 제거
          //   selectedHiddenItems.clear();
          //   isShowed = false;
          // });
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
      ),
    );
  }
}
