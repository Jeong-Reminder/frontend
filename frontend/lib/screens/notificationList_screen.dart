import 'package:flutter/material.dart';
import 'package:frontend/models/notification_model.dart';
import 'package:frontend/providers/announcement_provider.dart';
import 'package:frontend/providers/notification_provider.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/notificationList_service.dart';
import 'package:frontend/services/notification_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

// 애니메이션 프레임당 한 번씩 콜백을 호출할 수 있게 해주는 Ticker 클래스
// SingleTickerProviderStateMixin: Ticker가 필요한 애니메이션이 한 개
class _NotificationListPageState extends State<NotificationListPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,

    // 탭 변경 시 애니메이션 시간
    animationDuration: const Duration(milliseconds: 800),
  );

  int cateIndex = 0; // TabBar 클릭 시 가져올 인덱스
  List<Map<String, dynamic>> allBoardList = []; // 알림 리스트

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotification();

      await Provider.of<AnnouncementProvider>(context, listen: false)
          .fetchAllBoards();

      setState(() {
        allBoardList =
            Provider.of<AnnouncementProvider>(context, listen: false).boardList;
      });
    });

    getNoticiationData();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<List<NotificationModel>> getNoticiationData() async {
    return Provider.of<NotificationProvider>(context, listen: false)
        .notificationList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false);
          },
        ),
        title: const Text('알림'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 공지 ⋅ 팀원모집 탭바
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: '공지'),
                Tab(text: '팀원모집'),
              ],
              labelColor: Colors.black, // 레이블 색상
              unselectedLabelColor: Colors.grey, // 선택되지 않은 레이블 색상
              overlayColor: MaterialStatePropertyAll(
                const Color(0xFF2A72E7).withOpacity(0.2), // 탭바 클릭 색상
              ),
              indicatorColor: const Color(0xFF2A72E7),
              indicatorWeight: 2.0,
              indicatorSize: TabBarIndicatorSize
                  .tab, // 탭의 가로 사이즈와 동일하게(label: 레이블 가로 사이즈와 동일하게)
              onTap: (index) {
                setState(() {
                  cateIndex = index;
                  print('cateIndex: $cateIndex');
                });
              },
            ),
            const SizedBox(height: 20),

            // 알림 공지
            FutureBuilder<List<NotificationModel>>(
              future: NotificationListService().fetchNotification(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('알림이 없습니다.'));
                } else {
                  // cateIndex와 read 상태에 따라 필터링된 알림 리스트에서
                  // 공지에서는 현재 게시된 게시글 아이디(b['id'])와 필터링된 알림 리스트 아이디(bd.targetId)가 동일하면 필터링
                  List<NotificationModel> filteredList = [];

                  if (cateIndex == 0) {
                    filteredList = snapshot.data!.where((notice) {
                      return notice.category == '공지' && !notice.read!;
                    }).where((bd) {
                      return allBoardList.any((b) => b['id'] == bd.targetId);
                    }).toList();
                  } else {
                    filteredList = snapshot.data!.where((notice) {
                      return notice.category == '팀원모집' && !notice.read!;
                    }).toList();
                  }

                  // 필터링된 리스트가 비어있으면 알림이 없다고 표시
                  if (filteredList.isEmpty) {
                    return const Center(child: Text('알림이 없습니다'));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      // ListView 자체의 스크롤을 막기 위한 코드
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        NotificationModel notice = filteredList[index];

                        return notificationTile(
                          cateIndex == 0
                              ? 'assets/images/notification.png'
                              : 'assets/images/recruit.png',
                          notice.title!, // 알림 제목
                          notice.content!, // 알림 내용
                          notice.createdAt!, // 알림 생성시간
                          notice.category!, // 알림 카테고리
                          notice.targetId!, // 알림 공지 혹은 모집글 아이디
                          notice.id!, // 알림 아이디
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 알림 공지 위젯
  Widget notificationTile(String imageUrl, String title, String content,
      String createdAt, String category, int targetId, String id) {
    return Column(
      children: [
        ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(imageUrl),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  text: TextSpan(
                    text: content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  // 생성 시간에서 T 이전만 추출
                  createdAt.substring(0, createdAt.indexOf('T')),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7D7D7F),
                  ),
                ),
              ],
            ),
            onTap: () async {
              await NotificationService().readNotification(id);

              if (category == '공지') {
                Get.toNamed(
                  '/detail-board',
                  arguments: {
                    'announcementId': targetId,
                    'category': 'NOTICE',
                  },
                  preventDuplicates: false,
                );
              } else {
                Get.toNamed(
                  '/detail-recruit',
                  arguments: {'makeTeamId': targetId},
                  preventDuplicates: false,
                );
              }
            }),
        const Divider(),
        const SizedBox(height: 15.0),
      ],
    );
  }
}
