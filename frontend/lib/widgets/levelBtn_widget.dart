import 'package:flutter/material.dart';

class GradeBtn extends StatelessWidget {
  final String grade;
  final bool isSelected;
  final Function(String) onSelectedGrade;

  const GradeBtn({
    required this.grade,
    required this.isSelected,
    required this.onSelectedGrade,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSelectedGrade(grade);
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
        grade,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.black.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
