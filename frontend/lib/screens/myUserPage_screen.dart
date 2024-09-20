import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/screens/favorite_screen.dart';
import 'package:frontend/screens/userInfo_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:frontend/widgets/account_widget.dart';
import 'package:frontend/widgets/field_list.dart';
import 'package:frontend/widgets/profile_widget.dart';
import 'package:frontend/widgets/tool_list.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/teamApply_provider.dart';

class MyUserPage extends StatefulWidget {
  const MyUserPage({super.key});

  @override
  State<MyUserPage> createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage> {
  bool isExpanded = false; // 내 팀 현황 확장성 여부를 나타내는 변수
  String? studentId = ''; // 학번을 저장할 변수, 기본 값을 빈 문자열로 설정
  String? name = ''; // 이름을 저장할 변수, 기본 값을 빈 문자열로 설정
  String? status = ''; // 상태를 저장할 변수, 기본 값을 빈 문자열로 설정

  List<String> stringToListFieldList = [];
  List<Map<String, dynamic>> developmentField = [];

  List<String> stringToListToolList = [];
  List<Map<String, dynamic>> developmentTool = [];

  @override
  void initState() {
    super.initState();
    getField(); // 초기화 작업을 통해 들어오면 바로 배지가 보이기 위해 작성
    getTool();
    _loadCredentials(); // 학번을 로드하는 메서드 호출
    _fetchProfileData(); // 프로필 데이터를 불러오는 메서드 호출
  }

  // 학번, 이름, 재적상태를 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      studentId = credentials['studentId'] ?? ''; // 학번 설정, 없으면 빈 문자열로 설정
      name = credentials['name'] ?? ''; // 이름 설정, 없으면 빈 문자열로 설정
      status = credentials['status'] ?? ''; // 상태 설정, 없으면 빈 문자열로 설정
    });
  }

  Future<void> _fetchProfileData() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.fetchProfile(profileProvider.memberId);

    final teamApplyProvider =
        Provider.of<TeamApplyProvider>(context, listen: false);
    await teamApplyProvider.fetchTeamsFromProfile(profileProvider);
  }

  // 문자열을 리스트로 변환하는 메소드
  void stringToListField() {
    final techStack =
        Provider.of<ProfileProvider>(context, listen: false).techStack;
    String strField = techStack['developmentField'];

    setState(() {
      // 콤마(,)를 기준으로 끊어서 리스트 생성
      stringToListFieldList = strField.split(',');
    });
  }

  // 선택한 field의 배지를 가져오는 메서드
  void getField() {
    stringToListField();

    setState(() {
      // fieldList의 title에 생성한 stringToListFieldList이 있다면 출력해서 리스트로 생성
      developmentField = fieldList.where((field) {
        return stringToListFieldList.contains(field['title']);
      }).toList();

      print('developmentField: $developmentField');
    });
  }

  // 문자열을 리스트로 변환하는 메소드
  void stringToListTool() {
    final techStack =
        Provider.of<ProfileProvider>(context, listen: false).techStack;
    String strTool = techStack['developmentTool'];

    setState(() {
      // 콤마(,)를 기준으로 끊어서 리스트 생성
      stringToListToolList = strTool.split(',');
    });
  }

  // 선택한 field의 배지를 가져오는 메서드
  void getTool() {
    stringToListTool();

    setState(() {
      // fieldList의 title에 생성한 stringToListFieldList이 있다면 출력해서 리스트로 생성
      developmentTool = toolsList.where((tool) {
        return stringToListToolList.contains(tool['title']);
      }).toList();

      print('developmentTool: $developmentTool');
    });
  }

  @override
  Widget build(BuildContext context) {
    final techStack =
        Provider.of<ProfileProvider>(context, listen: false).techStack;
    final teamApplyProvider = Provider.of<TeamApplyProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류 방지
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/homepage', (route) => false); // 홈 페이지로 이동
            },
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
                  builder: (context) => const FavoritePage(), // 즐겨찾기 페이지로 이동
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                      profile: techStack,
                    ),
                  ),
                );
              },
              child: Profile(
                profileUrl: 'assets/images/profile.png',
                name: '${techStack['memberName']}', // 이름 전달
                status: status ?? '', // 상태 전달
                showSubTitle: true,
                showExperienceButton: true, // 내 경험 보러가기 버튼 표시 여부
                studentId: studentId ?? '', // 학번 전달
              ),
            ),
            const SizedBox(height: 25),

            // 사용자가 설정한 기술 스택 및 팀
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    children: developmentField.map((field) {
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
                    children: developmentTool.map((tools) {
                      return badge(
                        tools['logoUrl'],
                        tools['title'],
                        tools['titleColor'],
                        tools['badgeColor'],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 26),

                  // 생성된 팀
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
                  if (isExpanded)
                    (teamApplyProvider.teams['teamList'] == null ||
                            teamApplyProvider.teams['teamList'].isEmpty)
                        ? const Text('생성된 팀이 없습니다.')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                teamApplyProvider.teams['teamList'].length,
                            itemBuilder: (context, index) {
                              final team =
                                  teamApplyProvider.teams['teamList'][index];
                              final teamMembers =
                                  team['teamMember'] as List<dynamic>;

                              // data의 memberName과 teamMember의 memberName을 비교하여 memberRole을 찾기
                              final memberRole = teamMembers.firstWhere(
                                (member) =>
                                    member['memberName'] ==
                                    techStack['memberName'],
                                orElse: () => {'memberRole': 'Member'},
                              )['memberRole'];

                              return Card(
                                color: const Color(0xFFECECEC),
                                elevation: 1.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: ListTile(
                                    title: Text(
                                      team['teamName'] ?? '팀 이름 없음',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          team['teamCategory'] ?? '카테고리 없음',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF808080),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFEA4E44),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            minimumSize: const Size(33, 20),
                                          ),
                                          child: Text(
                                            memberRole == 'LEADER'
                                                ? 'Leader'
                                                : 'Member',
                                            style: const TextStyle(
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
                            },
                          ),
                  // 계정(비밀번호 변경, 로그아웃) 위젯
                  const AccountWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 배지 위젯 생성
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
