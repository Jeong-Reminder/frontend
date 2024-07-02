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
    return SizedBox(
      height: 25,
      width: 78,
      child: ElevatedButton(
        onPressed: () {
          onSelectedGrade(grade);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDBE7FB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          grade,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
