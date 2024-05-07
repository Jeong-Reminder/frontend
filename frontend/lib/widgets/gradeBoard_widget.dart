import 'package:flutter/material.dart';

class GradeBoard extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;
  final ValueChanged<bool> onChecked;
  final bool isShowed; // 체크박스와 숨김/삭제 버튼 활성화 여부
  const GradeBoard(
      {required this.onChecked,
      required this.boardList,
      required this.isShowed,
      super.key});

  @override
  State<GradeBoard> createState() => _GradeBoardState();
}

class _GradeBoardState extends State<GradeBoard> {
  bool isPressed = false; // 길게 눌렀는지 여부

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.boardList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    isPressed = !isPressed;
                    widget.onChecked(isPressed); // isEdited 값 전달
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.boardList[index]['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            widget.isShowed
                                // 숨김 / 삭제 체크박스
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      value: widget.boardList[index]
                                              ['isChecked'] ??
                                          false, // isChecked가 null이면 기본값이 false 사용
                                      onChanged: (value) {
                                        setState(() {
                                          widget.boardList[index]['isChecked'] =
                                              value;
                                        });
                                      },
                                      shape: const CircleBorder(),
                                      activeColor: const Color(0xFF7B88C2),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          widget.boardList[index]['subtitle'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          widget.boardList[index]['content'],
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
    );
  }
}
