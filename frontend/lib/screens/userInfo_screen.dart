import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          const Icon(
            Icons.add_alert,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 20),
          // 팝업 메뉴 창
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<PopUpItem>(
              color: const Color(0xFFEFF0F2),
              itemBuilder: (BuildContext context) {
                return [
                  popUpItem('수정하기', PopUpItem.popUpItem1, () {
                    setState(() {
                      isEdited = true;
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
              const Text(
                '회원정보',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              userInfo('이름', '${widget.profile['memberName']}'),
              userInfo('학년', '${widget.profile['memberLevel']}'),
              userInfo('희망분야', '${widget.profile['hopeJob']}'),
              userInfo('깃허브 링크', '${widget.profile['githubLink']}'),
              if (isEdited)
                developmentInfo(
                  context,
                  'Development Field',
                  '${widget.profile['developmentField']}',
                  '/edit-field',
                ),
              if (isEdited)
                developmentInfo(
                  context,
                  'Development Tool',
                  '${widget.profile['developmentTool']}',
                  '/edit-tool',
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isEdited
          ? ElevatedButton(
              onPressed: () {
                setState(() {
                  isEdited = false;
                });
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
  Widget userInfo(String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 10),
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
          initialValue: info,
          readOnly: !isEdited,
          style: TextStyle(
            color: isEdited ? Colors.black : Colors.grey,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onSaved: (value) {
            info = value!;
          },
        ),
      ],
    );
  }
}

// 회원 정보 위젯
Widget developmentInfo(
    BuildContext context, String title, String info, String path) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(),
      const SizedBox(height: 10),
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
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, path);
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

PopupMenuItem<PopUpItem> popUpItem(
    String text, PopUpItem item, Function() onTap) {
  return PopupMenuItem<PopUpItem>(
    enabled: true, // 팝업메뉴 호출(ex: onTap()) 가능
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
