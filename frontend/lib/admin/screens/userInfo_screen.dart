import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:frontend/admin/screens/addMember_screen.dart';
import 'package:frontend/admin/services/userInfo_service.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController searchController = TextEditingController(); // 검색 컨트롤러
  TextEditingController idController = TextEditingController(); // 학번 컨트롤러
  TextEditingController nameController = TextEditingController(); // 이름 컨트롤러

  File? file;

  bool selectAll = false; // 전체 삭제 선택 상태 불리안
  List<bool> selectedMembers = []; // 각 아이템의 삭제할 선택 불리안을 저장 리스트
  List<String> selectedStudentIds = [];

  bool isAscendingName = true; // 이름 정렬 순서 상태
  bool isAscendingStudentId = true; // 학번 정렬 순서 상태
  bool isAscendingGrade = true; // 학년 정렬 순서 상태
  bool isAscendingStatus = true; // 학적상태 정렬 순서 상태

  Future<List<Admin>>? userList;
  List<Admin> filteredUserList = []; // 필터링된 회원 목록 리스트

  final List<Map<String, dynamic>> dummyUserList = [
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

  Admin? selectedUser; // 수정 버튼 누를 시 선택된 회원

  @override
  void initState() {
    super.initState();
    // filteredUserList = dummyUserList; // 초기 상태는 전체 회원 목록
    searchController.addListener(_filterUserList); // 검색어 변경 리스너 추가
    userList = AdminProvider().getMembers(); // 초기화
  }

  // 파일 선택 메소드
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    // 다른 파일로 갈 경우
    if (result != null) {
      // shard_preference에 저장되어있던 파일경로를 가져와서 삭제
      // String? oldFilePath = await _getFilePathFromPreferences();
      // if (File(oldFilePath).existsSync()) {
      //   File(oldFilePath).deleteSync();
      // }

      // 새로 선택한 파일을 File 타입의 file에 저장 후 shared_preference에 저장
      setState(() {
        file = File(result.files.single.path!);
      });
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      await UserService().updateMember(file!);

      // 파일 불러오면 회원정보를 전체 조회 api 호출 후 userList에 저장
      setState(() {
        userList = adminProvider.getMembers();
      });

      print("파일이 선택되었습니다: ${file!.path}");
    } else {
      print('No files selected.');
    }
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
        userList?.then((userListData) {
          setState(() {
            filteredUserList = userListData;
          });
        });
      } else {
        // 검색어가 있으면 userList에 있는 이름에 하나라도 포함이 있으면 저장 후 가져오기
        userList?.then((userListData) {
          setState(() {
            filteredUserList = userListData.where((user) {
              return user.name.contains(searchQuery);
            }).toList();
          });
        });
      }
    });
  }

  // 삭제 확인 다이얼로그를 표시하는 메서드
  void _showDeleteConfirmationDialog(List<String> studentIds) {
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
                onPressed: () async {
                  try {
                    await UserService().deleteMembers(studentIds);
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/user-info');
                    }
                  } catch (e) {
                    print(e);
                  }
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

  // 학년 체크박스 상태
  List<bool> chosenGrades = [false, false, false, false];

  // 휴학과 재학일 때 불리안 지정
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 50.0),
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
              onTap: () {
                _filterUserList();
              },
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
                        if (selectedMembers.contains(true)) {
                          _showDeleteConfirmationDialog(selectedStudentIds);
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
                        print('selectedStudentIds: $selectedStudentIds');
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddMemberPage(),
                          ),
                        );
                        print("userList: $userList");
                      },
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
                        '추가',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // 파일 불러오기 버튼
                ElevatedButton(
                  onPressed: _pickFile,
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
            Consumer<AdminProvider>(
              builder: (context, provider, child) {
                return FutureBuilder<List<Admin>>(
                  future: searchController.text.isEmpty
                      ? userList
                      : Future.value(filteredUserList),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('에러 로딩 데이터'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          Image.asset('assets/images/frust.png', scale: 4.0),
                          const Text(
                            '저장된 멤버가 없습니다',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ));
                    }

                    List<Admin> userListData = snapshot.data!;
                    // selectedMembers 리스트의 길이를 userListData의 길이를 동일하게 설정
                    if (selectedMembers.length != userListData.length) {
                      selectedMembers.clear();
                      selectedMembers.addAll(
                        List<bool>.filled(userListData.length, false),
                      );
                    }
                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
                                        onChanged: (bool? value) {
                                          setState(() {
                                            selectAll = value ??
                                                false; // 전체 선택 체크박스에 체크가 되어있으면 true로 반환
                                            selectedMembers.clear();
                                            selectedStudentIds.clear();

                                            // true일 경우 userListData를 반복해 각 아이템의 선택 상태를 true로 설정
                                            if (selectAll) {
                                              for (int i = 0;
                                                  i < userListData.length;
                                                  i++) {
                                                selectedMembers.add(true);
                                                selectedStudentIds.add(
                                                    userListData[i].studentId);
                                              }
                                            } else {
                                              selectedMembers.addAll(
                                                List<bool>.filled(
                                                    userListData.length, false),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ), // 중앙 정렬
                                ),
                                dataColumn('이름', isAscendingName),
                                dataColumn('학번', isAscendingStudentId),
                                dataColumn('학년', isAscendingGrade),
                                dataColumn('학적상태', isAscendingStatus),
                                const DataColumn(
                                  label: Text('정보 수정'),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                userListData.length,
                                (index) => DataRow(
                                  cells: [
                                    DataCell(
                                      Center(
                                        child: Checkbox(
                                          value: selectedMembers[
                                              index], // 체크박스의 현재 상태(false)
                                          onChanged: (bool? value) {
                                            setState(() {
                                              // 선택된 체크박스는 상태 값 변환
                                              selectedMembers[index] =
                                                  value ?? false;
                                              // 체크박스가 선택된 경우 해당 인덱스로 userListData를 접근한 후
                                              // 학번을 가져와 추가
                                              if (selectedMembers[index]) {
                                                selectedStudentIds.add(
                                                    userListData[index]
                                                        .studentId);
                                              } else {
                                                selectedStudentIds.remove(
                                                    userListData[index]
                                                        .studentId);
                                              }
                                            });
                                          },
                                        ),
                                      ), // 중앙 정렬
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(userListData[index]
                                              .name)), // 중앙 정렬
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              userListData[index].studentId)),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${userListData[index].level}')),
                                    ),
                                    DataCell(
                                      Center(
                                          child:
                                              Text(userListData[index].status)),
                                    ),
                                    DataCell(
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedUser =
                                                  userListData[index];
                                            });

                                            _showEditDialog(
                                              context,
                                              userListData[index],
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF2A72E7),
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(60, 16),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
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
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 사용자 정보 수정 다이얼로그
  void _showEditDialog(BuildContext context, Admin user) {
    // 학년 체크박스 초기화
    setState(() {
      chosenGrades = List.generate(
          4,
          (index) =>
              user.level == index + 1); // index + 1을 더한 값을 user의 학년에 저장해 4만큼 생성

      status = status.map((item) {
        return {
          'title': item['title'],
          'value': item['title'] == user.status, // 선택한 회원의 학적상태 저장
        };
      }).toList();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            String existStudentId = user.studentId;

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
                              initialValue: user.studentId, // 해당 회원의 학번 표시
                              readOnly: true, // 고정값이기 때문에 수정 불가능으로 설정
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
                              initialValue: user.name,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  user.name = value; // 수정한 이름으로 변경
                                });
                              },
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
                                          setStateDialog(() {
                                            setState(() {
                                              // 선택한 체크박스는 true로 변환 후 해당 index에 1을 더해 학년 값으로 변경
                                              for (int i = 0;
                                                  i < chosenGrades.length;
                                                  i++) {
                                                chosenGrades[i] = false;
                                              }
                                              chosenGrades[index] = true;
                                              user.level = index + 1;
                                            });
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
                                          setStateDialog(() {
                                            if (value!) {
                                              // 선택한 체크박스에 true로 변환해 true인 title 값을 회원의 학적상태에 저장해 변환
                                              for (var statusItem in status) {
                                                statusItem['value'] = false;
                                              }
                                              st['value'] = true;
                                              user.status = st['title'];
                                            }
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
                            onPressed: () async {
                              try {
                                final adminProvider =
                                    Provider.of<AdminProvider>(context,
                                        listen: false);
                                await adminProvider.editMemberProvider(
                                    user); // 회원 수정 provider 호출
                                print('기존 회원 학번: $existStudentId');

                                if (context.mounted) {
                                  Navigator.pop(
                                      context); // 화면을 닫고 이전 화면으로 이동(수정한 회원이 그 자리에 유지, 디버깅됐을 때는 아님)
                                }
                              } catch (e) {
                                print("회원 수정 오류 (수정 버튼 클릭): $e");
                              }
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
  DataColumn dataColumn(
    String label,
    bool isAscending,
  ) {
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
