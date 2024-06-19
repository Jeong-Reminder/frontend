import 'dart:io'; // 파일을 다루기 위해 필요
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BoardWritePage extends StatefulWidget {
  const BoardWritePage({super.key});

  @override
  State<BoardWritePage> createState() => _BoardWritePageState();
}

class _BoardWritePageState extends State<BoardWritePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isButtonEnabled = false; // 작성 완료 버튼 상태
  bool isMustRead = false;
  bool isOpenVote = false;

  bool categoryBtn = true; // 공지 혹은 학년 버튼 여부
  List<bool> isCategory = [false, false, false, false]; // 공지 선택 불리안
  List<bool> isGrade = [false, false, false, false, false]; // 학년 선택 불리안

  File? pickedImage; // 선택된 이미지 파일
  bool isPickingImage = false; // 이미지 선택 작업 진행 여부

  bool isMultiplied = false;

  // 기본 3개의 텍스트폼필드의 컨트롤러
  List<TextEditingController> voteControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ]; // 투표 항목 컨트롤러 리스트

  @override
  void initState() {
    super.initState();
    // 텍스트 변경 감지 리스너 추가
    titleController.addListener(checkIfFormIsFilled);
    contentController.addListener(checkIfFormIsFilled);
  }

  @override
  void dispose() {
    titleController.removeListener(checkIfFormIsFilled);
    contentController.removeListener(checkIfFormIsFilled);
    titleController.dispose();
    contentController.dispose();
    for (var controller in voteControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 폼필드에 텍스트가 채워졌는지 확인
  void checkIfFormIsFilled() {
    setState(() {
      // 글자가 있으면 true 반환
      isButtonEnabled =
          titleController.text.isNotEmpty && contentController.text.isNotEmpty;
    });
  }

  // 이미지 선택 함수
  Future<void> _pickImage(ImageSource source) async {
    if (isPickingImage) return; // 이미지 선택 작업이 이미 진행 중이면 중단

    setState(() {
      isPickingImage = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }

    setState(() {
      isPickingImage = false;
    });
  }

  // 이미지 삭제 함수
  void _deleteImage() {
    setState(() {
      pickedImage = null;
    });
  }

  // voteController 추가 함수
  void _addVoteItem() {
    setState(() {
      voteControllers.add(TextEditingController());
    });
  }

  // 아이템 재정렬 함수
  void _reorderVoteItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      // 새 위치를 추가하고 이전 위치는 제거해서 순서 변경
      final item = voteControllers.removeAt(oldIndex);
      voteControllers.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 버튼과 키보드가 겹쳐도 오류가 안나게 하기
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력 필드
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 315,
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: '제목을 입력해주세요',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.25),
                      ),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10.0),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSaved: (val) {
                      setState(() {
                        titleController.text = val!;
                      });
                    },
                  ),
                ),

                // 미리보기
                Padding(
                  padding: const EdgeInsets.only(right: 17.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showPreview(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDBE7FB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                    ),
                    child: const Text(
                      '미리보기',
                      style: TextStyle(
                        color: Color(0xFF6E747E),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(
                color: Color(0xFFC5C5C7),
              ),
            ),

            // 내용 입력 필드
            SizedBox(
              height: 210,
              width: double.infinity,
              child: TextFormField(
                maxLines: null, // 여러 줄 입력 가능하게 설정
                expands: true, // 텍스트필드 높이 확장
                textInputAction: TextInputAction.done,
                controller: contentController,
                decoration: InputDecoration(
                  hintText: '내용을 입력해주세요',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.25),
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                ),
                onSaved: (val) {
                  setState(() {
                    contentController.text = val!;
                  });
                },
              ),
            ),
            Row(
              children: [
                // 카메라 & 파일 버튼
                camFileBtn(
                    onTap: () => _pickImage(ImageSource.camera),
                    rightWidth: 1,
                    icon: Icons.camera_alt_outlined,
                    title: '카메라'),
                camFileBtn(
                    onTap: () => _pickImage(ImageSource.gallery),
                    rightWidth: 0,
                    icon: Icons.file_present,
                    title: '파일'),
              ],
            ),
            const SizedBox(height: 20),

            // 선택된 사진
            if (pickedImage != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Stack(
                  children: [
                    Image.file(
                      pickedImage!,
                      height: 80,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                    ),
                    Positioned(
                      right: 275,
                      top: -5,
                      child: IconButton(
                        icon: const Icon(Icons.close_outlined,
                            color: Colors.black),
                        onPressed: _deleteImage,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 25),

            // 설정
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0),
              child: Text(
                '설정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 공지 토글 버튼
            toggleButtons(
                title: '공지', isSelected: isCategory, categoryBtn: true),

            // 학년 토글 버튼
            toggleButtons(title: '학년', isSelected: isGrade, categoryBtn: false),
            const SizedBox(height: 5.0),

            // 필독 버튼
            readVoteBtn(
                title: '필독',
                imgPath: 'assets/images/mustRead.png',
                state: isMustRead,
                onPressed: () {
                  setState(() {
                    isMustRead = !isMustRead;
                  });
                }),
            const SizedBox(height: 5.0),

            // 투표 버튼
            readVoteBtn(
              title: '투표',
              imgPath: 'assets/images/vote.png',
              state: isOpenVote,
              onPressed: () {
                setState(() {
                  isOpenVote = !isOpenVote;
                });

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter bottomState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22.0, vertical: 40.0),

                            // 모달 내부 영역
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 제목 입력 필드
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: '제목을 입력해주세요',
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFC5C5C7),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                  ),
                                ),
                                const SizedBox(height: 19),

                                // 투표 항목 입력 필드
                                // 목록의 순서를 재배열시켜주는 위젯
                                ReorderableListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),

                                  // 아이템을 재정렬할 때 호출
                                  // 아이템을 이동할 때 함수를 사용해서 아이템의 순서를 업데이트
                                  onReorder: (oldIndex, newIndex) {
                                    bottomState(() {
                                      setState(() {
                                        _reorderVoteItems(oldIndex, newIndex);
                                      });
                                    });
                                  },
                                  children: [
                                    for (int index = 0;
                                        index < voteControllers.length;
                                        index++)

                                      // 드래그가 되지 않아 ListTile로 구현
                                      // 투표 항목
                                      ListTile(
                                        key: ValueKey(index),
                                        title: TextFormField(
                                          controller: voteControllers[index],
                                          decoration: InputDecoration(
                                            hintText: '${index + 1}. 항목을 입력하세요',
                                            hintStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFC5C5C7),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 5.0),
                                          ),
                                        ),
                                        trailing: const Icon(Icons.menu),
                                      ),
                                  ],
                                ),

                                // 항목 추가 버튼
                                TextButton.icon(
                                  onPressed: () {
                                    bottomState(() {
                                      _addVoteItem(); // 투표 항목 추가 함수 호출
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    '항목 추가',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Divider(),
                                const SizedBox(height: 15),

                                // 복수 선택 허용 체크박스
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isMultiplied,
                                      onChanged: (value) {
                                        bottomState(() {
                                          isMultiplied = value!;
                                        });
                                      },
                                    ),
                                    const Text(
                                      '복수 선택 허용',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                const Text(
                                  '종료일 설정',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.calendar_month,
                                      ),
                                    ),
                                    const Text(
                                      '지정한 종료 날짜',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDBE7FB),
                                      surfaceTintColor: const Color(0xFF2B72E7)
                                          .withOpacity(0.25),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      minimumSize: const Size(94, 38),
                                    ),
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6E747E),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),

            // 경계선
            Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(
                color: Color(0xFFC5C5C7),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          // 작성이 되면 버튼 색상 변경
          backgroundColor: isButtonEnabled
              ? const Color(0xFF2B72E7)
              : const Color(0xFFFAFAFE),
          minimumSize: const Size(double.infinity, 75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Text(
          '작성 완료',
          style: TextStyle(
            color:
                isButtonEnabled ? Colors.white : Colors.black.withOpacity(0.5),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 미리보기 함수
  void showPreview(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  titleController.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '02/03  14:28',
                  style: TextStyle(
                    color: Color(0xFFA89F9F),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  contentController.text,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 15),
                if (pickedImage != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        pickedImage!,
                        height: 240,
                      ),
                    ),
                  ),
              ],
            ),
          ));
        });
  }

  // 필독 & 투표 버튼 생성 함수
  readVoteBtn({
    required String title,
    required String imgPath,
    required state,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(
                0xFF6E747E,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  state ? const Color(0xFFDBE7FB) : const Color(0xFFC5C5C7),
              minimumSize: const Size(55, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Image.asset(imgPath),
          ),
        ],
      ),
    );
  }

  // 카메라 & 파일 버튼 생성 함수
  camFileBtn({
    required VoidCallback onTap,
    required double rightWidth,
    required IconData icon,
    required String title,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2, // 화면 절반
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: rightWidth,
              color: const Color(0xFFC5C5C7),
            ),
            bottom: const BorderSide(
              width: 1,
              color: Color(0xFFC5C5C7),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: const Color(0xFF2A72E7),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFC5C5C7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 토글 버튼 생성 함수
  toggleButtons({
    required String title,
    required List<bool> isSelected,
    required bool categoryBtn,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(
                0xFF6E747E,
              ),
            ),
          ),
          ToggleButtons(
            selectedColor: Colors.black, // 선택된 글자색
            fillColor: const Color(0xFFDBE7FB), // 선택된 배경색
            isSelected: isSelected,
            onPressed: (index) {
              setState(() {
                for (int buttonIndex = 0;
                    categoryBtn
                        ? buttonIndex < isCategory.length
                        : buttonIndex < isGrade.length;
                    buttonIndex++) {
                  // 예를 들어 현재 butonIndex값이 내가 누르는 버튼 index값과 일치하다면 선택
                  if (buttonIndex == index) {
                    categoryBtn
                        ? isCategory[buttonIndex] = true
                        : isGrade[buttonIndex] = true;
                  } else {
                    categoryBtn
                        ? isCategory[buttonIndex] = false
                        : isGrade[buttonIndex] = false;
                  }
                }
              });
            },
            borderRadius: BorderRadius.circular(10.0),
            constraints: const BoxConstraints(
              minWidth: 55,
              minHeight: 30,
            ),

            // categoryBtn이 true 혹은 false일 경우 어떤 버튼이 생성되는지
            children: categoryBtn
                ? <Widget>[
                    const Text('전체'),
                    const Text('학년'),
                    const Text('경진'),
                    const Text('기업'),
                  ]
                : const <Widget>[
                    Text('전체'),
                    Text('1학년'),
                    Text('2학년'),
                    Text('3학년'),
                    Text('4학년'),
                  ],
          ),
        ],
      ),
    );
  }
}
