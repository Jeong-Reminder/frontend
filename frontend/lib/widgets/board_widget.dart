import 'package:flutter/material.dart';
import 'package:frontend/services/login_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Board extends StatefulWidget {
  final List<Map<String, dynamic>> boardList;
  final bool
      total; // level과 memberLevel이 맞는 공지사항만 필터링하는 작업을 할 것인지 여부(true일 때 필터링 작업 진행)

  const Board({required this.boardList, required this.total, super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final prefs = SharedPreferences.getInstance();
  bool isPressed = false; // 길게 눌렀는지 여부
  int count = 4; // 좋아요 개수
  int? level;
  List<Map<String, dynamic>> filteredBoardList = [];

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
    // level과 memberLevel이 맞는 공지사항만 필터링
    if (widget.total) {
      setState(() {
        filteredBoardList = widget.boardList.where((board) {
          final memberLevel = board['announcementLevel'];
          return level == memberLevel || level == 0;
        }).toList();
      });

      // 만약 필터링된 리스트가 비어 있다면 텍스트 표시
      if (filteredBoardList.isEmpty) {
        return const Center(
          child: Text(
            '해당 학생의 공지가 없습니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        );
      }
    }

    // 필터링된 공지사항 리스트를 화면에 표시
    return ListView.builder(
      itemCount:
          widget.total ? filteredBoardList.length : widget.boardList.length,
      shrinkWrap: true, // 높이를 자동으로 조절
      itemBuilder: (context, index) {
        final board =
            widget.total ? filteredBoardList[index] : widget.boardList[index];
        final category = _getCategoryName(board['announcementCategory']);

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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
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
        return category; // 변환되지 않은 경우 원래 값을 반환
    }
  }
}
