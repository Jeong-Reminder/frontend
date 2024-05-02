import 'package:flutter/material.dart';

class LevelBtn extends StatefulWidget {
  final String level;
  const LevelBtn({required this.level, super.key});

  @override
  State<LevelBtn> createState() => _LevelBtnState();
}

class _LevelBtnState extends State<LevelBtn> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
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
        widget.level,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.black.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
