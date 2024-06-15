import 'package:flutter/material.dart';

class HiddenPage extends StatefulWidget {
  final List<Map<String, dynamic>> hiddenList;
  final Function(List<Map<String, dynamic>>) onUnhide;
  const HiddenPage(
      {required this.hiddenList, required this.onUnhide, super.key});

  @override
  State<HiddenPage> createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  bool isShowed = false;
  List<Map<String, dynamic>> selectedHiddenItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        leadingWidth: 120,
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
              child: ListView.builder(
                itemCount: widget.hiddenList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            isShowed = !isShowed;
                          });
                        },
                        child: Card(
                          color: const Color(0xFFFAFAFE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.hiddenList[index]['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    isShowed
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Checkbox(
                                              value:
                                                  // selectedHiddenItems에 hiddenList[index]이 포함되어 있으면 true
                                                  // 포함되어 있지 않으면 false 반환
                                                  selectedHiddenItems.contains(
                                                      widget.hiddenList[index]),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value == true) {
                                                    selectedHiddenItems.add(
                                                        widget
                                                            .hiddenList[index]);
                                                  } else {
                                                    selectedHiddenItems.remove(
                                                        widget
                                                            .hiddenList[index]);
                                                  }
                                                });
                                              },
                                              shape: const CircleBorder(),
                                              activeColor:
                                                  const Color(0xFF7B88C2),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  widget.hiddenList[index]['subtitle'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  widget.hiddenList[index]['content'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7D7D7F),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero, // 패딩 설정
                                      constraints: const BoxConstraints(),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color: Color(0xFFEA4E44),
                                      ),
                                    ),
                                    const Text(
                                      '4',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: selectedHiddenItems.isNotEmpty
            ? () {
                // selectedHiddenItems에 있는 항목들을 hiddenList에 제거해 숨김 목록 취소
                widget.onUnhide(selectedHiddenItems);
                setState(() {
                  widget.hiddenList.removeWhere((item) =>
                      selectedHiddenItems.contains(
                          item)); // selectedHiddenItems에 있는 항목들을 필터링해 숨김 목록 화면에 제거
                  // 그 이후에 selectedHiddenItems에 있는 항목들 제거
                  selectedHiddenItems.clear();
                  isShowed = false;
                });
              }
            : null,
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
