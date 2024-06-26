import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/screens/favorite_screen.dart';
import 'package:frontend/widgets/account_widget.dart';
import 'package:frontend/widgets/profile_widget.dart';

class MyUserPage extends StatefulWidget {
  const MyUserPage({super.key});

  @override
  State<MyUserPage> createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage> {
  bool isExpanded = false; // 내 팀 현황 확장성

  List<Map<String, dynamic>> fieldList = [
    {
      'logoUrl': 'assets/skilImages/typescript.png',
      'title': 'TYPESCRIPT',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF037BCB),
    },
    {
      'logoUrl': 'assets/skilImages/javascript.png',
      'title': 'JAVASCRIPT',
      'titleColor': Colors.black,
      'badgeColor': const Color(0xFFF5DF1D),
    },
    {
      'logoUrl': 'assets/skilImages/tailwindcss.png',
      'title': 'TAILWINDCSS',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF3DB1AB),
    },
    {
      'logoUrl': 'assets/skilImages/html.png',
      'title': 'HTML5',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFFE35026),
    },
    {
      'logoUrl': 'assets/skilImages/css.png',
      'title': 'CSS3',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF1472B6),
    },
    {
      'logoUrl': 'assets/skilImages/react.png',
      'title': 'REACT',
      'titleColor': Colors.black,
      'badgeColor': const Color(0xFF61DAFB),
    },
    {
      'logoUrl': 'assets/skilImages/npm.png',
      'title': 'NPM',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFFCB3837),
    },
    {
      'logoUrl': 'assets/skilImages/vscode.png',
      'title': 'VISUAL STUDIO CODE',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF0078D7),
    },
    {
      'logoUrl': 'assets/skilImages/docker.png',
      'title': 'DOCKER',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF0BB7ED),
    },
    {
      'logoUrl': 'assets/skilImages/yarn.png',
      'title': 'YARN',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF2C8EBB),
    },
    {
      'logoUrl': 'assets/skilImages/prettier.png',
      'title': 'PRETTIER',
      'titleColor': Colors.black,
      'badgeColor': const Color(0xFFF8B83E),
    },
    {
      'logoUrl': 'assets/skilImages/eslint.png',
      'title': 'ESLINT',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF4B3263),
    },
    {
      'logoUrl': 'assets/skilImages/figma.png',
      'title': 'FIGMA',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFFF24D1D),
    },
  ];

  List<Map<String, dynamic>> toolsList = [
    {
      'logoUrl': 'assets/skilImages/github.png',
      'title': 'GITHUB',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF111011),
    },
    {
      'logoUrl': 'assets/skilImages/notion.png',
      'title': 'NOTION',
      'titleColor': Colors.white,
      'badgeColor': Colors.black,
    },
    {
      'logoUrl': 'assets/skilImages/slack.png',
      'title': 'SLACK',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF4A144C),
    },
    {
      'logoUrl': 'assets/skilImages/zoom.png',
      'title': 'ZOOM',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF2D8CFF),
    },
    {
      'logoUrl': 'assets/skilImages/discord.png',
      'title': 'DISCORD',
      'titleColor': Colors.white,
      'badgeColor': const Color(0xFF5765F2),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        leadingWidth: 120,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritePage(),
                ),
              );
            },
            padding: const EdgeInsets.only(right: 10.0),
            icon: const Icon(
              Icons.favorite_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          const Padding(
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필
              const Profile(
                profileUrl: 'assets/images/profile.png',
                name: '민택기',
                showSubTitle: true,
              ),

              const SizedBox(height: 25),
              const Text(
                'DEVELOPMENT FIELD',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Development Field 배지
              // Wrap : 자식 위젯을 하나씩 순차적으로 채워가면서 너비를 초과하면 자동으로 다음 줄에 이어서 위젯을 채워주는 위젯
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                // children 속성에 직접 전달하여 Iterable<Widget> 반환 문제 해결
                children: fieldList.map((field) {
                  // 괄호 안에 있는 변수는 리스트를 map한 이름
                  return badge(
                    field['logoUrl'],
                    field['title'],
                    field['titleColor'],
                    field['badgeColor'],
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),
              const Text(
                'DEVELOPMENT TOOLS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Development Tools 배지
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,

                // children 속성에 직접 전달하여 Iterable<Widget> 반환 문제 해결
                children: toolsList.map((tools) {
                  return badge(
                    tools['logoUrl'],
                    tools['title'],
                    tools['titleColor'],
                    tools['badgeColor'],
                  );
                }).toList(),
              ),
              const SizedBox(height: 26),

              // 내 팀 현황
              Row(
                children: [
                  const Text(
                    '내 팀 현황',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                  ),
                ],
              ),

              // 확장할 시 내 팀 현황 박스 보여주기
              if (isExpanded == true) showMyTeam(),
              const SizedBox(height: 20),

              // 계정(비밀번호 변경, 로그아웃) 위젯
              const AccountWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // 내 팀 현황 박스
  Card showMyTeam() {
    return Card(
      color: const Color(0xFFECECEC),
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListTile(
          title: const Text(
            'IoT 박사',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              const Text(
                'IOT 경진대회',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA4E44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: const Size(33, 20),
                ),
                child: const Text(
                  '팀원',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget badge(
    String logoUrl,
    String title,
    Color titleColor,
    Color badgeColor,
  ) {
    return badges.Badge(
      // IntrinsicWidth : 자식 요소에 맞게 자동으로 너비 조절하는 위젯
      badgeContent: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              logoUrl,
              width: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: badgeColor,
        shape: badges.BadgeShape.square,
      ),
    );
  }
}
