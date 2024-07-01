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

  bool selectAll = false; // 전체 삭제 선택 상태 불리안
  final Map<int, bool> selectedItems = {}; // 각 아이템의 삭제할 선택 불리안을 저장 리스트

  bool isAscendingName = true; // 이름 정렬 순서 상태
  bool isAscendingStudentId = true; // 학번 정렬 순서 상태
  bool isAscendingGrade = true; // 학년 정렬 순서 상태
  bool isAscendingStatus = true; // 학적상태 정렬 순서 상태

  final List<Map<String, dynamic>> userList = [
    // 회원 목록을 저장하는 리스트
    {
      "name": "민택기",
      "studentId": "20190906",
      "grade": 4,
      "status": "재학",
    },
    {
      "name": "소진수",
      "studentId": "20190914",
      "grade": 4,
      "status": "휴학",
    },
    {
      "name": "이승욱",
      "studentId": "20190926",
      "grade": 3,
      "status": "재학",
    },
    {
      "name": "유다은",
      "studentId": "20210916",
      "grade": 2,
      "status": "재학",
    },
    {
      "name": "장찬현",
      "studentId": "20190934",
      "grade": 3,
      "status": "재학",
    },
    {
      "name": "김민택",
      "studentId": "20190934",
      "grade": 2,
      "status": "재학",
    },
  ];

  List<Map<String, dynamic>> filteredUserList = []; // 필터링된 회원 목록 리스트

  Map<String, dynamic> selectedUser = {}; // 수정 버튼 누를 시 선택된 회원

  @override
  void initState() {
    super.initState();
    filteredUserList = userList; // 초기 상태는 전체 회원 목록
    searchController.addListener(_filterUserList); // 검색어 변경 리스너 추가
  }

  @override
  void dispose() {
    searchController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  // 검색어에 따라 회원 목록을 필터링하는 메서드
  void _filterUserList() {
    String searchQuery = searchController.text;
    setState(() {
      // 검색어가 없으면 기존 userList를 가져오기
      if (searchQuery.isEmpty) {
        filteredUserList = userList;
      } else {
        // 검색어가 있으면 userList에 있는 이름에 하나라도 포함이 있으면 저장 후 가져오기
        filteredUserList = userList.where((user) {
          return user['name']!.contains(searchQuery);
        }).toList();
      }
    });
  }

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
      filteredUserList
          .where((item) {
            // 선택된 항목 필터링
            int index = filteredUserList.indexOf(item);
            return selectedItems[index] ?? false;
          })
          .toList()
          .forEach((item) {
            // 원본 리스트에서 해당 항목 삭제
            userList.remove(item);
          });

      selectedItems.clear(); // 삭제 후 선택 상태 초기화(false로 설정)
      selectAll = false; // 전체 선택 상태 초기화
      _filterUserList(); // 삭제 후 필터링된 리스트 업데이트
    });
  }

  // 전체 선택 상태를 변경하는 메서드
  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false; // 전체 선택 체크박스에 체크가 되어있으면 true로 반환
      selectedItems.clear();

      // true일 경우 filteredUserList를 반복해 각 아이템의 선택 상태를 true로 설정
      if (selectAll) {
        for (int i = 0; i < filteredUserList.length; i++) {
          selectedItems[i] = true;
        }
      }
    });
  }

  // 이름을 가나다순으로 정렬하는 메서드
  void _sortByName() {
    setState(() {
      if (isAscendingName) {
        filteredUserList.sort((a, b) => a['name']!.compareTo(b['name']!));
      } else {
        filteredUserList.sort((a, b) => b['name']!.compareTo(a['name']!));
      }
      isAscendingName = !isAscendingName;
    });
  }

  // 학번을 숫자 크기순으로 정렬하는 메서드
  void _sortByStudentId() {
    setState(() {
      if (isAscendingStudentId) {
        filteredUserList.sort((a, b) =>
            int.parse(a['studentId']!).compareTo(int.parse(b['studentId']!)));
      } else {
        filteredUserList.sort((a, b) =>
            int.parse(b['studentId']!).compareTo(int.parse(a['studentId']!)));
      }
      isAscendingStudentId = !isAscendingStudentId;
    });
  }

  // 학년을 숫자 크기순으로 정렬하는 메서드
  void _sortByGrade() {
    setState(() {
      if (isAscendingGrade) {
        filteredUserList.sort(
            (a, b) => int.parse(a['grade']!).compareTo(int.parse(b['grade']!)));
      } else {
        filteredUserList.sort(
            (a, b) => int.parse(b['grade']!).compareTo(int.parse(a['grade']!)));
      }
      isAscendingGrade = !isAscendingGrade;
    });
  }

  // 학적 상태를 가나다순으로 정렬하는 메서드
  void _sortByStatus() {
    setState(() {
      if (isAscendingStatus) {
        filteredUserList.sort((a, b) => a['status']!.compareTo(b['status']!));
      } else {
        filteredUserList.sort((a, b) => b['status']!.compareTo(a['status']!));
      }
      isAscendingStatus = !isAscendingStatus;
    });
  }

  List<bool> chosenGrades = [false, false, false, false];

  List<Map<String, dynamic>> status = [
    {
      'title': '재학',
      'value': false,
    },
    {
      'title': '휴학',
      'value': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    const DataColumn(
                      label: Text('정보 수정'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    filteredUserList.length,
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
                              child: Text(
                                  filteredUserList[index]['name']!)), // 중앙 정렬
                        ),
                        DataCell(
                          Center(
                              child:
                                  Text(filteredUserList[index]['studentId']!)),
                        ),
                        DataCell(
                          Center(
                              child:
                                  Text('${filteredUserList[index]['grade']}')),
                        ),
                        DataCell(
                          Center(
                              child: Text(filteredUserList[index]['status']!)),
                        ),
                        DataCell(
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedUser = filteredUserList[index];
                                });

                                _showEditDialog(context, selectedUser);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A72E7),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(60, 16),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              child: const Text(
                                '수정',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
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

  // 사용자 정보 수정 다이얼로그
  void _showEditDialog(BuildContext context, Map<String, dynamic> user) {
    // 학년 체크박스 초기화
    setState(() {
      chosenGrades = List.generate(
          4,
          (index) =>
              user['grade'] ==
              index + 1); // 선택한 회원의 학년과 (index+1)이 같으면 true로 변경

      status = status.map((item) {
        return {
          'title': item['title'],
          'value': item['title'] ==
              user['status'] // title(재학 or 휴학)과 status(재학 or 휴학)이 같다면 true 반환
        };
      }).toList();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 34.0, vertical: 55.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        '사용자 정보 수정',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Divider(),
                      Row(
                        children: [
                          const Text(
                            '학번',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: TextFormField(
                              initialValue: user['studentId'],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text(
                            '이름',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: TextFormField(
                              initialValue: user['name'],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text(
                            '학년',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 35),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(4, (index) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: chosenGrades[index],
                                        onChanged: (value) {
                                          setState(() {
                                            chosenGrades[index] = value!;
                                          });
                                        },
                                      ),
                                      Text('${index + 1}학년'),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text(
                            '학적 상태',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(2, (index) {
                                  var st = status[index];
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: st['value'],
                                        onChanged: (value) {
                                          setState(() {
                                            st['value'] = value!;
                                          });
                                        },
                                      ),
                                      Text(st['title']),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              minimumSize: const Size(57, 25),
                            ),
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A72E7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              minimumSize: const Size(57, 25),
                            ),
                            child: const Text(
                              '수정',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
