import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController searchController = TextEditingController(); // 검색 컨트롤러
  FilePickerResult? pickedFile;
  String searchQuery = ''; // 검색어를 저장하는 변수

  bool selectAll = false; // 전체 삭제 선택 상태 불리안
  final Map<int, bool> selectedItems = {}; // 각 아이템의 삭제할 선택 불리안을 저장 리스트

  bool isAscendingName = true; // 이름 정렬 순서 상태
  bool isAscendingStudentId = true; // 학번 정렬 순서 상태
  bool isAscendingGrade = true; // 학년 정렬 순서 상태
  bool isAscendingStatus = true; // 학적상태 정렬 순서 상태

  final List<Map<String, String>> userList = [
    // 회원 목록을 저장하는 리스트
    {
      "name": "민택기",
      "studentId": "20190906",
      "grade": "4",
      "status": "재학",
    },
    {
      "name": "소진수",
      "studentId": "20190914",
      "grade": "4",
      "status": "휴학",
    },
  ];

  // 삭제 확인 다이얼로그를 표시하는 메서드
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // 모달 배경색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ), // 모서리 둥글게
          title: const Column(
            children: [
              Text(
                '선택한 계정을 정말 삭제하시겠습니까?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '삭제하면 되돌릴 수 없습니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: 74,
              height: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: const BorderSide(color: Color(0xFFD9D9D9))),
                ),
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Color(0xFF2A72E7),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 74,
              height: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteSelectedItems();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA4E44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  '삭제',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
        );
      },
    );
  }

  // 개별 선택된 아이템들을 삭제하는 메서드
  void _deleteSelectedItems() {
    setState(() {
      userList.removeWhere((item) {
        // 리스트에서 선택된 아이템들을 제거
        int index = userList.indexOf(item); // indexOf: 특정 인덱스값만 가져오는 메서드
        return selectedItems[index] ?? false; // 선택된 아이템이 있으면 true로 반환해 아이템 제거
      });
      selectedItems.clear(); // 삭제 후 선택 상태 초기화(false로 설정)
      selectAll = false; // 전체 선택 상태 초기화
    });
  }

  // 전체 선택 상태를 변경하는 메서드
  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false; // 전체 선택 체크박스에 체크가 되어있으면 true로 반환
      selectedItems.clear();

      // true일 경우 userList를 반복해 각 아이템의 선택 상태를 true로 설정
      if (selectAll) {
        for (int i = 0; i < userList.length; i++) {
          selectedItems[i] = true;
        }
      }
    });
  }

  // 이름을 가나다순으로 정렬하는 메서드
  void _sortByName() {
    setState(() {
      if (isAscendingName) {
        userList.sort((a, b) => a['name']!.compareTo(b['name']!));
      } else {
        userList.sort((a, b) => b['name']!.compareTo(a['name']!));
      }
      isAscendingName = !isAscendingName;
    });
  }

  // 학번을 숫자 크기순으로 정렬하는 메서드
  void _sortByStudentId() {
    setState(() {
      if (isAscendingStudentId) {
        userList.sort((a, b) =>
            int.parse(a['studentId']!).compareTo(int.parse(b['studentId']!)));
      } else {
        userList.sort((a, b) =>
            int.parse(b['studentId']!).compareTo(int.parse(a['studentId']!)));
      }
      isAscendingStudentId = !isAscendingStudentId;
    });
  }

  // 학년을 숫자 크기순으로 정렬하는 메서드
  void _sortByGrade() {
    setState(() {
      if (isAscendingGrade) {
        userList.sort(
            (a, b) => int.parse(a['grade']!).compareTo(int.parse(b['grade']!)));
      } else {
        userList.sort(
            (a, b) => int.parse(b['grade']!).compareTo(int.parse(a['grade']!)));
      }
      isAscendingGrade = !isAscendingGrade;
    });
  }

  // 학적 상태를 가나다순으로 정렬하는 메서드
  void _sortByStatus() {
    setState(() {
      if (isAscendingStatus) {
        userList.sort((a, b) => a['status']!.compareTo(b['status']!));
      } else {
        userList.sort((a, b) => b['status']!.compareTo(a['status']!));
      }
      isAscendingStatus = !isAscendingStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 검색어에 따라 필터링된 회원 정보 목록 생성
    List<Map<String, String>> searchedUserList = userList.where((item) {
      return item['name']!
          .contains(searchQuery); // 검색한 이름이 표에서의 이름에 하나라도 포함이 된다면 해당 정보들을 반환
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 133.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원 정보 목록',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
              elevation: const MaterialStatePropertyAll(0), // 그림자 없음
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
              onChanged: (value) {
                setState(() {
                  searchQuery = searchController.text;
                });
              },
            ),
            const SizedBox(height: 23),

            // 삭제 & 조회 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 선택된 아이템이 포함될 경우 삭제 다이얼로그 표시
                        if (selectedItems.values.contains(true)) {
                          _showDeleteConfirmationDialog();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                '삭제할 항목을 선택하세요',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }
                      },
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
                  onPressed: () async {
                    // 파일 선택기 열기(FilePicker.platform.pickFiles)
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom, // 특정 파일을 선택 가능하게 설정
                      allowedExtensions: ['xlsx'],
                      allowMultiple: true, // 여러 개의 파일을 선택할 수 있도록 설정
                    );

                    if (result != null) {
                      for (var selectedFile in result.files) {
                        print('파일 이름: ${selectedFile.name}');

                        // 선택된 파일의 경로를 File 객체 file에 저장
                        File file = File(selectedFile.path!);

                        // 선택된 엑셀 파일을 바이트 배열로 변환(readAsBytesSync)
                        var fileBytes = file.readAsBytesSync();
                        print('바이트 데이터: $fileBytes');
                      }
                    }
                  },
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
            const SizedBox(height: 20),

            // 회원정보 표
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  headingRowColor: const MaterialStatePropertyAll(
                    Color(0xFFEFEFF2),
                  ),
                  columns: [
                    DataColumn(
                      label: Flexible(
                          child: Center(
                        child: Checkbox(
                          value: selectAll,
                          onChanged: _toggleSelectAll,
                        ),
                      )), // 중앙 정렬
                    ),
                    dataColumn('이름', isAscendingName, _sortByName),
                    dataColumn('학번', isAscendingStudentId, _sortByStudentId),
                    dataColumn('학년', isAscendingGrade, _sortByGrade),
                    dataColumn('학적상태', isAscendingStatus, _sortByStatus),
                  ],
                  rows: List<DataRow>.generate(
                    // 검색을 하면 searchedUserList로 보여주거나 검색한 게 없으면 userList로 보여주기
                    searchQuery.isEmpty
                        ? userList.length
                        : searchedUserList.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Checkbox(
                              value: selectedItems[index] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  // 선택된 체크박스는 true로 반환
                                  selectedItems[index] = value ?? false;
                                });
                              },
                            ),
                          ), // 중앙 정렬
                        ),
                        DataCell(
                          Center(
                              child: Text(userList[index]['name']!)), // 중앙 정렬
                        ),
                        DataCell(
                          Center(child: Text(userList[index]['studentId']!)),
                        ),
                        DataCell(
                          Center(child: Text(userList[index]['grade']!)),
                        ),
                        DataCell(
                          Center(child: Text(userList[index]['status']!)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 데이터 열
  DataColumn dataColumn(String label, bool isAscending, VoidCallback sort) {
    return DataColumn(
      label: Row(
        children: [
          Text(label),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              isAscending ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
            ),
            onPressed: sort,
          ),
        ],
      ),
    );
  }
}
