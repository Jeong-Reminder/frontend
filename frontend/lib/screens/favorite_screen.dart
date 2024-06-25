import 'package:flutter/material.dart';
import 'package:frontend/widgets/board_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool chosenBtn = false; // 선택 버튼 눌렀을 때 불리안
  int deletedCount = 0; // 좋아요 삭제한 갯수

  List<Map<String, dynamic>> favoriteList = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'originalIndex': 0,
      'isLiked': true,
      'count': 4,
      'isDeleted': false, // 좋아요 삭제 불리안
    },
    {
      'title': '헌내기 게시판',
      'subtitle': '수강 신청 하는 방법 알려주세요',
      'content': '수강 신청 잘 할 수 있을까요?',
      'originalIndex': 1,
      'isLiked': true,
      'count': 10,
      'isDeleted': false,
    },
    {
      'title': '암모니아 게시판',
      'subtitle': '복학 신청 하는 방법 알려주세요',
      'content': '복학 신청 잘 할 수 있을까요?',
      'originalIndex': 1,
      'isLiked': true,
      'count': 8,
      'isDeleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: BackButton(),
        ),
        title: const Text(
          '좋아요',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  chosenBtn = !chosenBtn;
                });
              },

              // 취소 & 선택 버튼
              child: Text(
                chosenBtn ? '취소' : '선택',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            Expanded(
              // 여기에 좋아요 조회 api 구현

              child: favoriteBoard(favoriteList),
            ),
          ],
        ),
      ),
      // 좋아요 취소 버튼
      bottomNavigationBar: chosenBtn
          ? ElevatedButton(
              onPressed: () {
                setState(() {
                  // 여기에 좋아요 삭제 api 구현

                  // where를 사용해서 필터링한 리스트를 새로 생성하여 favoriteList를 업데이트
                  // isDeleted가 true일 때 count를 1 감소하고 favoriteList에 제거
                  favoriteList = favoriteList.where((favorite) {
                    if (favorite['isDeleted'] == false) {
                      favorite['count'] -= 1;
                    }
                    return favorite['isDeleted'] = false;
                  }).toList();

                  // 선택 버튼으로 돌아롬
                  chosenBtn = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD4D4),
                minimumSize: const Size(double.infinity, 61),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              child: Text(
                '좋아요 취소($deletedCount개)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEA4E44),
                ),
              ),
            )
          : null,
    );
  }

  // 좋아요 게시글
  Widget favoriteBoard(List<Map<String, dynamic>> boardList) {
    return ListView.builder(
      itemCount: boardList.length,
      itemBuilder: (context, index) {
        final board = boardList[index];
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
                        Text(
                          board['title'], // 제목
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chosenBtn
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: board['isDeleted'],
                                  onChanged: (value) {
                                    setState(() {
                                      board['isDeleted'] = value;
                                      // isDeleted가 true일 때 좋아요 삭제 갯수 1 증가
                                      if (board['isDeleted']) {
                                        deletedCount += 1;
                                      } else {
                                        deletedCount -= 1;
                                      }
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
                      board['subtitle'], // 부제목
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      board['content'], // 내용
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
                            setState(() {
                              board['isLiked'] = !board['isLiked'];

                              // isLiked가 true일 때 좋아요 개수 1 증가
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
                          '${board['count']}', // 좋아요 개수
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 13),
          ],
        );
      },
    );
  }
}
