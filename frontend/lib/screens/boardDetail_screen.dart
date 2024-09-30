import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/update_screen.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:path/path.dart' as path;
import 'package:frontend/screens/myOwnerPage_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/widgets/vote_widget.dart';
import 'package:frontend/services/login_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BoardDetailPage extends StatefulWidget {
  final int? announcementId;
  final String? category;
  const BoardDetailPage({this.announcementId, this.category, super.key});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

PopupMenuItem<PopUpItem> popUpItem(
    String text, PopUpItem item, Function() onTap) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출
    onTap: onTap,
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

enum PopUpItem { popUpItem1, popUpItem2, popUpItem3, popUpItem4 } // 팝업 아이템

class _BoardDetailPageState extends State<BoardDetailPage> {
  String userRole = '';

  bool isLiked = false;
  bool isDownloading = false;
  bool isLoading = true; // 로딩 상태

  int likeCount = 0;
  double downloadProgress = 0.0;

  Map<String, dynamic> board = {};

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
    // 게시글에 표시된 이미지와 파일을 모두 제거 후 다시 초기화 진행
    setState(() {
      pickedImages.clear();
      pickedFiles.clear();
    });

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
          isLoading = false; // 데이터를 받아오면 false로 변환
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
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류 방지
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            onPressed: () async {
              // 공지 카테고리에 맞는 Navigator 메서드
              pushNamedAndRemoveUntil();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 120,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 학년 공지 상단바
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 게시글 제목
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.clip,
                            maxLines: 5,
                            text: TextSpan(
                              text: board['announcementTitle'] ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // 팝업 메뉴 창
                        PopupMenuButton<PopUpItem>(
                          color: const Color(0xFFEFF0F2),
                          itemBuilder: (BuildContext context) {
                            return [
                              popUpItem('URL 공유', PopUpItem.popUpItem1, () {}),
                              if (userRole == 'ROLE_ADMIN')
                                const PopupMenuDivider(),
                              if (userRole == 'ROLE_ADMIN') ...[
                                popUpItem('수정', PopUpItem.popUpItem2, () async {
                                  // BoardUpdatePage에서 수정된 게시글 정보를 받아옴
                                  final updateBoard = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BoardUpdatePage(board: board),
                                    ),
                                  );
                                  // 만약 수정된 게시글 정보가 존재하면, 상태를 업데이트하여 즉시 반영
                                  if (updateBoard != null) {
                                    setState(() {
                                      board = updateBoard;
                                      print('수정된 게시글: $board');

                                      // 텍스트는 바로바로 띄울 수 있지만 이미지와 파일은 board['images']와 board['files']가 아닌 pickedImages와 pickedFiles로 화면에 보여주기 때문에
                                      // _initializeFilesAndImages 메서드를 불러서 pickedImages와 pickedFiles를 수정
                                      _initializeFilesAndImages(board);
                                    });
                                  }
                                }),
                                const PopupMenuDivider(),
                                popUpItem(
                                  '숨김',
                                  PopUpItem.popUpItem3,
                                  () async {
                                    await Provider.of<AnnouncementProvider>(
                                            context,
                                            listen: false)
                                        .hiddenBoard(board, board['id']);

                                    if (context.mounted) {
                                      pushNamedAndRemoveUntil();
                                      alertSnackBar(context, '숨김이 완료되었습니다');
                                    }
                                  },
                                ),
                                const PopupMenuDivider(),
                                popUpItem(
                                  '삭제',
                                  PopUpItem.popUpItem4,
                                  () async {
                                    print('id: ${board['id']}');
                                    await Provider.of<AnnouncementProvider>(
                                            context,
                                            listen: false)
                                        .deletedBoard(board['id']);

                                    if (context.mounted) {
                                      pushNamedAndRemoveUntil();
                                      alertSnackBar(context, '삭제가 완료되었습니다');
                                    }
                                  },
                                ),
                              ]
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
                                        Object exception,
                                        StackTrace? stackTrace) {
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

                            // 파일 이름을 이용해 board의 파일 정보를 찾기
                            final correspondingFile =
                                board['files']?.firstWhere(
                              (f) =>
                                  f['originalFilename'] ==
                                  path.basename(file.path),
                              orElse: () => null,
                            );

                            return GestureDetector(
                              onTap: () async {
                                if (correspondingFile != null) {
                                  final fileUrl = correspondingFile['fileUrl'];
                                  final fileName =
                                      correspondingFile['originalFilename'];

                                  print('fileUrl: $fileUrl');
                                  print('fileName: $fileName');
                                  final announcementProvider =
                                      Provider.of<AnnouncementProvider>(context,
                                          listen: false);

                                  await announcementProvider.downloadFile(
                                      fileUrl, fileName);
                                } else {
                                  print('해당 파일 정보를 찾을 수 없습니다.');
                                }
                              },
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
                    if (board['votes'] != null &&
                        (board['votes'] as List).isNotEmpty)
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: const Text('투표 보기'),
                          children: [
                            VoteWidget(
                              votes: (board['votes'] as List<dynamic>)
                                  .map((vote) => Vote.fromJson(
                                      vote as Map<String, dynamic>))
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

  // 공지 카테고리에 맞는 Navigator 메서드
  void pushNamedAndRemoveUntil() {
    if (widget.category == 'CORSEA') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/corSea-board', (route) => false);
    } else if (widget.category == 'ACADEMIC_ALL') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/grade-board', (route) => false);
    } else if (widget.category == 'CONTEST') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/contest-board', (route) => false);
    } else if (widget.category == 'TOTAL') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/total-board', (route) => false);
    } else if (widget.category == 'PROFILE') {
      Navigator.pushNamedAndRemoveUntil(context, '/myowner', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/homepage', (route) => false);
    }
  }
}

// 팝업 알림 위젯
void alertSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: const Duration(seconds: 3), //올라와있는 시간
    ),
  );
}
