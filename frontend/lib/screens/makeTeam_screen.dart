import 'package:flutter/material.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/makeTeam_modal.dart';

class MakeTeamPage extends StatefulWidget {
  final MakeTeam? makeTeam; // 수정할 팀원 모집글을 받아옴 (nullable)
  const MakeTeamPage({super.key, this.makeTeam});

  @override
  State<MakeTeamPage> createState() => _MakeTeamPageState();
}

class _MakeTeamPageState extends State<MakeTeamPage> {
  int selectedPeopleCount = -1; // 선택된 인원 수를 저장하는 변수
  List<String> selectedFields = []; // 선택된 희망 분야를 저장하는 리스트
  DateTime? selectedEndDate; // 선택된 모집 종료 기간을 저장하는 변수

  final TextEditingController _titleController =
      TextEditingController(); // 제목 텍스트 제어하는 컨트롤러
  final TextEditingController _contentController =
      TextEditingController(); // 내용 텍스트 제어하는 컨트롤러
  final TextEditingController _chatUrlController =
      TextEditingController(); // 오픈채팅 URL 텍스트 제어하는 컨트롤러
  final FocusNode _titleFocusNode = FocusNode(); // 포커스 노드

  ValueNotifier<bool> isButtonEnabled =
      ValueNotifier(false); // 버튼 활성화 상태를 관리하는 변수
  ValueNotifier<bool> isChatUrlValid =
      ValueNotifier(false); // 오픈채팅 URL 유효성 상태를 관리하는 변수

