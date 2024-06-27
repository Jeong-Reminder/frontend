import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:excel/excel.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController searchController = TextEditingController(); // 검색 컨트롤러

  void pickFiles() async {
    // 1. 파일 선택기 열기(FilePicker.platform.pickFiles)
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // 특정 파일만 선택 가능하게 설정
      allowedExtensions: ['xlsx'], // xlsx 확장 파일만 선택 가능하게 설정
      allowMultiple: true, // 여러 개의 파일을 선택할 수 있도록 설정
    );

    // 파일을 선택했을 경우 실행
    if (result != null) {
      for (var selectedFile in result.files) {
        // 2. 선택된 파일 처리
        // 선택한 파일의 경로를 File 객체 file에 저장
        File file = File(selectedFile.path!);

        // 선택한 엑셀 파일을 바이트 배열로 변환(readAsBytesSync)
        var bytes = file.readAsBytesSync();

        // 엑셀의 바이트 데이터를 Excel 객체로 디코드(decodeBytes)
        var excel = Excel.decodeBytes(bytes);

        // 3. Excel 데이터 처리
        // 엑셀 파일의 각 시트에 대해 반복문을 돌림
        for (var table in excel.tables.keys) {
          print('Sheet: $table'); // 시트 이름(table)
          print(
              'Max Columns: ${excel.tables[table]?.maxColumns}'); // 시트 최대 열(excel.tables[table]?.maxColumns)
          print(
              'Max Rows: ${excel.tables[table]?.maxRows}'); // 시트 최대 행(excel.tables[table]?.maxRows)

          // 시트의 각 행에 대해 반복문을 돌림
          for (var row in excel.tables[table]!.rows) {
            print('$row'); // 각 행에 대해 데이터 출력
          }
        }
      }
    } else {
      print('파일 선택 안됨');
    }
  }

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
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 5),
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
                  onPressed: pickFiles,
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
