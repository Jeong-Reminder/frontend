import 'package:flutter/material.dart';
import 'package:frontend/widgets/gradeBoard_widget.dart';
import 'package:frontend/widgets/levelBtn_widget.dart';

class GradePage extends StatefulWidget {
  const GradePage({Key? key}) : super(key: key);

  @override
  State<GradePage> createState() => _GradePageState();
}

enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 }

class _GradePageState extends State<GradePage> {
  String selectedGrade = '1학년';
  bool isSelceted = false;
  bool isHidDel = false; // 숨김 / 삭제 버튼 숨김 활성화 불리안

  final List<Map<String, dynamic>> oneBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'isChecked': false,
    },
    {
      'title': '새내기 게시판',
      'subtitle': '수강 신청 하는 방법 알려주세요',
      'content': '수강 신청 잘 할 수 있을까요?',
    },
    {
      'title': '제자반 채플 자주 묻는 질문',
      'subtitle': '채플 담당 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
    },
  ];

  final List<Map<String, dynamic>> twoBoard = [
    {
      'title': '2차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '2차 : 5일 오후 2시까지 신청',
    },
    {
      'title': '헌내기 게시판',
      'subtitle': '수강 신청 하는 방법 알려주세요',
      'content': '수강 신청 잘 할 수 있을까요?',
    },
    {
      'title': '사회봉사 자주 묻는 질문',
      'subtitle': '사회봉사 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
    },
  ];

  final List<Map<String, dynamic>> threeBoard = [
    {
      'title': '1차 증원',
      'subtitle': '정보통신공학과 증원 신청',
      'content': '1차 : 5일 오후 2시까지 신청',
      'isChecked': false,
    },
    {
      'title': '암모니아 게시판',
      'subtitle': '복학 신청 하는 방법 알려주세요',
      'content': '복학 신청 잘 할 수 있을까요?',
    },
    {
      'title': '현대인과 기독교 자주 묻는 질문',
      'subtitle': '현기 교수님 연락처는 어떻게 알아요?',
      'content': '스카이 시스템 -> 학적 정보 -> 학적 정보 조회 -> 지도 교수(전화번호...',
    },
  ];

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {},
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
                      popUpItem('글쓰기', PopUpItem.popUpItem1),
                      const PopupMenuDivider(),
                      popUpItem('새로고침', PopUpItem.popUpItem2),
                      const PopupMenuDivider(),
                      popUpItem('숨김 관리', PopUpItem.popUpItem3),
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
                  isSelceted:
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
                  isSelceted: selectedGrade == '2학년',
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
                  isSelceted: selectedGrade == '3학년',
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
                  isSelceted: selectedGrade == '4학년',
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
              GradeBoard(
                boardList: oneBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
            else if (selectedGrade == '2학년')
              GradeBoard(
                boardList: twoBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
            else if (selectedGrade == '3학년')
              GradeBoard(
                boardList: threeBoard,
                onChecked: (isPressed) {
                  setState(() {
                    isHidDel = isPressed;
                  });
                },
                isShowed: isHidDel,
              )
            else if (selectedGrade == '4학년')
              GradeBoard(
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
                  onPressed: () {},
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
                  onPressed: () {},
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

PopupMenuItem<PopUpItem> popUpItem(String text, PopUpItem item) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출(ex: onTap()) 가능
    onTap: () {},
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
