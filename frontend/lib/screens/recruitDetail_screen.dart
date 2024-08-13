import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:frontend/models/teamApply_model.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/providers/teamApply_provider.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';

class RecruitDetailPage extends StatefulWidget {
  final MakeTeam makeTeam; // MakeTeam 객체를 전달받음

  const RecruitDetailPage({super.key, required this.makeTeam});

  @override
  State<RecruitDetailPage> createState() => _RecruitDetailPageState();
}

class _RecruitDetailPageState extends State<RecruitDetailPage> {
  // 모집 명단 확장 여부를 관리하는 변수
  bool isExpandedSection1 = false;
  final TextEditingController _controller = TextEditingController();
  String name = ''; // 로그인된 사용자의 이름을 저장할 변수
  String level = '';

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // 로그인 정보를 로드하는 메서드 호출
  }

  // 로그인 정보에서 이름과 학년을 로드하는 메서드
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      name = credentials['name'] ?? ''; // 로그인 정보에서 name을 가져와 저장
      level = credentials['level'].toString();
    });
  }

  // 새로운 댓글을 추가하는 함수
  void _addComment() async {
    if (_controller.text.isNotEmpty) {
      try {
        TeamApply teamApply = TeamApply(
          applicationContent: _controller.text,
        );

        await Provider.of<TeamApplyProvider>(context, listen: false)
            .createTeamApply(teamApply);

        setState(() {});

        _controller.clear();
      } catch (e) {
        print('팀원 신청글 작성 실패: $e');
      }
    }
  }

  // 기술 스택 리스트 (이 부분은 원래 코드에서 정의된 fieldList와 연결)
  List<Map<String, dynamic>> fieldList = [
    // 필드 리스트 항목들 그대로 유지
  ];

  @override
  Widget build(BuildContext context) {
    // MakeTeamProvider에서 applyList를 가져옴
    final applyList = Provider.of<MakeTeamProvider>(context).applyList;

    // 전달된 MakeTeam 객체 사용
    final makeTeam = widget.makeTeam;
    int currentMembers = makeTeam.studentCount;
    int maxMembers = 4;

    // endTime이 문자열 형식으로 저장된 리스트를 나타내는 경우
    List<String> endTimeParts =
        makeTeam.endTime.replaceAll(RegExp(r'\[|\]'), '').split(',');
    // createdTime이 문자열 형식으로 저장된 리스트를 나타내는 경우
    List<String>? createdTimeParts =
        makeTeam.createdTime?.replaceAll(RegExp(r'\[|\]'), '').split(',');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                makeTeam.recruitmentTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),

              Row(children: [
                GestureDetector(
                  onTap: () {
                    _showAuthorStackDialog(); // 글쓴 사람 기술 스택 다이얼로그 표시
                  },
                  child: Text(
                    makeTeam.memberName ?? 'Unknown',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(width: 4),
                if (createdTimeParts != null) ...[
                  Text(
                    '${createdTimeParts[0].trim()}/${createdTimeParts[1].trim()}/${createdTimeParts[2].trim()}',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ],
              ]),
              const SizedBox(height: 10),
              Text(
                makeTeam.recruitmentContent,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '모집 인원 ${makeTeam.studentCount}/4',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  // 월과 일을 추출하여 표시
                  Text(
                    '~${endTimeParts[1].trim()}/${endTimeParts[2].trim()}까지',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpandedSection1 = !isExpandedSection1;
                              });
                            },
                            child: Container(
                              height: 20,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  '명단',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpandedSection1 = !isExpandedSection1;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (currentMembers ==
                              maxMembers) // 모집 인원과 최대 인원이 같을 때
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A72E7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    '팀 생성하기',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isExpandedSection1) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      makeTeam.memberName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 20,
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA4E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '팀장',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 팀원 목록을 여기에 추가할 수 있습니다.
                  ],
                ),
              ],
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xFFC5C5C7),
                thickness: 1,
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '인원 수',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDBE7FB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        '${makeTeam.studentCount}명',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '희망 분야',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: makeTeam.hopeField.split(',').map((field) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 80, // 각 Container의 너비 조정
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE7FB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  field.trim(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Color(0xFFC5C5C7),
                thickness: 1,
                height: 30,
              ),
              const SizedBox(height: 10),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF848488)),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _addComment,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/send.png',
                          width: 16,
                          height: 16,
                          color: const Color(0xFF2A72E7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 댓글 리스트 빌드
              Expanded(
                child: ListView.builder(
                  itemCount: applyList.length,
                  itemBuilder: (context, index) {
                    final apply = applyList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showNameDialog(apply['developmentField'],
                                      apply['githubLink']);
                                },
                                child: Text(
                                  apply['memberName'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${apply['memberLevel']}학년',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF808080)),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  _showApproveDialog(index); // 승인 버튼 클릭 시 적용
                                },
                                child: Container(
                                  height: 20,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A72E7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '승인',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  _showRejectDialog(index); // 반려 버튼 클릭 시 적용
                                },
                                child: Container(
                                  height: 20,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '반려',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              // Text(
                              //   // comment.timestamp.split(' ')[0],
                              //   apply['createdTime'],
                              //   style: const TextStyle(
                              //     fontSize: 9,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.black54,
                              //   ),
                              // ),
                              SizedBox(width: 2),
                              // Text(
                              //   comment.timestamp.split(' ')[1],
                              //   style: const TextStyle(
                              //       fontSize: 9,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.black54),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            apply['applicationContent'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                            color: Color(0xFFC5C5C7),
                            thickness: 1,
                            height: 30,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (currentMembers == maxMembers) // 모집 인원과 최대 인원이 같을 때
                GestureDetector(
                  onTap: () {
                    // 팀 생성 로직 추가
                  },
                  child: Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A72E7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        '팀 생성하기',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 글쓴 사람의 기술 스택을 표시하는 다이얼로그를 보여주는 함수
  void _showAuthorStackDialog() async {
    // ProfileProvider를 사용하여 글쓴 사람의 프로필 정보를 가져옴
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await profileProvider.fetchProfile(widget.makeTeam.memberId!);

    // 가져온 프로필 정보에서 기술 스택 정보를 추출
    final techStack = profileProvider.techStack;

    final githubLink = techStack['githubLink'];

    // 개발 분야를 콤마(,)로 구분된 문자열로부터 리스트로 변환
    final developmentFields = (techStack['developmentField'] as String)
        .split(',')
        .map((field) => field.trim()) // 각 항목의 앞뒤 공백을 제거
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${widget.makeTeam.memberName}님의 기술 스택'),
          titleTextStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 개발 분야를 배지 형태로 표시하는 위젯
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: developmentFields.map((field) {
                    // 각 개발 분야에 대한 정보를 fieldList에서 찾음
                    final fieldData = fieldList.firstWhere(
                      (element) => element['title'] == field,
                    );
                    // 배지를 반환하여 화면에 표시
                    return badge(
                      fieldData['logoUrl'] ?? '',
                      fieldData['title'] ?? '',
                      fieldData['titleColor'] ?? Colors.black,
                      fieldData['badgeColor'] ?? Colors.grey,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                RichText(
                  text: TextSpan(
                    text: 'Github: ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: githubLink,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 승인 버튼 클릭 시 다이얼로그 표시
  void _showApproveDialog(int index) {
    final applyList =
        Provider.of<MakeTeamProvider>(context, listen: false).applyList;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${applyList[index]['memberName']} 승인')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Align(
                alignment: Alignment.center,
                child: Text('정말로 승인하시겠습니까?'),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/billiard.png',
                    width: 16,
                    height: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    '한 번 승인하면 되돌릴 수 없습니다',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      setState(() {
                        // 모집 인원이 최대 인원보다 적을 때만 승인
                        if (widget.makeTeam.studentCount < 4) {
                          widget.makeTeam.studentCount++;
                          applyList.removeAt(index);
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 거절 버튼 클릭 시 다이얼로그 표시
  void _showRejectDialog(int index) {
    final applyList =
        Provider.of<MakeTeamProvider>(context, listen: false).applyList;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${applyList[index]['memberName']} 반려')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Align(
                alignment: Alignment.center,
                child: Text('정말로 반려하시겠습니까?'),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/billiard.png',
                    width: 16,
                    height: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    '한 번 반려하면 되돌릴 수 없습니다',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () {
                      setState(() {
                        applyList.removeAt(index); // 반려 클릭 시 리스트에서 제거
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 댓글 단 사람 이름 클릭 시 다이얼로그 표시
  void _showNameDialog(String field, String githubUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(field),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: () {
                    // 경험 보러가기 버튼 클릭 시 다른 페이지로 이동
                  },
                  label: const Text(
                    '경험 보러가기',
                    style: TextStyle(color: Colors.black),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
              ),
            ],
          ),
          titleTextStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: fieldList.map((field) {
                    return badge(
                      field['logoUrl'] ?? '',
                      field['title'] ?? '',
                      field['titleColor'] ?? Colors.black,
                      field['badgeColor'] ?? Colors.grey,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Github: ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: githubUrl,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline, // 하이퍼링크 스타일
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget badge(
    // badge 스타일 적용
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
