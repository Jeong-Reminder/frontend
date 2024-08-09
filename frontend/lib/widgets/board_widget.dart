import 'package:flutter/material.dart';
import 'package:frontend/services/login_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Board extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;

  const Board({required this.boardList, super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final prefs = SharedPreferences.getInstance();
  bool isPressed = false; // 길게 눌렀는지 여부
  int count = 4; // 좋아요 개수
  int? level;

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // 학번을 로드하는 메서드 호출
  }

  // 학번, 이름, 재적상태를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      level = credentials['level']; // 로그인 정보에 있는 level를 가져와 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    if (level == null) {
      return const Center(child: Text('해당 학생의 공지가 없습니다.')); // 로딩 스피너 표시
    }

    return Expanded(
      child: ListView.builder(
          itemCount: widget.boardList.length,
          itemBuilder: (context, index) {
            final board = widget.boardList[index];

            final category =
                _getCategoryName(board['announcementCategory']); // 카테고리 변환
            final memberLevel = board['announcementLevel']; // 해당 공지 학년

            // 로그인 정보의 학년(level)과 해당 공지의 학년(memberLevel)이 일치하면
            // level이 0(관리자)이면 해당 공지를 보여주도록 설정
            if (level == memberLevel || level == 0) {
              return Column(
                children: [
                  Card(
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
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }
            return null;
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