  // 글 제목에서 대괄호([]) 안의 경진대회 이름을 추출하는 함수
  String _parseCompetitionName(String title) {
    final RegExp regExp = RegExp(
      r'\[(.*?)\]',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(title);
    if (match != null) {
      return match.group(1)?.trim() ?? '';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateInputs);
    _contentController.addListener(_validateInputs);
    _chatUrlController.addListener(_validateInputs);
    _titleFocusNode.addListener(_handleTitleFocus);

    if (widget.makeTeam != null) {
      _titleController.text = widget.makeTeam!.recruitmentTitle;
      _contentController.text = widget.makeTeam!.recruitmentContent;
      _chatUrlController.text = widget.makeTeam!.kakaoUrl;
      selectedPeopleCount = widget.makeTeam!.studentCount;
      selectedFields = widget.makeTeam!.hopeField.split(', ');
      selectedEndDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(widget.makeTeam!.endTime);
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateInputs);
    _contentController.removeListener(_validateInputs);
    _chatUrlController.removeListener(_validateInputs);
    _titleFocusNode.removeListener(_handleTitleFocus);
    _titleController.dispose();
    _contentController.dispose();
    _chatUrlController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _validateInputs() {
    isButtonEnabled.value = _titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _chatUrlController.text.isNotEmpty;
    isChatUrlValid.value = _chatUrlController.text.isNotEmpty;
  }

  void _handleTitleFocus() {
    if (_titleFocusNode.hasFocus && _titleController.text.isEmpty) {
      setState(() {
        _titleController.text = '[]';
        _titleController.selection = TextSelection.fromPosition(
          const TextPosition(offset: 1),
        );
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null || picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  void _generateChatUrl() {
    const baseUrl = 'https://open.kakao.com/o/';
    final chatUrl = '$baseUrl${_chatUrlController.text}';

    setState(() {
      _chatUrlController.text = chatUrl;
    });

    _validateInputs();
  }

  void _launchChatUrl() async {
    final chatUrl = _chatUrlController.text;
    final url = Uri.parse(chatUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $chatUrl';
    }
  }

  Widget _buildPeopleCountButton(int count) {
    bool isSelected = selectedPeopleCount == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeopleCount = count;
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
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldButton(String field) {
    bool isSelected = selectedFields.contains(field);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedFields.remove(field);
          } else {
            selectedFields.add(field);
          }
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
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateConfirmationDialog(MakeTeam makeTeam) {
    // 모달 창에서 상태 관리를 위한 변수를 초기화
    TextEditingController titleController =
        TextEditingController(text: makeTeam.recruitmentTitle);
    TextEditingController contentController =
        TextEditingController(text: makeTeam.recruitmentContent);
    TextEditingController chatUrlController =
        TextEditingController(text: makeTeam.kakaoUrl);
    int updatedSelectedPeopleCount = makeTeam.studentCount;
    List<String> updatedSelectedFields = makeTeam.hopeField.split(', ');
    DateTime updatedSelectedEndDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(makeTeam.endTime);

    // 모달 창을 띄워 사용자 입력을 받음
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('팀원 모집글 수정'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // 인원 수
                    Row(
                      children: [
                        const Text(
                          '인원 수',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildPeopleCountButtonInDialog(
                                    1, updatedSelectedPeopleCount, (value) {
                                  setState(() {
                                    updatedSelectedPeopleCount = value;
                                  });
                                }),
                                const SizedBox(width: 6),
                                _buildPeopleCountButtonInDialog(
                                    2, updatedSelectedPeopleCount, (value) {
                                  setState(() {
                                    updatedSelectedPeopleCount = value;
                                  });
                                }),
                                const SizedBox(width: 6),
                                _buildPeopleCountButtonInDialog(
                                    3, updatedSelectedPeopleCount, (value) {
                                  setState(() {
                                    updatedSelectedPeopleCount = value;
                                  });
                                }),
                                const SizedBox(width: 6),
                                _buildPeopleCountButtonInDialog(
                                    4, updatedSelectedPeopleCount, (value) {
                                  setState(() {
                                    updatedSelectedPeopleCount = value;
                                  });
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // 희망 분야
                    Row(
                      children: [
                        const Text(
                          '희망 분야',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <String>[
                                '백엔드',
                                '프론트',
                                'DevOps',
                                '데이터 엔지니어',
                                'AI',
                                'SRE',
                                'QA',
                                'Security',
                                'IoT'
                              ].map((String field) {
                                return _buildFieldButtonInDialog(
                                    field, updatedSelectedFields, (selected) {
                                  setState(() {
                                    if (selected) {
                                      updatedSelectedFields.add(field);
                                    } else {
                                      updatedSelectedFields.remove(field);
                                    }
                                  });
                                });
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // 종료 기간
                    Row(
                      children: [
                        const Text(
                          '종료 기간',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: updatedSelectedEndDate,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2101),
                            );

                            if (picked != null) {
                              setState(() {
                                updatedSelectedEndDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${updatedSelectedEndDate.year}-${updatedSelectedEndDate.month}-${updatedSelectedEndDate.day}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(chatUrlController, '오픈채팅방 링크'),
                    _buildTextField(titleController, '제목'),
                    _buildTextField(contentController, '내용'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 모달 닫기
                  },
                ),
                TextButton(
                  child: const Text('수정'),
                  onPressed: () async {
                    // MakeTeam 객체 업데이트
                    MakeTeam updatedMakeTeam = MakeTeam(
                      id: makeTeam.id,
                      recruitmentCategory: makeTeam.recruitmentCategory,
                      recruitmentTitle: titleController.text,
                      recruitmentContent: contentController.text,
                      studentCount: updatedSelectedPeopleCount,
                      hopeField: updatedSelectedFields.join(', '),
                      kakaoUrl: chatUrlController.text,
                      recruitmentStatus: makeTeam.recruitmentStatus,
                      endTime: DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                          .format(updatedSelectedEndDate),
                      announcementId: 1,
                    );

                    // 업데이트된 객체를 Provider를 통해 저장
                    await Provider.of<MakeTeamProvider>(context, listen: false)
                        .updateMakeTeam(updatedMakeTeam);

                    // 메인 화면 업데이트
                    setState(() {
                      widget.makeTeam?.id = updatedMakeTeam.id;
                      _titleController.text = updatedMakeTeam.recruitmentTitle;
                      _contentController.text =
                          updatedMakeTeam.recruitmentContent;
                      _chatUrlController.text = updatedMakeTeam.kakaoUrl;
                      selectedPeopleCount = updatedMakeTeam.studentCount;
                      selectedFields = updatedMakeTeam.hopeField.split(', ');
                      selectedEndDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                          .parse(updatedMakeTeam.endTime);
                    });

                    // 모달 닫기
                    Navigator.of(context).pop(true); // 변경 사항이 있다는 플래그 전달
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value == true) {
        // 변경 사항이 있을 경우 setState로 메인 화면 업데이트
        setState(() {});
      }
    });
  }

  Widget _buildPeopleCountButtonInDialog(
      int count, int selectedCount, Function(int) onTap) {
    bool isSelected = selectedCount == count;
    return GestureDetector(
      onTap: () {
        onTap(count);
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
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldButtonInDialog(
      String field, List<String> selectedFields, Function(bool) onTap) {
    bool isSelected = selectedFields.contains(field);
    return GestureDetector(
      onTap: () {
        onTap(!isSelected);
      },
      child: Container(
        height: 20,
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
              color: isSelected ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MakeTeamProvider(),
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '경진대회 팀원 모집',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '필요한 조건을 선택해 주세요',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String competitionName =
                                _parseCompetitionName(_titleController.text);
                            if (competitionName.isNotEmpty) {
                              print('경진대회 이름: $competitionName');
                            }

                            MakeTeam makeTeam = MakeTeam(
                              id: widget.makeTeam?.id,
                              recruitmentCategory: competitionName,
                              recruitmentTitle: _titleController.text,
                              recruitmentContent: _contentController.text,
                              studentCount: selectedPeopleCount,
                              hopeField: selectedFields.join(', '),
                              kakaoUrl: _chatUrlController.text,
                              recruitmentStatus: true,
                              endTime: selectedEndDate != null
                                  ? DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                      .format(selectedEndDate!)
                                  : '',
                              announcementId: 1,
                            );

                            _showUpdateConfirmationDialog(makeTeam);
                          },
                          child: Container(
                            height: 20,
                            width: 60,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A72E7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                              child: Text(
                                '수정',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 20,
                            width: 60,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEA4E44),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                              child: Text(
                                '삭제',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  '인원 수',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildPeopleCountButton(1),
                    const SizedBox(width: 6),
                    _buildPeopleCountButton(2),
                    const SizedBox(width: 6),
                    _buildPeopleCountButton(3),
                    const SizedBox(width: 6),
                    _buildPeopleCountButton(4),
                  ],
                ),
                const SizedBox(height: 14),
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
                      onTap: () => _selectEndDate(context),
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
                  '카카오톡 오픈채팅방 링크',
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
                            fontWeight: FontWeight.bold,
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
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _launchChatUrl,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBE7FB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isChatUrlValid,
                        builder: (context, isValid, child) {
                          return Text(
                            '생성된 오픈채팅 링크 열어보기',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isValid ? Colors.black : Colors.black54,
                            ),
                          );
                        },
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
                  focusNode: _titleFocusNode,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: '[] 제목을 작성해주세요',
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
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: '내용을 작성해주세요',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
          valueListenable: isButtonEnabled,
          builder: (context, isEnabled, child) {
            return GestureDetector(
              onTap: isEnabled
                  ? () async {
                      String competitionName =
                          _parseCompetitionName(_titleController.text);
                      if (competitionName.isNotEmpty) {
                        print('경진대회 이름: $competitionName');
                      }

                      MakeTeam makeTeam = MakeTeam(
                        id: widget.makeTeam?.id,
                        recruitmentCategory: competitionName,
                        recruitmentTitle: _titleController.text,
                        recruitmentContent: _contentController.text,
                        studentCount: selectedPeopleCount,
                        hopeField: selectedFields.join(', '),
                        kakaoUrl: _chatUrlController.text,
                        recruitmentStatus: true,
                        endTime: selectedEndDate != null
                            ? DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                .format(selectedEndDate!)
                            : '',
                        announcementId: 1,
                      );

                      if (widget.makeTeam != null) {
                        await context
                            .read<MakeTeamProvider>()
                            .updateMakeTeam(makeTeam);
                      } else {
                        await context
                            .read<MakeTeamProvider>()
                            .createMakeTeam(makeTeam);
                      }

                      // Navigator.pop(context);
                    }
                  : null,
              child: Container(
                color: isEnabled ? const Color(0xFFACC7F1) : Colors.grey,
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
      ),
    );
  }
}
