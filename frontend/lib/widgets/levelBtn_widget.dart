import 'package:flutter/material.dart';

class GradeBtn extends StatefulWidget {
  final String grade;
  final bool isSelceted;
  final ValueChanged<String> onSelectedGrade;
  const GradeBtn(
      {required this.grade,
      required this.isSelceted,
      required this.onSelectedGrade,
      super.key});

  @override
  State<GradeBtn> createState() => _GradeBtnState();
}

class _GradeBtnState extends State<GradeBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // 선택된 학년(grade) 값을 전달
          widget.onSelectedGrade(widget.grade);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDBE7FB),
        side: BorderSide(
          color: const Color(0xFF2B72E7).withOpacity(0.25),
          width: 1.5,
        ),
        minimumSize: const Size(50, 40),
      ),
      child: Text(
        widget.grade,
        style: TextStyle(
          color:
              widget.isSelceted ? Colors.black : Colors.black.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
