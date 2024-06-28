import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamRecruitListPage extends StatefulWidget {
  const TeamRecruitListPage({super.key});

  @override
  State<TeamRecruitListPage> createState() => _TeamRecruitListPageState();
}

// 팝업 메뉴 아이템을 생성하는 함수
PopupMenuItem<PopUpItem> popUpItem(String text, PopUpItem item) {
  return PopupMenuItem<PopUpItem>(
    value: item,
    height: 25,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// 팝업 메뉴의 항목을 정의하는 열거형
enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 }

class _TeamRecruitListPageState extends State<TeamRecruitListPage> {
  final TextEditingController _controller =
      TextEditingController(); // 검색창의 텍스트 컨트롤러
  DateTime? _selectedDate; // 선택된 날짜 저장하는 변수
  String _searchQuery = ''; // 검색어를 저장하는 변수

  final List<Map<String, String>> _recruitList = [
    // 팀원 모집글 목록을 저장하는 리스트
    {
      "title": "제목1",
      "name": "페라자",
      "type": "IoT",
      "date": "2024-03-04 16:54:33"
    },
    {
      "title": "제목2",
      "name": "소진수",
      "type": "IoT",
      "date": "2024-03-04 16:54:33"
    },
    {
      "title": "제목3",
      "name": "민택기",
      "type": "뉴테크",
      "date": "2024-03-04 16:54:33"
    },
    {
      "title": "제목4",
      "name": "이승욱",
      "type": "멘토티",
      "date": "2024-03-04 16:54:33"
    },
    {
      "title": "제목5",
      "name": "유다은",
      "type": "IoT",
      "date": "2024-03-04 16:54:33"
    },
    {
      "title": "제목6",
      "name": "장찬현",
      "type": "뉴테크",
      "date": "2024-03-04 16:54:33"
    },
  ];

  final Map<int, bool> _selectedItems = {}; // 각 아이템의 선택 상태를 저장하는 변수
  bool _selectAll = false; // 전체 선택 상태를 저장하는 변수

  PopUpItem? _selectedPopUpItem; // 선택된 팝업 아이템을 저장하는 변수

  // 날짜 선택기를 표시하는 메서드
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // 초기 날짜는 현재 날짜로 설정
      firstDate: DateTime(2000), // 선택 가능한 최소 날짜
      lastDate: DateTime(2101), // 선택 가능한 최대 날짜
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // 선택된 날짜를 상태에 저장
      });
    }
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
      _recruitList.removeWhere((item) {
        // 리스트에서 선택된 아이템들을 제거
        int index = _recruitList.indexOf(item);
        return _selectedItems[index] ?? false;
      });
      _selectedItems.clear(); // 삭제 후 선택 상태 초기화
      _selectAll = false; // 전체 선택 상태 초기화
    });
  }

  // 전체 선택 상태를 변경하는 메서드
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      _selectedItems.clear();
      if (_selectAll) {
        for (int i = 0; i < _recruitList.length; i++) {
          _selectedItems[i] = true;
        }
      }
    });
  }

  // 특정 열을 클릭했을 때 실행되는 메서드
  void _onColumnTap(String column) {
    print('$column column tapped');
  }

  // 선택된 팝업 아이템의 텍스트를 반환하는 메서드
  String _getSelectedItemText() {
    switch (_selectedPopUpItem) {
      case PopUpItem.popUpItem1:
        return '경진대회';
      case PopUpItem.popUpItem2:
        return 'IOT';
      case PopUpItem.popUpItem3:
        return '뉴테크';
      default:
        return '경진대회';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 검색어에 따라 필터링된 모집글 목록 생성
    List<Map<String, String>> filteredRecruitList = _recruitList.where((item) {
      return item['title']!.contains(_searchQuery) ||
          item['type']!.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context); // 닫기 버튼 클릭 시 이전 화면으로 돌아감
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '팀원 모집글',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context), // 이미지 클릭 시 날짜 선택기 표시
                    child: Image.asset(
                      'assets/images/calendar.png',
                      width: 24,
                      height: 24,
                      color: const Color(0xFF33363F),
                    ),
                  ),
                  if (_selectedDate != null) // 선택된 날짜가 있을 경우에만 표시
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(_selectedDate!), // 날짜 형식 지정
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF33363F),
                        ),
                      ),
                    ),
                  const Spacer(), // 남은 공간을 차지하여 조회 버튼을 오른쪽으로 밀어냄
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
                        '조회',
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
              Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF848488)),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: '제목 혹은 경진대회를 검색하세요',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value; // 검색어가 변경될 때 상태 업데이트
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/send.png',
                          width: 16,
                          height: 16,
                          color: const Color(0xFF2A72E7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 23),
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 70,
                    child: ElevatedButton(
                      onPressed:
                          _showDeleteConfirmationDialog, // 삭제 버튼 클릭 시 모달 창 표시
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA4E44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        '삭제',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 23),
                  PopupMenuButton<PopUpItem>(
                    color: const Color(0xFFEFF0F2),
                    onSelected: (PopUpItem item) {
                      setState(() {
                        _selectedPopUpItem = item;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        popUpItem('경진대회', PopUpItem.popUpItem1),
                        const PopupMenuDivider(),
                        popUpItem('IOT', PopUpItem.popUpItem2),
                        const PopupMenuDivider(),
                        popUpItem('뉴테크', PopUpItem.popUpItem3),
                      ];
                    },
                    child: Row(
                      children: [
                        Text(
                          _getSelectedItemText(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => const Color(0xFFEFEFF2)),
                  columns: [
                    DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                            value: _selectAll,
                            onChanged: _toggleSelectAll,
                          ),
                          const Text(
                            '제목',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF848488)),
                          ),
                        ],
                      ),
                      onSort: (int columnIndex, bool ascending) {
                        _onColumnTap('제목');
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        '이름',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF848488)),
                      ),
                      onSort: (int columnIndex, bool ascending) {
                        _onColumnTap('이름');
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        '경진대회',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF848488)),
                      ),
                      onSort: (int columnIndex, bool ascending) {
                        _onColumnTap('경진대회');
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        '작성일자',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF848488)),
                      ),
                      onSort: (int columnIndex, bool ascending) {
                        _onColumnTap('작성일자');
                      },
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    filteredRecruitList.length,
                    (int index) => DataRow(
                      color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                        if (index.isEven) {
                          return Colors.white; // 짝수 열
                        }
                        return Colors.white; // 홀수 열
                      }),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Checkbox(
                                value: _selectedItems[index] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _selectedItems[index] = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                filteredRecruitList[index]['title']!,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            filteredRecruitList[index]['name']!,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        DataCell(
                          Text(
                            filteredRecruitList[index]['type']!,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        DataCell(
                          Text(
                            filteredRecruitList[index]['date']!,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
