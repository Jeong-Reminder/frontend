import 'package:flutter/material.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/makeTeam_modal.dart';

class MakeTeamPage extends StatefulWidget {
  final MakeTeam? makeTeam;
  final String? initialCategory;
  final int? announcementId;

  const MakeTeamPage(
      {super.key, this.makeTeam, this.initialCategory, this.announcementId});

  @override
  State<MakeTeamPage> createState() => _MakeTeamPageState();
}

class _MakeTeamPageState extends State<MakeTeamPage> {
  int selectedPeopleCount = -1;
  List<String> selectedFields = [];
  DateTime? selectedEndDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _chatUrlController = TextEditingController();
  final TextEditingController _fieldController =
      TextEditingController(); // 입력 필드 컨트롤러

  final FocusNode _titleFocusNode = FocusNode();
  ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  ValueNotifier<bool> isChatUrlValid = ValueNotifier(false);
  ValueNotifier<String?> fieldErrorNotifier =
      ValueNotifier<String?>(null); // 중복 경고 메시지를 위한 ValueNotifier

  bool get isEditMode => widget.makeTeam != null;

  @override
  void initState() {
    super.initState();

    // 입력 필드 유효성 검사를 위한 리스너 설정
    _titleController.addListener(_validateInputs);
    _contentController.addListener(_validateInputs);
    _chatUrlController.addListener(_validateInputs);
    _fieldController.addListener(_validateField); // 입력 필드 유효성 검사 추가
    _titleFocusNode.addListener(_handleTitleFocus);

    // initialCategory가 있을 경우 제목에 [] 안에 카테고리 이름을 설정
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      _titleController.text = '[${widget.initialCategory}] ';
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateInputs);
    _contentController.removeListener(_validateInputs);
    _chatUrlController.removeListener(_validateInputs);
    _fieldController.removeListener(_validateField);
    _titleFocusNode.removeListener(_handleTitleFocus);
    _titleController.dispose();
    _contentController.dispose();
    _chatUrlController.dispose();
    _fieldController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _validateInputs() {
    isButtonEnabled.value = _titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _chatUrlController.text.isNotEmpty;
    isChatUrlValid.value = _chatUrlController.text.isNotEmpty;
  }

  void _validateField() {
    String newField = _fieldController.text.trim();
    if (newField.isNotEmpty && selectedFields.contains(newField)) {
      fieldErrorNotifier.value = "이미 추가된 분야입니다.";
    } else {
      fieldErrorNotifier.value = null;
    }
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
    if (picked != null && picked != selectedEndDate) {
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

  Future<void> _addFieldDialog() async {
    _fieldController.clear(); // 새로 열 때마다 필드 초기화
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("희망 분야"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fieldController,
                decoration: const InputDecoration(hintText: "원하는 희망 분야를 입력하세요"),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<String?>(
                valueListenable: fieldErrorNotifier,
                builder: (context, errorText, child) {
                  return errorText != null
                      ? Text(
                          errorText,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newField = _fieldController.text.trim();
                  if (newField.isNotEmpty &&
                      !selectedFields.contains(newField)) {
                    selectedFields.add(newField);
                    Navigator.of(context).pop();
                  }
                });
              },
              child: const Text("추가"),
            ),
          ],
        );
      },
    );
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
        height: 30,
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
    return IntrinsicWidth(
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFDBE7FB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Center(
              child: Text(
                field,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.black54,
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedFields.remove(field); // X 버튼을 클릭하면 희망 분야 삭제
                });
              },
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.black,
              ),
            ),
          ],
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
                const SizedBox(height: 14),
                const Text(
                  '경진대회 총 인원 수',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPeopleCountButton(1),
                      const SizedBox(width: 6),
                      _buildPeopleCountButton(2),
                      const SizedBox(width: 6),
                      _buildPeopleCountButton(3),
                      const SizedBox(width: 6),
                      _buildPeopleCountButton(4),
                      const SizedBox(width: 6),
                      _buildPeopleCountButton(5),
                    ],
                  ),
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
                      onTap: _addFieldDialog,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 15,
                            color: Colors.black54,
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
                    children: selectedFields
                        .map((field) => Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: _buildFieldButton(field),
                            ))
                        .toList(),
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
                        height: 30,
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
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
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
                        announcementId: widget.announcementId!,
                      );

                      if (isEditMode) {
                        await context
                            .read<MakeTeamProvider>()
                            .updateMakeTeam(makeTeam);
                      } else {
                        await context
                            .read<MakeTeamProvider>()
                            .createMakeTeam(makeTeam);
                      }

                      Navigator.pop(context, makeTeam);
                    }
                  : null,
              child: Container(
                color: isEnabled ? const Color(0xFFACC7F1) : Colors.grey,
                height: 76,
                alignment: Alignment.center,
                child: Text(
                  isEditMode ? '수정 완료' : '작성 완료',
                  style: const TextStyle(
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
}
