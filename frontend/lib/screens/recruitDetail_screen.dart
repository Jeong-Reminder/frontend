import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/models/teamApply_model.dart';
import 'package:frontend/providers/makeTeam_provider.dart';
import 'package:frontend/providers/profile_provider.dart';
import 'package:frontend/services/login_services.dart';
import 'package:frontend/services/teamApply_service.dart';
import 'package:provider/provider.dart';

class RecruitDetailPage extends StatefulWidget {
  final Map<String, dynamic> makeTeam;

  const RecruitDetailPage({super.key, required this.makeTeam});

  @override
  State<RecruitDetailPage> createState() => _RecruitDetailPageState();
}

class _RecruitDetailPageState extends State<RecruitDetailPage> {
  bool isExpandedSection1 = false; // 팀원 명단 섹션이 확장되었는지 여부

  final TextEditingController _controller = TextEditingController();
  String name = '';
  String level = '';

  List<Map<String, dynamic>> applyList = []; // 팀원 신청 리스트를 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadCredentials();
    _fetchApplyList();
  }

  // 사용자의 자격 증명을 불러오는 함수
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI();
    final credentials = await loginAPI.loadCredentials();
    setState(() {
      name = credentials['name'] ?? ''; // 사용자의 이름
      level = credentials['level'].toString(); // 사용자의 학년
    });
  }

  // 팀원 신청 리스트를 불러오는 함수
  Future<void> _fetchApplyList() async {
    try {
      final provider = Provider.of<MakeTeamProvider>(context, listen: false);
      await provider.fetchMakeTeam();
      setState(() {
        applyList = provider.applyList; // 불러온 신청 리스트를 상태에 저장
      });
    } catch (e) {
      print('팀 신청 리스트를 불러오는 데 실패했습니다: $e');
    }
  }

  // 새로운 댓글을 추가하는 함수
  Future<void> _addComment() async {
    if (_controller.text.isNotEmpty) {
      try {
        TeamApply teamApply = TeamApply(
          applicationContent: _controller.text,
        );

        final teamApplyService = TeamApplyService();
        int applicationId = await teamApplyService.createTeamApply(teamApply);

        _controller.clear();
        await _fetchApplyList();
        print('팀원 신청글 작성 성공: $applicationId');
      } catch (e) {
        print('팀원 신청글 작성 실패: $e');
      }
    }
  }

  List<Map<String, dynamic>> fieldList = [];

  // 팝업 메뉴 항목을 생성하는 함수
  PopupMenuItem<String> popUpItem(String text, String item) {
    return PopupMenuItem<String>(
      enabled: true,
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

  // 신청글 내용을 업데이트하는 함수
  void _updateContent(int index, String newContent) async {
    try {
      final apply = applyList[index];
      final int applicationId = apply['id'];

      // 새로운 내용으로 신청글 객체를 업데이트
      TeamApply updatedApply = TeamApply(
        id: applicationId,
        applicationContent: newContent,
      );

      final teamApplyService = TeamApplyService();
      await teamApplyService.updateTeamApply(applicationId, updatedApply);

      // 상태를 업데이트하여 UI에 반영합니다.
      setState(() {
        applyList[index]['applicationContent'] = newContent;
      });

      print('신청글 수정 성공: $applicationId');
    } catch (e) {
      print('신청글 수정 실패: $e');
    }
  }

  // 신청글 삭제하는 함수
  void _deleteContent(int index) async {
    try {
      final apply = applyList[index];
      final int applicationId = apply['id'];

      final teamApplyService = TeamApplyService();
      await teamApplyService.deleteTeamApply(applicationId);

      setState(() {
        applyList.removeAt(index); // 로컬 리스트에서 해당 신청글을 제거
      });

      print('신청글 삭제 성공: $applicationId');
    } catch (e) {
      print('신청글 삭제 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final makeTeam = widget.makeTeam;
    int currentMembers = makeTeam['studentCount'];
    int maxMembers = 4;

    List<String> endTimeParts = (makeTeam['endTime'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    List<String>? createdTimeParts = (makeTeam['createdTime'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();

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
                makeTeam['recruitmentTitle'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    _showAuthorStackDialog();
                  },
                  child: Text(
                    makeTeam['memberName'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${createdTimeParts![0]}/${createdTimeParts[1]}/${createdTimeParts[2]}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                makeTeam['recruitmentContent'],
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '모집 인원 ${makeTeam['studentCount']}/4',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '~${endTimeParts[1].trim()}/${endTimeParts[2].trim()}까지',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
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
                          if (currentMembers == maxMembers)
                            // 팀원이 최대 인원에 도달하면 팀 생성 버튼을 보여 줌
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
                      makeTeam['memberName'] ?? 'Unknown',
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
                        '${makeTeam['studentCount']}명',
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
                    children:
                        makeTeam['hopeField'].split(',').map<Widget>((field) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              width: 80,
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
                    // 댓글 입력 후 전송 버튼입니다.
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
              // 팀원 신청 리스트를 보여주는 ListView
              Expanded(
                child: ListView.builder(
                  itemCount: applyList.length,
                  itemBuilder: (context, index) {
                    final apply = applyList[index];
                    final bool isCurrentUser = apply['memberName'] == name;

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
                                  _showApproveDialog(index);
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
                                  _showRejectDialog(index);
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
                              const Spacer(),
                              // 현재 사용자가 댓글 작성자인 경우에만 팝업 메뉴를 보여 줌
                              if (isCurrentUser)
                                PopupMenuButton<String>(
                                  color: const Color(0xFFEFF0F2),
                                  onSelected: (String item) {
                                    if (item == '수정') {
                                      _showEditDialog(
                                          context,
                                          applyList[index]
                                              ['applicationContent'],
                                          index);
                                    } else if (item == '삭제') {
                                      _deleteContent(index);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuEntry<String>>[
                                      popUpItem('수정', '수정'),
                                      const PopupMenuDivider(),
                                      popUpItem('삭제', '삭제'),
                                    ];
                                  },
                                  child: const Icon(Icons.more_vert),
                                ),
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
            ],
          ),
        ),
      ),
    );
  }

  // 글쓴 사람의 기술 스택을 보여주는 다이얼로그
  Future<void> _showAuthorStackDialog() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await profileProvider.fetchProfile(widget.makeTeam['memberId']!);

    final techStack = profileProvider.techStack;
    final githubLink = techStack['githubLink'];
    final developmentFields = (techStack['developmentField'] as String)
        .split(',')
        .map((field) => field.trim())
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${widget.makeTeam['memberName']}님의 기술 스택'),
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
                  children: developmentFields.map<Widget>((field) {
                    final fieldData = fieldList.firstWhere(
                      (element) => element['title'] == field,
                    );
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

  // 승인 확인 다이얼로그
  void _showApproveDialog(int index) {
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
                        if (widget.makeTeam['studentCount'] < 4) {
                          widget.makeTeam['studentCount']++;
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

  // 반려 확인 다이얼로그
  void _showRejectDialog(int index) {
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
                        applyList.removeAt(index);
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

  // 신청자의 기술 스택 및 Github 정보를 보여주는 다이얼로그
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
                  children: fieldList.map<Widget>((field) {
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

  // 댓글 수정 다이얼로그
  void _showEditDialog(BuildContext context, String initialContent, int index) {
    final TextEditingController controller =
        TextEditingController(text: initialContent);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '댓글 수정',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "새로운 댓글을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateContent(index, controller.text);
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }

  // 기술 스택 배지를 생성하는 함수
  Widget badge(
    String logoUrl,
    String title,
    Color titleColor,
    Color badgeColor,
  ) {
    return badges.Badge(
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
