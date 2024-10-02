import 'dart:convert';
import 'dart:typed_data'; // Uint8List를 사용하기 위해 필요
import 'dart:io'; // 파일을 다루기 위해 필요
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/board_model.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BoardUpdatePage extends StatefulWidget {
  Map<String, dynamic> board;
  BoardUpdatePage({required this.board, super.key});

  @override
  State<BoardUpdatePage> createState() => _BoardUpdatePageState();
}

class _BoardUpdatePageState extends State<BoardUpdatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode(); // 포커스 노드

  bool isButtonEnabled = false; // 작성 완료 버튼 상태
  bool isMustRead = false;
  bool isConfirmedVote = false;

  bool categoryBtn = true; // 공지 혹은 학년 버튼 여부
  List<bool> isCategory = [false, false, false, false]; // 공지 선택 불리안
  List<bool> isGrade = [false, false, false, false, false]; // 학년 선택 불리안

  List<File> pickedImages = [];
  List<File> pickedFiles = [];

  bool isPickingImage = false; // 이미지 선택 작업 진행 여부
  bool isMultiplied = false;

  DateTime? selectedEndDate; // 종료 날짜

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
    titleFocusNode.addListener(_handleTitleFocus);

    initializedBoard();
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
    titleFocusNode.removeListener(_handleTitleFocus);
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
  Future<void> _pickImages() async {
    if (isPickingImage) return; // 이미지 선택 작업이 이미 진행 중이면 중단

    setState(() {
      isPickingImage = true;
    });

    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedImage != null) {
          pickedImages.add(File(pickedImage.path));
        }
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isPickingImage = false;
      });
    }
  }

  // 파일 선택 함수
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // 모든 파일을 선택 가능하게 설정
      allowMultiple: true, // 여러 개의 파일을 선택할 수 있도록 설정
    );

    if (result != null) {
      setState(() {
        pickedFiles.addAll(result.paths
            .map((path) => File(path!))
            .toList()); // 선택한 파일들을 pickedFiles에 저장
      });
      print('파일: $pickedFiles');
    }
  }

  // 이미지 삭제 함수
  void _deleteImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      setState(() {
        pickedImages.removeAt(index);
        print('pickedImages: $pickedImages');
      });
    }
  }

