import 'package:flutter/material.dart';

class BoardWritePage extends StatefulWidget {
  const BoardWritePage({super.key});

  @override
  State<BoardWritePage> createState() => _BoardWritePageState();
}

class _BoardWritePageState extends State<BoardWritePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isButtonEnabled = false; // 작성 완료 버튼 상태

  bool categoryBtn = true; // 공지 혹은 학년 버튼 여부
  List<bool> isCategory = [false, false, false, false]; // 공지 선택 불리안
  List<bool> isGrade = [false, false, false, false, false]; // 학년 선택 불리안

  @override
  void initState() {
    super.initState();
    // 텍스트 변경 감지 리스너 추가
    titleController.addListener(checkIfFormIsFilled);
    contentController.addListener(checkIfFormIsFilled);
  }

  @override
  void dispose() {
    titleController.removeListener(checkIfFormIsFilled);
    contentController.removeListener(checkIfFormIsFilled);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // 폼필드에 텍스트가 채워졌는지 확인
  void checkIfFormIsFilled() {
    setState(() {
      // 글자가 있으면 true 반환
      isButtonEnabled =
          titleController.text.isNotEmpty && contentController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 입력 필드
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 315,
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: '제목을 입력해주세요',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.25),
                    ),
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 17.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDBE7FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  child: const Text(
                    '미리보기',
                    style: TextStyle(
                      color: Color(0xFF6E747E),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Container(
            width: double.infinity,
            height: 1,
            decoration: const BoxDecoration(
              color: Color(0xFFC5C5C7),
            ),
          ),

          // 내용 입력 필드
          SizedBox(
            height: 210,
            child: TextFormField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: '내용을 입력해주세요',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 100.0),
              ),
            ),
          ),
          Row(
            children: [
              // 카메라 & 파일 버튼
              camFileBtn(
                  rightWidth: 1, icon: Icons.camera_alt_outlined, title: '카메라'),
              camFileBtn(rightWidth: 0, icon: Icons.file_present, title: '파일'),
            ],
          ),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            child: Text(
              '설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 공지 토글 버튼
          toggleButtons(title: '공지', isSelected: isCategory, categoryBtn: true),

          // 학년 토글 버튼
          toggleButtons(title: '학년', isSelected: isGrade, categoryBtn: false),
          const SizedBox(height: 5.0),

          // 필독 버튼
          readVoteBtn(title: '필독', imgPath: 'assets/images/mustRead.png'),
          const SizedBox(height: 5.0),

          // 투표 버튼
          readVoteBtn(title: '투표', imgPath: 'assets/images/vote.png'),
          const SizedBox(height: 30),

          // 경계선
          Container(
            width: double.infinity,
            height: 1,
            decoration: const BoxDecoration(
              color: Color(0xFFC5C5C7),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          // 작성이 되면 버튼 색상 변경
          backgroundColor: isButtonEnabled
              ? const Color(0xFF2B72E7).withOpacity(0.25)
              : const Color(0xFFFAFAFE),
          minimumSize: const Size(double.infinity, 75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Text(
          '작성 완료',
          style: TextStyle(
            color:
                isButtonEnabled ? Colors.white : Colors.black.withOpacity(0.5),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 필독 & 투표 버튼 생성 함수
  readVoteBtn({required String title, required String imgPath}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(
                0xFF6E747E,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC5C5C7),
              minimumSize: const Size(55, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Image.asset(imgPath),
          ),
        ],
      ),
    );
  }

  // 카메라 & 파일 버튼 생성 함수
  camFileBtn({
    required double rightWidth,
    required IconData icon,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width / 2, // 화면 절반
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: rightWidth,
              color: const Color(0xFFC5C5C7),
            ),
            bottom: const BorderSide(
              width: 1,
              color: Color(0xFFC5C5C7),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: const Color(0xFF2A72E7),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFC5C5C7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 토글 버튼 생성 함수
  toggleButtons({
    required String title,
    required List<bool> isSelected,
    required bool categoryBtn,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(
                0xFF6E747E,
              ),
            ),
          ),
          ToggleButtons(
            selectedColor: Colors.black, // 선택된 글자색
            fillColor: const Color(0xFFDBE7FB), // 선택된 배경색
            isSelected: isSelected,
            onPressed: (index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isGrade.length;
                    buttonIndex++) {
                  // 예를 들어 현재 butonIndex값이 내가 누르는 버튼 index값과 일치하다면 선택
                  if (buttonIndex == index) {
                    isGrade[buttonIndex] = true;
                  } else {
                    isGrade[buttonIndex] = false;
                  }
                }
              });
            },
            borderRadius: BorderRadius.circular(10.0),
            constraints: const BoxConstraints(
              minWidth: 55,
              minHeight: 30,
            ),

            // categoryBtn이 true 혹은 false일 경우 어떤 버튼이 생성되는지
            children: categoryBtn
                ? <Widget>[
                    const Text('전체'),
                    const Text('학년'),
                    const Text('경진'),
                    const Text('기업'),
                  ]
                : const <Widget>[
                    Text('전체'),
                    Text('1학년'),
                    Text('2학년'),
                    Text('3학년'),
                    Text('4학년'),
                  ],
          ),
        ],
      ),
    );
  }
}
