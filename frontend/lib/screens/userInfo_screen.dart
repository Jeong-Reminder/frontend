import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  const UserInfoPage({required this.profile, super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

enum PopUpItem { popUpItem1 }

class _UserInfoPageState extends State<UserInfoPage> {
  bool isEdited = false;
  List<Map<String, dynamic>> selectedFields = []; // 선택된 Field 리스트

  int? memberId;

  String developmentField = ''; // 수정할 때 값이 변경될 때 저장할려고 선언
  String developmentTool = '';
  String hopeJob = '';
  String githubLink = '';

  late TextEditingController hopeJobController;
  late TextEditingController githubLinkController;

  @override
  void initState() {
    super.initState();

    // 저장된 값을 처음에 받기 위해 초기화로 지정
    developmentField = widget.profile['developmentField'] ?? '없음';
    developmentTool = widget.profile['developmentTool'] ?? '없음';
    hopeJob = widget.profile['hopeJob'] ?? '';
    githubLink = widget.profile['githubLink'] ?? '';
    memberId = widget.profile['memberId'];

    // 컨트롤러 초기화
    hopeJobController = TextEditingController(text: hopeJob);
    githubLinkController = TextEditingController(text: githubLink);
  }

  @override
  void dispose() {
    hopeJobController.dispose();
    githubLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: BackButton(
          onPressed: () async {
            await Provider.of<ProfileProvider>(context, listen: false)
                .fetchProfile(memberId!);

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/myuser', (route) => false);
            }
          },
        ),
        actions: [
          // 팝업 메뉴 창
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<PopUpItem>(
              color: const Color(0xFFEFF0F2),
              itemBuilder: (BuildContext context) {
                return [
                  popUpItem('수정하기', PopUpItem.popUpItem1, () {
                    setState(() {
                      isEdited = !isEdited;
                    });
                  }),
                ];
              },
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.profile['memberName']}님의 프로필',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // userInfo('이름', '${widget.profile['memberName']}'),
              // userInfo('학년', '${widget.profile['memberLevel']}'),
              userInfo('희망분야', hopeJob, hopeJobController),
              userInfo('깃허브 링크', githubLink, githubLinkController),
              developmentInfo(
                context,
                'Development Field',
                developmentField,
                '/edit-field',
              ),
              developmentInfo(
                context,
                'Development Tool',
                developmentTool,
                '/edit-tool',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isEdited
          ? ElevatedButton(
              onPressed: () async {
                setState(() {
                  isEdited = false;
                });

                final profile = Profile(
                  hopeJob: hopeJob,
                  githubLink: githubLink,
                  developmentField: developmentField,
                  developmentTool: developmentTool,
                );

                print('수정된 profile; $profile');

                await ProfileService()
                    .updateProfile(profile); // provider에서 할 작업이 없어서 service로 호출
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDBE7FB),
                foregroundColor: const Color(0xFF000000).withOpacity(0.5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  // 회원 정보 위젯
  Widget userInfo(String title, String info, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          readOnly: !isEdited,
          style: TextStyle(
            color: isEdited ? Colors.black : Colors.grey,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              if (title == '희망분야') {
                hopeJob = value;
              } else if (title == '깃허브 링크') {
                githubLink = value;
              }
            });
          },
        ),
      ],
    );
  }

  // 회원 정보 위젯
  Widget developmentInfo(
      BuildContext context, String title, String info, String path) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 15),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF808080),
              ),
            ),
            const SizedBox(width: 5),
            if (isEdited)
              IconButton(
                onPressed: () async {
                  // 전달받은 데이터값을 result에 저장해 developmentField에 저장
                  final result = await Navigator.pushNamed(context, path);

                  if (result != null && result is String) {
                    setState(() {
                      if (path == '/edit-field') {
                        developmentField = result;
                      } else if (path == '/edit-tool') {
                        developmentTool = result;
                      }
                    });
                  }
                },
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(info),
        const SizedBox(height: 10),
      ],
    );
  }
}

PopupMenuItem<PopUpItem> popUpItem(
    String text, PopUpItem item, Function() onTap) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출 가능
    onTap: onTap,
    value: item,
    height: 25,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF787879),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
