import 'package:flutter/material.dart';

class teamMemberPage extends StatefulWidget {
  const teamMemberPage({super.key});

  @override
  State<teamMemberPage> createState() => _teamMemberPageState();
}

class _teamMemberPageState extends State<teamMemberPage> {
  // 각 섹션의 확장 상태를 관리하는 변수
  bool isExpandedSection1 = false;
  bool isExpandedSection2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        leadingWidth: 120,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '팀원 현황',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: double.infinity,
                child: Divider(
                  color: Color(0xFFC5C5C7),
                  thickness: 1,
                  height: 30,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'IoT 박사',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 20,
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A72E7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        '명단',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // isExpandedSection1 값을 반전
                        // 현재 true라면 false로, false라면 true로 변경
                        isExpandedSection1 = !isExpandedSection1;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF2A72E7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Row(
                children: [
                  Text(
                    '23/10/21 ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 7),
                  Text(
                    '11:57',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              if (isExpandedSection1) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      '소진수',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀장',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '장찬현',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀원',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Text(
                      '이승욱',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀원',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '조윤서',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀원',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Color(0xFFC5C5C7),
                  thickness: 1,
                  height: 30,
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    '아이윗',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 20,
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A72E7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        '명단',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // isExpandedSection2 값을 반전
                        // 현재 true라면 false로, false라면 true로 변경
                        isExpandedSection2 = !isExpandedSection2;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF2A72E7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Row(
                children: [
                  Text(
                    '23/10/22 ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 7),
                  Text(
                    '12:37',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              if (isExpandedSection2) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      '홍길동',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀장',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '김민경',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀원',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Text(
                      '신윤복',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀원',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '흥부',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀원',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Color(0xFFC5C5C7),
                  thickness: 1,
                  height: 30,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
