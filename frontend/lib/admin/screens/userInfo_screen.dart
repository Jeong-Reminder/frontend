import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController searchController = TextEditingController(); // 검색 컨트롤러

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 133.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '회원 정보 목록',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A72E7),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 10),
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: const Text(
                    '날짜 조회',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // 검색 바
            SearchBar(
              controller: searchController,
              hintText: '이름을 검색하세요',
              hintStyle: const MaterialStatePropertyAll(
                TextStyle(
                  fontSize: 16,
                  color: Color(0xFF848488),
                ),
              ),
              backgroundColor: const MaterialStatePropertyAll(
                Color(0xFFEFEFF2),
              ),
              constraints: const BoxConstraints(
                  minWidth: double.infinity, minHeight: 35), // 검색 바 크기
              elevation: const MaterialStatePropertyAll(0), // 그림
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 5),
              ),
              trailing: [
                Image.asset('assets/images/send.png'),
              ],
            ),
            const SizedBox(height: 23),

            // 삭제 & 조회 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA4E44),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(60, 16),
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: const Text(
                        '삭제',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A72E7),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(60, 16),
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        '조회',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // 파일 불러오기 버튼
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6E6E6),
                    minimumSize: const Size(45, 45),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 2.0,
                  ),
                  child: Image.asset(
                    'assets/images/Folder_send_light.png',
                    scale: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
