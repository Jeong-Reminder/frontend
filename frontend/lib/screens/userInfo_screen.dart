import 'package:flutter/material.dart';
import 'package:frontend/models/profile_model.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/screens/editField_screen.dart';
import 'package:frontend/screens/editTool_screen.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  const UserInfoPage({required this.profile, super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

enum PopUpItem { popUpItem1 }

class _UserInfoPageState extends State<UserInfoPage> {
  List<Map<String, dynamic>> selectedFields = []; // 선택된 Field 리스트

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
                .fetchProfile(widget.profile['memberId']);

            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyUserPage(),
                  ),
                  (route) => false);
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
                    editProfileDialog(context);
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
                '${widget.profile['memberName']} 프로필',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // initState에서 초기화하지 않고 그냥 바로 지정
              userInfo('희망분야', widget.profile['hopeJob'], false),
              userInfo('깃허브 링크', widget.profile['githubLink'], true),
              userInfo('Development Field', widget.profile['developmentField'],
                  false),
              userInfo(
                  'Development Tool', widget.profile['developmentTool'], false),
            ],
          ),
        ),
      ),
    );
  }

  // 프로필 수정 모달창
  void editProfileDialog(BuildContext context) async {
    // 취소하고 모달창에 수정한 값이 보이는 오류로 인해 모달창 메서드 내부에서 초기화 지정
    TextEditingController hopeJobController =
        TextEditingController(text: widget.profile['hopeJob']);
    TextEditingController githubLinkController =
        TextEditingController(text: widget.profile['githubLink']);
    TextEditingController fieldController =
        TextEditingController(text: widget.profile['developmentField']);
    TextEditingController toolController =
        TextEditingController(text: widget.profile['developmentTool']);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          backgroundColor: const Color(0xFFFFFFFF),
          title: const Text('프로필 수정하기'),
          content: SizedBox(
            width: screenWidth * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 수정 모달창에서는 컨트롤러로 보이게 작성
                  editTextField('희망분야', hopeJobController),
                  editTextField('깃허브 링크', githubLinkController),
                  editFieldTool(
                    'Development Field',
                    fieldController,
                    '/edit-field',
                  ),
                  editFieldTool(
                    'Development Tool',
                    toolController,
                    '/edit-tool',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF2A72E7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // 수정 요청 바디에는 controller.text로 전달(프로필 조회와 수정 페이지에서의 조회에서 어떻게 보여줄지 통일성을 갖기 위해)
                final profile = Profile(
                  hopeJob: hopeJobController.text,
                  githubLink: githubLinkController.text,
                  developmentField: fieldController.text,
                  developmentTool: toolController.text,
                );

                print('수정된 profile; $profile');

                await ProfileService()
                    .updateProfile(profile); // provider에서 할 작업이 없어서 service로 호출

                if (context.mounted) {
                  // 수정된 값 전달
                  Navigator.pop(context, {
                    'hopeJob': hopeJobController.text,
                    'githubLink': githubLinkController.text,
                    'developmentField': fieldController.text,
                    'developmentTool': toolController.text,
                  });
                }
              },
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Color(0xFF2A72E7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    // 다이얼로그에서 반환된 값으로 상태 업데이트
    if (result != null) {
      setState(() {
        widget.profile['hopeJob'] = result['hopeJob']!;
        widget.profile['githubLink'] = result['githubLink']!;
        widget.profile['developmentField'] = result['developmentField']!;
        widget.profile['developmentTool'] = result['developmentTool']!;
      });
    }
  }

  // 회원 정보 위젯
  Widget userInfo(String title, String info, bool isConnected) {
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
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            if (isConnected) {
              final Uri uri = Uri.parse(info); // Uri 객체로 URL 생성

              if (await canLaunchUrl(uri)) {
                await launchUrl(
                  uri,
                );
              } else {
                throw '$info를 찾을 수 없습니다.';
              }
            }
          },
          child: Text(
            info,
            style: TextStyle(
              fontSize: 14,
              color: isConnected ? Colors.blue : Colors.black,
              decoration: isConnected ? TextDecoration.underline : null,
              decorationColor: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // 수정할 텍스트필드 위젯
  Widget editTextField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black,
        ),
        cursorColor: const Color(0xFF2A72E7),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF2A72E7),
            ),
          ),
        ),
      ),
    );
  }

  // 수정할 개발 툴, 필드
  Widget editFieldTool(
      String title, TextEditingController controller, String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onTap: () async {
          // 전달받은 데이터값을 result에 저장해 developmentField에 저장
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (path == '/edit-field')
                  ? const EditFieldPage()
                  : const EditToolPage(),
            ),
          );

          if (result != null && result is String) {
            setState(() {
              if (path == '/edit-field') {
                controller.text = result;
              } else if (path == '/edit-tool') {
                controller.text = result;
              }
            });
          }
        },
        controller: controller,
        readOnly: true,
        style: const TextStyle(
          color: Colors.black,
        ),
        cursorColor: const Color(0xFF2A72E7),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// 팝업 메뉴
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
