import 'package:flutter/material.dart';
import 'package:frontend/admin/providers/admin_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContestTeamListPage extends StatefulWidget {
  const ContestTeamListPage({super.key});

  @override
  State<ContestTeamListPage> createState() => _ContestTeamListPageState();
}

// 팝업 메뉴 아이템을 생성하는 함수
PopupMenuItem<String> popUpItem(String text, String item) {
  return PopupMenuItem<String>(
    enabled: true,
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

class _ContestTeamListPageState extends State<ContestTeamListPage> {
  final TextEditingController _controller =
      TextEditingController(); // 검색창의 텍스트 컨트롤러
  DateTime? _selectedDate; // 선택된 날짜 저장하는 변수
  String _searchQuery = ''; // 검색어를 저장하는 변수
  String selectedCategory = '경진대회'; // 팝업 메뉴 카테고리 이름

  List<Map<String, dynamic>> teamList = []; // 팀 정보 리스트
  List<String> teamCategories = []; // 팀 카테고리 리스트
  List<Map<String, dynamic>> filteredTeamList = []; // 필터링된 팀 정보

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
                '선택한 팀을 정말 삭제하시겠습니까?',
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
                  // 이 부분에서 삭제 메서드를 호출
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

  // 전체 선택 상태를 변경하는 메서드
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      _selectedItems.clear();
      if (_selectAll) {
        for (int i = 0; i < teamList.length; i++) {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AdminProvider>(context, listen: false).fetchAllTeams();

      setState(() {
        // teamList에 모든 팀 데이터를 저장
        teamList = Provider.of<AdminProvider>(context, listen: false).teamList;
        filteredTeamList = teamList; // 초기에는 전체 리스트로 표시

        // teamCategories에 팀 카테고리만 추출하여 저장 (중복 제거)
        teamCategories = teamList
            .map((team) => team['teamCategory'] as String)
            .toSet()
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 제목
                const Text(
                  '경진대회 팀',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),

                // 달력
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

                // 전체 보기 버튼
                SizedBox(
                  height: 20,
                  width: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // 전체 보기로 변경
                        selectedCategory = '경진대회';
                        filteredTeamList = teamList;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A72E7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      '전체 조회',
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

            // 검색 창
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
                        fontSize: 12,
                        color: Color(0xFF848488),
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: '팀명 혹은 경진대회를 검색하세요',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery =
                              value.toLowerCase(); // 검색어가 변경될 때 상태 업데이트
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filteredTeamList = teamList.where((team) {
                          // 대소문자를 구분하지 않고 검색할 수 있도록 구현
                          final teamName =
                              team['teamName']?.toLowerCase() ?? '';
                          final teamCategory =
                              team['teamCategory']?.toLowerCase() ?? '';

                          // 팀 이름이나 카테고리가 _searchQuery를 포함하는지 확인
                          return teamName.contains(_searchQuery) ||
                              teamCategory.contains(_searchQuery);
                        }).toList();
                      });
                    },
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

            // 삭제 & 경진대회 카테고리 팝업 메뉴
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                PopupMenuButton(
                  color: const Color(0xFFEFF0F2),
                  onSelected: (String category) async {
                    setState(() {
                      // 선택한 카테고리를 저장
                      selectedCategory = category;

                      // 선택한 카테고리가 들어있는 팀정보만 추출해서 리스트화
                      filteredTeamList = teamList
                          .where((team) => team['teamCategory'] == category)
                          .toList();
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return teamCategories.map((category) {
                      return PopupMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList();
                  },
                  child: Row(
                    children: [
                      Text(
                        // 선택한 카테고리를 표시
                        selectedCategory,
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

            filteredTeamList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor:
                            const MaterialStatePropertyAll(Color(0xFFEFEFF2)),
                        columns: [
                          DataColumn(
                            label: const Text(
                              '팀명',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF848488),
                              ),
                            ),
                            onSort: (int columnIndex, bool ascending) {
                              _onColumnTap('팀명');
                            },
                          ),
                          DataColumn(
                            label: const Text(
                              '팀원',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF848488),
                              ),
                            ),
                            onSort: (int columnIndex, bool ascending) {
                              _onColumnTap('팀원');
                            },
                          ),
                          DataColumn(
                            label: const Text(
                              '경진대회',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF848488),
                              ),
                            ),
                            onSort: (int columnIndex, bool ascending) {
                              _onColumnTap('경진대회');
                            },
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          filteredTeamList.length,
                          (int index) => DataRow(
                            color: MaterialStatePropertyAll(
                              index.isEven ? Colors.white : Colors.white,
                            ),
                            cells: [
                              DataCell(
                                Text(
                                  filteredTeamList[index]['teamName'] ?? '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              DataCell(
                                Text(
                                  filteredTeamList[index]['techStacks'] != null
                                      ? (filteredTeamList[index]['techStacks']
                                              as List)
                                          .map((stack) => stack['memberName'])
                                          .join(', ')
                                      : '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              DataCell(
                                Text(
                                  filteredTeamList[index]['teamCategory'] ?? '',
                                  style: const TextStyle(fontSize: 12),
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
}
