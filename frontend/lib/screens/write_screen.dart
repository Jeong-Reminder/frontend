import 'dart:io'; // 파일을 다루기 위해 필요
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/models/board_model.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/contestBoard_screen.dart';
import 'package:frontend/screens/corSeaBoard_screen.dart';
import 'package:frontend/screens/gradeBoard_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/totalBoard_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:lottie/lottie.dart';

class BoardWritePage extends StatefulWidget {
  final String category;
  const BoardWritePage({required this.category, super.key});

  @override
  State<BoardWritePage> createState() => _BoardWritePageState();
}

class _BoardWritePageState extends State<BoardWritePage> {
  TextEditingController titleController = TextEditingController(); // 게시글 제목
  TextEditingController contentController = TextEditingController(); // 게시글 내용
  TextEditingController voteTitleController = TextEditingController(); // 투표 제목

  final FocusNode titleFocusNode = FocusNode(); // 포커스 노드

  bool isButtonEnabled = false; // 작성 완료 버튼 상태
  bool isMustRead = false;
  bool isConfirmedVote = false; // 투표 설정 여부

  bool categoryBtn = true; // 공지 혹은 학년 버튼 여부
  List<bool> isCategory = [false, false, false, false]; // 공지 선택 불리안
  List<bool> isGrade = [false, false, false, false, false]; // 학년 선택 불리안

  final List<File> pickedImages = [];
  final List<File> pickedFiles = [];

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

  // 이미지 삭제 함수
  void _deleteImage(int index) {
    setState(() {
      pickedImages.removeAt(index);
    });
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

  // 파일 삭제 함수
  void _deleteFile(int index) {
    setState(() {
      pickedFiles.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 버튼과 키보드가 겹쳐도 오류가 안나게 하기
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            },
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        actions: [
          // 프로필 아이콘
          Padding(
            padding: const EdgeInsets.only(right: 23.0),
            child: IconButton(
              onPressed: () async {
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyOwnerPage(),
                    ),
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
                  contentPadding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
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

            // 선택된 사진들
            if (pickedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: pickedImages.asMap().entries.map((entry) {
                    int index = entry.key;
                    File pickedImage = entry.value;
                    return Row(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(
                              File(pickedImage.path),
                              height: 80,
                              alignment: Alignment.centerLeft,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_outlined,
                                  color: Colors.black),
                              onPressed: () => _deleteImage(index),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),

            // 선택된 파일
            if (pickedFiles.isNotEmpty)
              GestureDetector(
                onTap: () {
                  print('$pickedFiles');
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pickedFiles.asMap().entries.map((entry) {
                      int index = entry.key;
                      File pickedFile = entry.value;
                      return Row(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.file_present),
                                  const SizedBox(width: 5),
                                  Text(path.basename(pickedFile.path)),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close_outlined,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      _deleteFile(index);
                                    },
                                  ),
                                ],
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
            const SizedBox(height: 5.0),

            // 투표 버튼
            readVoteBtn(
              title: '투표',
              imgPath: 'assets/images/vote.png',
              state: isConfirmedVote,
              onPressed: () {
                _showVoteSheet(context);
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
        onPressed: () async {
          try {
            // 로딩 다이얼로그 표시
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: Lottie.asset(
                    'assets/loading/Animation - 1730082233943.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                );
              },
            );

            // // 게시글 작성 API
            final board = Board(
              announcementCategory: getSelectedCategoryText(),
              announcementTitle: titleController.text,
              announcementContent: contentController.text,
              announcementImportant: isMustRead,
              visible: true,
              announcementLevel: getSelectedGradeInt(),
            );

            final boardId = await AnnouncementProvider()
                .createBoard(board, pickedImages, pickedFiles);

            print('boardId: $boardId');

            if (isConfirmedVote) {
              // 투표 생성 API
              final vote = Vote(
                subjectTitle: voteTitleController.text,
                repetition: isMultiplied,
                additional: true,
                announcementId: boardId,
                endDateTime: formatDateTime(selectedEndDate!),
                // voteItemIds: [],
              );

              await VoteProvider().createVote(vote, boardId);
            }

            // 다이얼로그 닫기
            Navigator.pop(context);

            if (context.mounted) {
              if (widget.category == 'TOTAL') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TotalBoardPage(), // 페이지로 직접 이동
                  ),
                  (route) => false, // 이전 모든 라우트를 제거
                );
              } else if (widget.category == 'ACADEMIC_ALL') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GradeBoardPage(), // 페이지로 직접 이동
                  ),
                  (route) => false, // 이전 모든 라우트를 제거
                );
              } else if (widget.category == 'CONTEST') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ContestBoardPage(), // 페이지로 직접 이동
                  ),
                  (route) => false, // 이전 모든 라우트를 제거
                );
              } else if (widget.category == 'CORSEA') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CorSeaBoardPage(), // 페이지로 직접 이동
                  ),
                  (route) => false, // 이전 모든 라우트를 제거
                );
              }
            }
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

  // 투표 바텀시트
  // 그 값을 이전 화면에서 받아서 상태를 업데이트해서 다이얼로그가 닫힐 때 isConfirmedVote 값을 반환
  Future<void> _showVoteSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22.0, vertical: 40.0),

                // 모달 내부 영역
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.how_to_vote),
                        SizedBox(width: 10),
                        Text(
                          '투표 제목',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '투표 제목과 종료 날짜는 무조건 설정해주세요',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 제목 입력 필드
                    TextFormField(
                      controller: voteTitleController,
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
                      onSaved: (val) {
                        voteTitleController.text = val!;
                      },
                    ),
                    const SizedBox(height: 19),
                    const Divider(),
                    const SizedBox(height: 10),

                    // 설정 제목
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 5),
                        Text(
                          ' 설정',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 복수 선택 허용 체크박스
                    Row(
                      children: [
                        Checkbox(
                          value: isMultiplied,
                          onChanged: (value) {
                            setState(() {
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
                    const SizedBox(height: 5),

                    // 종료일 설정
                    Row(
                      children: [
                        // 달력 아이콘
                        IconButton(
                          onPressed: () {
                            picker.DatePicker.showDateTimePicker(
                              context,
                              currentTime: DateTime.now(),
                              locale: picker.LocaleType.ko, // 한국어 버전
                              onConfirm: (date) {
                                setState(() {
                                  selectedEndDate = date;
                                });
                              },
                              theme: const picker.DatePickerTheme(
                                itemStyle: TextStyle(
                                  color: Colors.black, // 텍스트 색상을 검은색으로 설정
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),

                        // 지정한 종료 날짜
                        Text(
                          selectedEndDate != null
                              ? selectedEndDate.toString().split('.')[0]
                              : '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 확인 버튼
                    Center(
                      child: ElevatedButton(
                        onPressed: (voteTitleController.text.isEmpty ||
                                selectedEndDate == null)
                            ? () {}
                            : () {
                                setState(() {
                                  isConfirmedVote = true;
                                });

                                Navigator.pop(context, isConfirmedVote);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDBE7FB),
                          surfaceTintColor:
                              const Color(0xFF2B72E7).withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
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

    if (result == true) {
      setState(() {
        isConfirmedVote = true;
      });
    }
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
              print('isCategory: $isCategory');
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
      'SEASONAL_SYSTEM', // 계절
      'ACADEMIC_ALL', // 학년
      'CONTEST', // 경진
      'CORPORATE_TOUR', // 기업
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
