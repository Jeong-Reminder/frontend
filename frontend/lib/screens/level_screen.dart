import 'package:flutter/material.dart';
import 'package:frontend/widgets/gradeNotification/oneBoard_widget.dart';
import 'package:frontend/widgets/gradeNotification/twoBoard_widget.dart';
import 'package:frontend/widgets/levelBtn_widget.dart';

class GradePage extends StatefulWidget {
  const GradePage({Key? key}) : super(key: key);

  @override
  State<GradePage> createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  String selectedGrade = '1학년';
  bool isSelceted = false;

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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
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
                      selectedGrade = level;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 13),
            // 해당 학년 공지 표시
            if (selectedGrade == '1학년') const OneBoard(),
            if (selectedGrade == '2학년') const TwoBoard(),
          ],
        ),
      ),
    );
  }
}
