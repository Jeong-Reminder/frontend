import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:frontend/all/providers/announcement_provider.dart';
import 'package:frontend/providers/recommend_provider.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/widgets/vote_widget.dart';
import 'package:frontend/services/login_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BoardDetailPage extends StatefulWidget {
  final int? announcementId;
  const BoardDetailPage({this.announcementId, super.key});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

PopupMenuItem<PopUpItem> popUpItem(String text, PopUpItem item) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출
    onTap: () {},
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

enum PopUpItem { popUpItem1, popUpItem2 } // 팝업 아이템

class _BoardDetailPageState extends State<BoardDetailPage> {
  Map<String, dynamic> board = {};
  String userRole = '';
  bool isLiked = false;
  int likeCount = 0;

  List<File> pickedImages = [];
  List<File> pickedFiles = [];

  // 회원정보를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 level를 가져와 저장
    });
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

  // 이미지와 파일 초기화 메서드
  Future<void> _initializeFilesAndImages(Map<String, dynamic> board) async {
    // 이미지 URL 초기화
    if (board['images'] != null) {
      for (var image in board['images']) {
        // Base64로 인코딩된 imageData를 디코딩
        Uint8List decodedBytes = base64Decode(image['imageData']);
        File file = await saveImageToFile(decodedBytes);
        setState(() {
          pickedImages.add(file);
        });
      }
    }

    // 파일 URL 초기화
    if (board['files'] != null) {
      for (var f in board['files']) {
        // Base64로 인코딩된 fileData를 디코딩
        File file =
            await saveFileFromBase64(f['fileData'], f['originalFilename']);
        setState(() {
          pickedFiles.add(file);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.announcementId != null) {
      print('id: ${widget.announcementId}');

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchOneBoard(widget.announcementId!);

        setState(() {
          board =
              Provider.of<AnnouncementProvider>(context, listen: false).board;
        });

        await _initializeFilesAndImages(board); // 파일 및 이미지 초기화
      });
    }

    _loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류 방지
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 120,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (userRole == 'ROLE_ADMIN')
                        ? const MyOwnerPage()
                        : const MyUserPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 학년 공지 상단바
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 게시글 제목
                  Text(
                    board['announcementTitle'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 팝업 메뉴 창
                  PopupMenuButton<PopUpItem>(
                    color: const Color(0xFFEFF0F2),
                    itemBuilder: (BuildContext context) {
                      return [
                        popUpItem('URL 공유', PopUpItem.popUpItem1),
                        if (userRole == 'ROLE_ADMIN') const PopupMenuDivider(),
                        if (userRole == 'ROLE_ADMIN')
                          popUpItem('수정', PopUpItem.popUpItem2),
                      ];
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 게시글 내용
              Text(
                board['announcementContent'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              // 게시글 이미지
              if (pickedImages.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pickedImages.asMap().entries.map((entry) {
                      File imageFile = entry.value;
                      return Row(
                        children: [
                          Center(
                            child: Image.file(
                              imageFile,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 채움
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Text('이미지를 불러올 수 없습니다.');
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 20),

              // 게시글 파일
              if (pickedFiles.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pickedFiles.asMap().entries.map((entry) {
                      File file = entry.value;
                      return GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.insert_drive_file,
                              size: 25,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              path.basename(file.path),
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 20),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     GestureDetector(
              //       onTap: () async {
              //         try {
              //           bool suucess =
              //               await RecommendProvider().recommend(board['id']);
              //           if (suucess) {
              //             setState(() {
              //               isLiked = !isLiked;
              //               likeCount += 1;
              //             });
              //           }
              //         } catch (e) {
              //           print(e.toString());
              //         }
              //       },
              //       child: Icon(
              //         isLiked ? Icons.favorite : Icons.favorite_border,
              //         color: isLiked ? Colors.red : Colors.grey,
              //         size: 20,
              //       ),
              //     ),
              //     const SizedBox(width: 2),
              //     Text(
              //       '$likeCount',
              //       style: const TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),

              // 투표 보기
              if (board['votes'] != null && (board['votes'] as List).isNotEmpty)
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('투표 보기'),
                    children: [
                      VoteWidget(
                        votes: (board['votes'] as List<dynamic>)
                            .map((vote) =>
                                Vote.fromJson(vote as Map<String, dynamic>))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),

              // 댓글 작성 제한 메세지
              const Center(
                child: Text(
                  '댓글을 작성할 수 없는 게시물입니다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFA89F9F),
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
