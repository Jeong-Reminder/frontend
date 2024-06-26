import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;
  final ValueChanged<bool> onChecked;
  final bool isShowed; // 체크박스와 숨김/삭제 버튼 활성화 여부
  const Board(
      {required this.onChecked,
      required this.boardList,
      required this.isShowed,
      super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool isPressed = false; // 길게 눌렀는지 여부
  int count = 4; // 좋아요 개수

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.boardList.length,
        itemBuilder: (context, index) {
          final board = widget.boardList[index];
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
                              board['title'],
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
                                      value: board['isChecked'] ??
                                          false, // isChecked가 null이면 기본값이 false 사용
                                      onChanged: (value) {
                                        setState(() {
                                          board['isChecked'] = value;
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
                          board['subtitle'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          board['content'],
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
                              onPressed: () {
                                // 여기에 좋아요 api 구현

                                setState(() {
                                  board['isLiked'] = !board['isLiked'];

                                  if (board['isLiked']) {
                                    board['count'] += 1;
                                  } else {
                                    board['count'] -= 1;
                                  }
                                });
                              },
                              icon: Icon(
                                board['isLiked']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color(0xFFEA4E44),
                              ),
                            ),
                            Text(
                              '${board['count']}',
                              style: const TextStyle(fontSize: 16),
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
