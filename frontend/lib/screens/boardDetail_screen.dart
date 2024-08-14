import 'package:flutter/material.dart';
import 'package:frontend/all/providers/announcement_provider.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:frontend/providers/recommend_provider.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/widgets/vote_widget.dart';
import 'package:frontend/services/login_services.dart';
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
  Map<String, dynamic> voteMap = {}; // 투표 조회 변수
  String userRole = '';
  bool isLiked = false;
  int likeCount = 0;

  // 회원정보를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 level를 가져와 저장
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.announcementId != null) {
      print('id: ${widget.announcementId}');

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchOneBoard(widget.announcementId!);
      });
    }
    _loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<AnnouncementProvider>(context).board;

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
                  Text(
                    board['announcementTitle'],
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
              Text(
                board['announcementContent'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  width: 341,
                  height: 296,
                  child: Image.asset(
                    'assets/images/classselect.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () async {
                  //     try {
                  //       bool suucess =
                  //           await RecommendProvider().recommend(board['id']);
                  //       if (suucess) {
                  //         setState(() {
                  //           isLiked = !isLiked;
                  //           likeCount += 1;
                  //         });
                  //       }
                  //     } catch (e) {
                  //       print(e.toString());
                  //     }
                  //   },
                  //   child: Icon(
                  //     isLiked ? Icons.favorite : Icons.favorite_border,
                  //     color: isLiked ? Colors.red : Colors.grey,
                  //     size: 20,
                  //   ),
                  // ),
                  // const SizedBox(width: 2),
                  // Text(
                  //   '$likeCount',
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),

              // 투표 보기
              if (board['votes'].isNotEmpty)
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
