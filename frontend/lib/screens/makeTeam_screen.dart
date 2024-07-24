import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MakeTeamPage extends StatefulWidget {
  const MakeTeamPage({super.key});

  @override
  State<MakeTeamPage> createState() => _MakeTeamPageState();
}

class _MakeTeamPageState extends State<MakeTeamPage> {
  int selectedPeopleCount = -1; // 선택된 인원 수를 저장하는 변수
  String selectedField = ''; // 선택된 희망 분야를 저장하는 변수
  DateTime? selectedEndDate; // 선택된 모집 종료 기간을 저장하는 변수

  final TextEditingController _titleController =
      TextEditingController(); // 제목 텍스트 제어하는 컨트롤러
  final TextEditingController _contentController =
      TextEditingController(); // 내용 텍스트 제어하는 컨트롤러
  final TextEditingController _chatUrlController =
      TextEditingController(); // 오픈채팅 URL 텍스트 제어하는 컨트롤러

  ValueNotifier<bool> isButtonEnabled =
      ValueNotifier(false); // 버튼 활성화 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
    _titleController
        .addListener(_validateInputs); // 제목 텍스트 변경 시 _validateInputs 호출
    _contentController
        .addListener(_validateInputs); // 내용 텍스트 변경 시 _validateInputs 호출
    _chatUrlController
        .addListener(_validateInputs); // 오픈채팅 URL 텍스트 변경 시 _validateInputs 호출
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateInputs); // 리스너 제거
    _contentController.removeListener(_validateInputs); // 리스너 제거
    _chatUrlController.removeListener(_validateInputs); // 리스너 제거
    _titleController.dispose(); // 컨트롤러 폐기
    _contentController.dispose(); // 컨트롤러 폐기
    _chatUrlController.dispose(); // 컨트롤러 폐기
    super.dispose();
  }

  void _validateInputs() {
    // 제목, 내용, 오픈채팅 URL이 비어있지 않은지 확인하여 버튼 활성화 상태 업데이트
    isButtonEnabled.value = _titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _chatUrlController.text.isNotEmpty;
  }

  // 날짜 선택기 함수
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  // 오픈채팅 URL을 자동으로 생성하는 함수
  void _generateChatUrl() {
    const baseUrl = 'https://open.kakao.com/o/';
    final chatUrl = '$baseUrl${_chatUrlController.text}';

    setState(() {
      _chatUrlController.text = chatUrl;
    });

    _validateInputs(); // URL이 변경되었으므로 입력 유효성 검사를 다시 수행합니다.
  }

  // 오픈채팅방 링크 열기 함수
  void _launchChatUrl() async {
    final chatUrl = _chatUrlController.text;
    final url = Uri.parse(chatUrl);

    // 디버깅을 위해 URL 출력
    print('Attempting to launch URL: $chatUrl');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $chatUrl';
    }
  }

  // 인원 수 버튼을 생성하는 위젯
  Widget _buildPeopleCountButton(int count) {
    bool isSelected = selectedPeopleCount == count; // 현재 버튼이 선택된 상태인지 확인
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeopleCount = count; // 버튼 클릭 시 상태 변경
        });
      },
      child: Container(
        height: 20,
        width: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFDBE7FB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            '$count명',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.black
                  : Colors.black54, // 선택된 버튼의 텍스트 색상 변경
            ),
          ),
        ),
      ),
    );
  }

  // 희망 분야 버튼을 생성하는 위젯
  Widget _buildFieldButton(String field) {
    bool isSelected = selectedField == field; // 현재 버튼이 선택된 상태인지 확인
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedField = field; // 버튼 클릭 시 상태 변경
        });
      },
      child: Container(
        height: 20,
        width: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFDBE7FB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            field,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.black
                  : Colors.black54, // 선택된 버튼의 텍스트 색상 변경
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            icon: const Icon(
              Icons.close,
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '팀원 모집',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '필요한 조건을 선택해 주세요',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                '인원 수',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              // 인원 수 선택 버튼들을 포함하는 Row
              Row(
                children: [
                  _buildPeopleCountButton(1), // 각각의 인원 수 버튼을 생성하는 메서드 호출
                  const SizedBox(width: 6),
                  _buildPeopleCountButton(2),
                  const SizedBox(width: 6),
                  _buildPeopleCountButton(3),
                  const SizedBox(width: 6),
                  _buildPeopleCountButton(4),
                ],
              ),
              const SizedBox(height: 14),
              // 희망 분야 텍스트와 검색 아이콘, 텍스트를 포함하는 Row
              Row(
                children: [
                  const Text(
                    '희망 분야 ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // 검색 아이콘을 클릭했을 때 실행할 코드
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 15,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '검색 ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 희망 분야 선택 버튼들을 포함하는 SingleChildScrollView
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFieldButton('백엔드'),
                    const SizedBox(width: 6),
                    _buildFieldButton('프론트'),
                    const SizedBox(width: 6),
                    _buildFieldButton('DevOps'),
                    const SizedBox(width: 6),
                    _buildFieldButton('데이터 엔지니어'),
                    const SizedBox(width: 6),
                    _buildFieldButton('AI'),
                    const SizedBox(width: 6),
                    _buildFieldButton('SRE'),
                    const SizedBox(width: 6),
                    _buildFieldButton('QA'),
                    const SizedBox(width: 6),
                    _buildFieldButton('Security'),
                    const SizedBox(width: 6),
                    _buildFieldButton('IoT'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '모집 종료 기간',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                '모집 기간 설정해주세요',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _selectEndDate(context), // 날짜 선택 함수 호출
                    child: Container(
                      height: 20,
                      width: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE7FB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '종료 기간 선택',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selectedEndDate != null
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    selectedEndDate != null
                        ? '${selectedEndDate!.year}.${selectedEndDate!.month}.${selectedEndDate!.day}'
                        : '날짜를 선택해주세요',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '카카오 오픈채팅방 링크',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                '오픈채팅방 링크 설정해주세요',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatUrlController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: '생성할 오픈채팅방 이름 입력해주세요',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFFC5C5C7),
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: _generateChatUrl,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _launchChatUrl,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFACC7F1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      '생성된 오픈채팅 링크 열어보기',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '글 쓰기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                '자유롭게 작성해주세요',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: '제목을 작성해주세요',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC5C5C7),
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: null, // 자동으로 확장되는 줄 수
                decoration: const InputDecoration(
                  hintText: '내용을 작성해주세요',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFC5C5C7),
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabled, // 버튼 활성화 상태를 감시
        builder: (context, isEnabled, child) {
          return GestureDetector(
            onTap: isEnabled
                ? () {
                    // 작성 완료 버튼 클릭 시 실행할 코드
                  }
                : null,
            child: Container(
              color:
                  isEnabled ? const Color(0xFFACC7F1) : Colors.grey, // 버튼 색상 변경
              height: 76,
              alignment: Alignment.center,
              child: const Text(
                '작성 완료',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