// 파일 삭제 함수
  void _deleteFile(int index) {
    if (index >= 0 && index < pickedFiles.length) {
      setState(() {
        pickedFiles.removeAt(index);
        print('pickedFiles: $pickedFiles');
      });
    }
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

  // 시간 포맷팅 함수
  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  // 제목 입력 필드가 포커스를 받을 때 대괄호([])를 자동으로 추가하는 함수
  void _handleTitleFocus() {
    // 제목 입력 필드가 포커스를 가지고 있고, 텍스트가 비어 있는지 확인
    if (titleFocusNode.hasFocus && titleController.text.isEmpty) {
      setState(() {
        // 텍스트 필드에 대괄호([])를 추가
        titleController.text = '[]';
        // 커서를 대괄호 안으로 이동
        titleController.selection = TextSelection.fromPosition(
          const TextPosition(offset: 1),
        );
      });
    }
  }

  // 알림 버튼 누를 시  FCM 토큰 발급 함수
  Future<String> _getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    // print('FCM 토큰: $token');

    return token!;
  }

  List<Uint8List> pickedImageUrls = [];

  void initializedBoard() async {
    setState(() {
      titleController.text = widget.board['announcementTitle']; // 제목 초기화
      contentController.text = widget.board['announcementContent']; // 내용 초기화
      isMustRead = widget.board['announcementImportant']; // 필독 초기화

      // 카테고리 초기화
      String category = widget.board['announcementCategory'];
      List<String> categories = [
        'SEASONAL_SYSTEM',
        'ACADEMIC_ALL',
        'CONTEST',
        'CORPORATE_TOUR',
      ];
      int categoryIndex = categories.indexOf(category);
      if (categoryIndex != -1) {
        isCategory[categoryIndex] = true;
      }

      // 학년 초기화
      int gradeLevel = widget.board['announcementLevel'];
      if (gradeLevel >= 0 && gradeLevel < isGrade.length) {
        isGrade[gradeLevel] = true;
      }
    });

    // 이미지 URL 초기화
    if (widget.board['images'] != null) {
      for (var image in widget.board['images']) {
        // Base64로 인코딩된 imageData를 디코딩
        Uint8List decodedBytes = base64Decode(image['imageData']);
        File file = await saveImageToFile(decodedBytes);
        setState(() {
          pickedImages.add(file);
        });
      }
    }

    // 파일 URL 초기화
    if (widget.board['files'] != null) {
      for (var f in widget.board['files']) {
        // Base64로 인코딩된 fileData를 디코딩
        File file =
            await saveFileFromBase64(f['fileData'], f['originalFilename']);
        setState(() {
          pickedFiles.add(file);
        });
      }
    }
  }

  // Uint8List를 파일로 저장하는 함수
  Future<File> saveImageToFile(Uint8List imageData) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File(
            '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.png')
        .create();
    file.writeAsBytesSync(imageData);
    return file;
  }

  // Base64 파일 데이터를 받아 파일로 저장하는 함수
  Future<File> saveFileFromBase64(String base64Data, String filename) async {
    Uint8List decodedBytes = base64Decode(base64Data);
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$filename').create();
    await file.writeAsBytes(decodedBytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 버튼과 키보드가 겹쳐도 오류가 안나게 하기
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // 프로필 아이콘
          Padding(
            padding: const EdgeInsets.only(right: 23.0),
            child: IconButton(
              onPressed: () async {
                if (context.mounted) {
                  Navigator.pushNamed(
                    context,
                    '/myowner',
                  );
                }
              },
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.black,
              ),
              visualDensity: VisualDensity.compact,
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
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: titleController,
                    focusNode: titleFocusNode,
                    decoration: InputDecoration(
                      hintText: '제목을 작성해주세요(경진대회 공지일 경우 []안에 대회명을 작성해주세요)',
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
                  hintText: '내용을 작성해주세요',
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
                // 이미지 버튼
                imgFileBtn(
                    onTap: _pickImages,
                    title: '이미지',
                    icon: Icons.image), // void 함수는 async 작성

                // 파일 버튼
                imgFileBtn(
                    onTap: _pickFiles,
                    title: '파일',
                    icon: Icons.file_present), // Future 함수는 이름만 작성
              ],
            ),
            const SizedBox(height: 20),

            // 선택된 이미지 혹은 저장된 이미지
            if (pickedImages.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: pickedImages.asMap().entries.map((entry) {
                      int index = entry.key;
                      File imageFile = entry.value;
                      return Row(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                imageFile,
                                height: 150,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Text('이미지를 불러올 수 없습니다.');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_outlined,
                                    color: Colors.black),
                                onPressed: () {
                                  _deleteImage(index);

                                  print(
                                      'Remaining Images: ${pickedImages.length}');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 선택된 파일 혹은 저장된 파일
            if (pickedFiles.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: pickedFiles.asMap().entries.map((entry) {
                      int index = entry.key;
                      File file = entry.value;
                      return Row(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.insert_drive_file,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      path.basename(file.path),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_outlined,
                                    color: Colors.black),
                                onPressed: () {
                                  _deleteFile(index);

                                  print(
                                      'Remaining Files: ${pickedFiles.length}');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // 설정
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                // 미리보기
                Padding(
                  padding: const EdgeInsets.only(right: 17.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showPreview(context);
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
            // const SizedBox(height: 5.0),

            // // 투표 버튼
            // readVoteBtn(
            //   title: '투표',
            //   imgPath: 'assets/images/vote.png',
            //   state: isConfirmedVote,
            //   onPressed: () {
            //     _showVoteSheet(context);
            //   },
            // ),
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
        onPressed: () async {
          try {
            // 게시글
            final board = Board(
              announcementCategory: getSelectedCategoryText(),
              announcementTitle: titleController.text,
              announcementContent: contentController.text,
              announcementImportant: isMustRead,
              visible: true,
              announcementLevel: getSelectedGradeInt(),
            );

            await Provider.of<AnnouncementProvider>(context, listen: false)
                .updateBoard(board, pickedImages, pickedFiles,
                    widget.board['id'], context);
          } catch (e) {
            print(e.toString());
          }
        },
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
          '수정 완료',
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
  void _showPreview(BuildContext context) {
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
                // const Text(
                //   '02/03  14:28',
                //   style: TextStyle(
                //     color: Color(0xFFA89F9F),
                //   ),
                // ),
                const SizedBox(height: 15),
                Text(
                  contentController.text,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 15),
                if (pickedImages.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Column(
                        children: pickedImages.map((pickedImage) {
                          return Image.file(
                            File(pickedImage.path),
                            height: 240,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ));
        });
  }

  // 카메라 & 파일 선택 바텀시트 함수
  void _showImageSource() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 카메라 버튼
              camGalBtn(
                  source: ImageSource.camera,
                  icon: Icons.camera_alt,
                  title: '카메라'),

              // 갤러리 버튼
              camGalBtn(
                  source: ImageSource.gallery, icon: Icons.photo, title: '갤러리'),
            ],
          ),
        );
      },
    );
  }

  // 카메라 & 이미지 버튼
  Widget camGalBtn({
    required ImageSource source,
    required IconData icon,
    required String title,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        _pickImages();
      },
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      label: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        fixedSize: Size(MediaQuery.of(context).size.width, 80),
      ),
    );
  }

  // 이미지 & 파일 버튼
  Widget imgFileBtn({
    required Future<void> Function() onTap,
    required String title,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () async {
        await onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2, // 화면 절반
        height: 50,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              width: 1,
              color: Color(0xFFC5C5C7),
            ),
            bottom: BorderSide(
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

  // 필독 & 투표 버튼 생성 함수
  Widget readVoteBtn({
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

  // 토글 버튼 생성 함수
  Widget toggleButtons({
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
                    const Text('계절'),
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

  String getSelectedCategoryText() {
    List<String> categories = [
      'SEASONAL_SYSTEM',
      'ACADEMIC_ALL',
      'CONTEST',
      'CORPORATE_TOUR',
    ];

    for (int i = 0; i < isCategory.length; i++) {
      if (isCategory[i]) {
        return categories[i];
      }
    }

    return '없음';
  }

  int getSelectedGradeInt() {
    List<int> grades = [0, 1, 2, 3, 4]; // 전체는 0

    for (int i = 0; i < isGrade.length; i++) {
      if (isGrade[i]) {
        return grades[i];
      }
    }

    return 5;
  }
}
