import 'package:flutter/material.dart';
import 'package:frontend/screens/hiddenList_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/write_screen.dart';
import 'package:frontend/widgets/board_widget.dart';
import 'package:frontend/widgets/levelBtn_widget.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 }

class _BoardPageState extends State<BoardPage> {
  String selectedGrade = '1학년';
  bool isSelected = false;
  bool isHidDel = false; // 숨김 / 삭제 버튼 숨김 활성화 불리안

  List<Map<String, dynamic>> oneBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'isChecked': false,
      'originalIndex': 0,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '새내기 게시판',
      'subtitle': '수강 신청 하는 방법 알려주세요',
      'content': '수강 신청 잘 할 수 있을까요?',
      'isChecked': false,
      'originalIndex': 1,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '제자반 채플 자주 묻는 질문',
      'subtitle': '채플 담당 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
      'isChecked': false,
      'originalIndex': 2,
      'isLiked': false,
      'count': 0,
    },
  ];

  List<Map<String, dynamic>> twoBoard = [
    {
      'title': '2차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '2차 : 5일 오후 2시까지 신청',
      'isChecked': false,
      'originalIndex': 0,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '헌내기 게시판',
      'subtitle': '수강 신청 하는 방법 알려주세요',
      'content': '수강 신청 잘 할 수 있을까요?',
      'isChecked': false,
      'originalIndex': 1,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '사회봉사 자주 묻는 질문',
      'subtitle': '사회봉사 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
      'isChecked': false,
      'originalIndex': 2,
      'isLiked': false,
      'count': 0,
    },
  ];

  List<Map<String, dynamic>> threeBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'isChecked': false,
      'originalIndex': 0,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '암모니아 게시판',
      'subtitle': '복학 신청 하는 방법 알려주세요',
      'content': '복학 신청 잘 할 수 있을까요?',
      'isChecked': false,
      'originalIndex': 1,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '현대인과 기독교 자주 묻는 질문',
      'subtitle': '현기 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
      'isChecked': false,
      'originalIndex': 2,
      'isLiked': false,
      'count': 0,
    },
  ];

  List<Map<String, dynamic>> fourBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'isChecked': false,
      'originalIndex': 0,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '졸업반 게시판',
      'subtitle': '자기소개서 작성 하는 방법 알려주세요',
      'content': '자소서 작성 잘 할 수 있을까요?',
      'isChecked': false,
      'originalIndex': 1,
      'isLiked': false,
      'count': 0,
    },
    {
      'title': '졸업작품 자주 묻는 질문',
      'subtitle': '졸업작품 담당 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
      'isChecked': false,
      'originalIndex': 2,
      'isLiked': false,
      'count': 0,
    },
  ];

  List<Map<String, dynamic>> hiddenList = [];

  // 숨김 해제 시 호출되는 함수
  void unhideItems(List<Map<String, dynamic>> items) {
    setState(() {
      for (var item in items) {
        item['isChecked'] = false;
        // 각 학년별 게시판 리스트 (oneBoard, twoBoard, threeBoard, fourBoard)를 정의
        // 각 항목에 originalIndex를 추가하여 원래 인덱스를 저장
        // 각 항목의 originalIndex를 사용하여 원래 인덱스 위치에 항목을 다시 추가
        if (selectedGrade == '1학년') {
          oneBoard.insert(item['originalIndex'], item);
        } else if (selectedGrade == '2학년') {
          twoBoard.insert(item['originalIndex'], item);
        } else if (selectedGrade == '3학년') {
          threeBoard.insert(item['originalIndex'], item);
        } else if (selectedGrade == '4학년') {
          fourBoard.insert(item['originalIndex'], item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/homepage', (route) => false);
            },
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
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
            // 학년 공지 상단바
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '학년 공지',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 팝업 메뉴 창
                PopupMenuButton<PopUpItem>(
                  color: const Color(0xFFEFF0F2),
                  itemBuilder: (BuildContext context) {
                    return [
                      popUpItem('글쓰기', PopUpItem.popUpItem1, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BoardWritePage()),
                        );
                      }),
                      const PopupMenuDivider(),
                      popUpItem('새로고침', PopUpItem.popUpItem2, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }),
                      const PopupMenuDivider(),
                      popUpItem('숨김 관리', PopUpItem.popUpItem3, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HiddenPage(
                                    hiddenList: hiddenList,
                                    onUnhide: unhideItems,
                                  )),
                        );
                      }),
                    ];
                  },
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 학년 별 카테고리 버튼
            Row(
              children: [
                GradeBtn(
                  grade: '1학년',
                  isSelected:
                      selectedGrade == '1학년', // 전달 받은 학년과 버튼 학년과 동일하면 true 반환
                  // 전달 받은 grade 값을 selectedGrade에 저장
                  onSelectedGrade: (grade) {
                    setState(() {
                      // 다른 학년 버튼 시 숨김/삭제 버튼 비활성화
                      // 이 콜백 함수가 onPressed 함수 내에 있어서 여기에 코드 작성
                      isHidDel = false;
                      selectedGrade = grade;
                    });
                  },
                ),
                const SizedBox(width: 5),
                GradeBtn(
                  grade: '2학년',
                  isSelected: selectedGrade == '2학년',
                  onSelectedGrade: (grade) {
                    setState(() {
                      isHidDel = false;
                      selectedGrade = grade;
                    });
                  },
                ),
                const SizedBox(width: 5),
                GradeBtn(
                  grade: '3학년',
                  isSelected: selectedGrade == '3학년',
                  onSelectedGrade: (grade) {
                    setState(() {
                      isHidDel = false;
                      selectedGrade = grade;
                    });
                  },
                ),
                const SizedBox(width: 5),
                GradeBtn(
                  grade: '4학년',
                  isSelected: selectedGrade == '4학년',
                  onSelectedGrade: (level) {
                    setState(() {
                      isHidDel = false;
                      selectedGrade = level;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 13),
            // 해당 학년 공지 표시
            if (selectedGrade == '1학년')
              // 전달받은 isEdited 값을 isHidDel 값에 저장
              Board(
                boardList: oneBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
            else if (selectedGrade == '2학년')
              Board(
                boardList: twoBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
            else if (selectedGrade == '3학년')
              Board(
                boardList: threeBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
            else if (selectedGrade == '4학년')
              Board(
                boardList: fourBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
          ],
        ),
      ),

      // 숨김/삭제 버튼(isEdited 값을 저장한 isHidDel)
      bottomNavigationBar: isHidDel
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selectedGrade == '1학년') {
                        // 리스트에서 isChecked 값이 true인 board만 hiddenList에 추가
                        hiddenList.addAll(oneBoard // addAll : 리스트에 추가
                            .where((board) =>
                                board['isChecked'] ==
                                true)); // where : 조건에 맞게 필터링

                        // isChecked 값이 true인 board만 BoardPage에서 제거
                        oneBoard.removeWhere((board) =>
                            board['isChecked'] ==
                            true); // removeWhere : 조건에 맞게 제거
                      } else if (selectedGrade == '2학년') {
                        hiddenList.addAll(twoBoard
                            .where((board) => board['isChecked'] == true));
                        twoBoard
                            .removeWhere((board) => board['isChecked'] == true);
                      } else if (selectedGrade == '3학년') {
                        hiddenList.addAll(threeBoard
                            .where((board) => board['isChecked'] == true));
                        threeBoard
                            .removeWhere((board) => board['isChecked'] == true);
                      } else if (selectedGrade == '4학년') {
                        hiddenList.addAll(fourBoard
                            .where((board) => board['isChecked'] == true));
                        fourBoard
                            .removeWhere((board) => board['isChecked'] == true);
                      }
                      isHidDel = false; // 숨김/삭제 버튼 비활성화
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAFAFE),
                    minimumSize: const Size(205, 75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    '숨김',
                    style: TextStyle(
                      color: Color(0xFF7D7D7F),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // setState(() {
                    //   if (selectedGrade == '1학년') {
                    //     oneBoard
                    //         .removeWhere((board) => board['isChecked'] == true);
                    //   } else if (selectedGrade == '2학년') {
                    //     twoBoard
                    //         .removeWhere((board) => board['isChecked'] == true);
                    //   } else if (selectedGrade == '3학년') {
                    //     threeBoard
                    //         .removeWhere((board) => board['isChecked'] == true);
                    //   } else if (selectedGrade == '4학년') {
                    //     fourBoard
                    //         .removeWhere((board) => board['isChecked'] == true);
                    //   }
                    //   isHidDel = false; // 숨김/삭제 버튼 비활성화
                    // });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAFAFE),
                    minimumSize: const Size(205, 75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    '삭제',
                    style: TextStyle(
                      color: Color(0xFF7D7D7F),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

PopupMenuItem<PopUpItem> popUpItem(
    String text, PopUpItem item, Function() onTap) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출(ex: onTap()) 가능
    onTap: onTap,
    value: item,
    height: 25,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF787879),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
