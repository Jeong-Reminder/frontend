import 'package:flutter/material.dart';

class FourBoard extends StatefulWidget {
  final ValueChanged<bool> onChecked;
  const FourBoard({required this.onChecked, super.key});

  @override
  State<FourBoard> createState() => _FourBoardState();
}

class _FourBoardState extends State<FourBoard> {
  bool isEdited = false; // 길게 눌렀을 때 편집모드 설정

  final List<Map<String, dynamic>> fourBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'isChecked': false,
    },
    {
      'title': '졸업반 게시판',
      'subtitle': '자기소개서 작성 하는 방법 알려주세요',
      'content': '자소서 작성 잘 할 수 있을까요?',
    },
    {
      'title': '졸업작품 자주 묻는 질문',
      'subtitle': '졸업작품 담당 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: fourBoard.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    isEdited = !isEdited;
                    widget.onChecked(isEdited); // isEdited 값 전달
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
                              fourBoard[index]['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            isEdited
                                // 숨김 / 삭제 체크박스
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      value: fourBoard[index]['isChecked'] ??
                                          false, // isChecked가 null이면 기본값이 false 사용
                                      onChanged: (value) {
                                        setState(() {
                                          fourBoard[index]['isChecked'] = value;
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
                          fourBoard[index]['subtitle'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          fourBoard[index]['content'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7D7D7F),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Color(0xFFEA4E44),
                              ),
                            ),
                            const Text('4'),
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
