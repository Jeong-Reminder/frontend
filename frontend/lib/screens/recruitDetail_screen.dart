import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:frontend/screens/experience_screen.dart';

class recruitDetailPage extends StatefulWidget {
  const recruitDetailPage({super.key});

  @override
  State<recruitDetailPage> createState() => _recruitDetailPageState();
}

class _recruitDetailPageState extends State<recruitDetailPage> {
  // 모집 명단 확장 여부를 관리하는 변수
  bool isExpandedSection1 = false;
  // 현재 모집된 인원 수
  int currentMembers = 2;
  // 최대 모집 인원 수
  int maxMembers = 4;
  final TextEditingController _controller = TextEditingController();
  // 댓글 리스트 초기화
  final List<Comment> _comments = [
    Comment(
      name: '변우석',
      grade: '3학년',
      timestamp: '23/10/21 11:57',
      content: '저도 관심 있습니다~ 연락 주세요!!',
      field: 'Frontend',
      githubUrl: 'github.com/byunwooseok',
    ),
    Comment(
      name: '민택기',
      grade: '2학년',
      timestamp: '23/10/22 12:37',
      content: '경진대회 경험 쌓고 싶습니다!!',
      field: 'Frontend',
      githubUrl: 'github.com/minteki',
    ),
    Comment(
      name: '유다은',
      grade: '2학년',
      timestamp: '23/10/24 09:57',
      content: '저도 같이 나갈 사람 구하고 있었는데 같이 해봐요!!',
      field: 'Backend',
      githubUrl: 'github.com/yudauen',
    ),
    Comment(
      name: '김혜윤',
      grade: '3학년',
      timestamp: '23/10/25 14:57',
      content: '연락 기다리겠습니다!!',
      field: 'Backend',
      githubUrl: 'github.com/kimhyeyoon',
    ),
  ];

  // 새로운 댓글을 추가하는 함수
  void _addComment() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _comments.add(
          Comment(
            name: "익명",
            grade: "1학년",
            timestamp: // DateTime 매서드로 실시간 년도, 월, 일, 시간, 분 설정
                "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}",
            content: _controller.text,
            field: 'Unknown',
            githubUrl: 'github.com/anonymous',
          ),
        );
        _controller.clear();
      });
    }
  }

  // 기술 스택 리스트
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

  // 승인 버튼 클릭 시 다이얼로그 표시
  void _showApproveDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${_comments[index].name} 승인')),
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
                        if (currentMembers < maxMembers) {
                          currentMembers++;
                          _comments.removeAt(index);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('${_comments[index].name} 반려')),
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
                        _comments.removeAt(index); // 반려 클릭 시 리스트에서 제거
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExperiencePage(),
                      ),
                    );
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

  // 글쓴 사람의 기술 스택 다이얼로그 표시
  void _showAuthorStackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이승욱님의 기술 스택'),
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
                  text: const TextSpan(
                    text: 'Github: ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'github.com/seungwooklee',
                        style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
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
              const Text(
                '[ IoT 통합 설계 경진대회 ] 팀원 모집합니다!!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showAuthorStackDialog(); // 글쓴 사람 기술 스택 다이얼로그 표시
                    },
                    child: const Text(
                      '이승욱',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '23/10/21 ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const Text(
                    '10:57 ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '경진대회 나가고 싶은데 인원이 부족해서 관심 있으신 분들과 같이 나가고 싶어요',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '모집 인원 $currentMembers/$maxMembers',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '~10/28까지',
                    style: TextStyle(
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
                    const Text(
                      '소진수',
                      style: TextStyle(
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
                    const Text(
                      '장찬현',
                      style: TextStyle(
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
                          '팀원',
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
                        '$currentMembers명',
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
                          child: const Center(
                            child: Text(
                              '백엔드',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 20,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBE7FB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text(
                              '프론트',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 20,
                          width: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBE7FB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text(
                              '디자이너',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      onTap: () {
                        _addComment();
                      },
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
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showNameDialog(
                                      comment.field, comment.githubUrl);
                                },
                                child: Text(
                                  comment.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                comment.grade,
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
                          Row(
                            children: [
                              Text(
                                comment.timestamp.split(' ')[0],
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                comment.timestamp.split(' ')[1],
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            comment.content,
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

// 댓글 모델 클래스 정의
class Comment {
  final String name;
  final String grade;
  final String timestamp;
  final String content;
  final String field;
  final String githubUrl;

  Comment({
    required this.name,
    required this.grade,
    required this.timestamp,
    required this.content,
    required this.field,
    required this.githubUrl,
  });
}
