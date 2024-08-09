import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;

  const Board({required this.boardList, super.key});

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

            // 카테고리 변환
            final category = _getCategoryName(board['announcementCategory']);

            return Card(
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
                        Row(
                          children: [
                            Text(
                              board['announcementTitle'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                        // SizedBox(
                        //   height: 20,
                        //   width: 20,
                        //   child: Checkbox(
                        //     value: board['isChecked'] ??
                        //         false, // isChecked가 null이면 기본값이 false 사용
                        //     onChanged: (value) {
                        //       setState(() {
                        //         board['isChecked'] = value;
                        //       });
                        //     },
                        //     shape: const CircleBorder(),
                        //     activeColor: const Color(0xFF7B88C2),
                        //   ),
                        // )
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      board['announcementContent'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 7),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     IconButton(
                    //       padding: EdgeInsets.zero, // 패딩 설정
                    //       constraints: const BoxConstraints(),
                    //       onPressed: () {
                    //         // 여기에 좋아요 api 구현

                    //         setState(() {
                    //           board['isLiked'] = !board['isLiked'];

                    //           if (board['isLiked']) {
                    //             board['count'] += 1;
                    //           } else {
                    //             board['count'] -= 1;
                    //           }
                    //         });
                    //       },
                    //       icon: Icon(
                    //         board['isLiked']
                    //             ? Icons.favorite
                    //             : Icons.favorite_border,
                    //         color: const Color(0xFFEA4E44),
                    //       ),
                    //     ),
                    //     Text(
                    //       '${board['count']}',
                    //       style: const TextStyle(fontSize: 16),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }),
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
        return 'null'; // 변환되지 않은 경우 원래 값을 반환
    }
  }
}
