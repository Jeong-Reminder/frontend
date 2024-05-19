import 'package:flutter/material.dart';

class votePage extends StatefulWidget {
  const votePage({super.key});

  @override
  State<votePage> createState() => _votePageState();
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

enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 } // 팝업 아이템

class _votePageState extends State<votePage> {
  final List<bool> _showIconList = [false, false, false]; // 각 카드의 아이콘 상태(숨김 여부)
  final List<Color> _circleColors = [
    Colors.black,
    Colors.black,
    Colors.black,
  ]; // 각 카드의 초기 동그라미 색상
  final List<bool> _hasVotedList = [false, false, false]; // 각 항목별 투표 여부
  final List<int> _voteCounts = [9, 7, 7]; // 투표 선택 명수
  bool _isVoteBoxSelected = false; // 투표 박스 선택
  bool _hasVoted = false; // 투표 여부

  void _toggleIcon(int index) {
    setState(() {
      _showIconList[index] = !_showIconList[index]; // 인덱스 별로 구분
      // index가 0인 상태에서 _toggleIcon(0)이 호출
      // _showIconList[0]의 값이 false에서 true로 변경
      // 첫 번째 카드의 아이콘 표시

      _circleColors[index] = _showIconList[index]
          ? const Color(0xFF7B88C2)
          : Colors
              .black; // _circleColors[0]이면 0xFF7B88C2 _circleColors[0]이 아니면 검정
      if (_showIconList[index]) {
        _voteCounts[index]++;
      } else {
        _voteCounts[index]--;
      }
      _isVoteBoxSelected = _showIconList.contains(true);
    });
  }

  void _vote() {
    if (_isVoteBoxSelected) {
      setState(() {
        _hasVoted = true;
        for (int i = 0; i < _showIconList.length; i++) {
          if (_showIconList[i]) {
            _hasVotedList[i] = true;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류 방지
          toolbarHeight: 70,
          leading: const Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 학년 공지 상단바
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '학년 공지',
                    style: TextStyle(
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
                        const PopupMenuDivider(),
                        popUpItem('수정', PopUpItem.popUpItem2),
                        const PopupMenuDivider(),
                        popUpItem('삭제', PopUpItem.popUpItem3),
                      ];
                    },
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    '02/03',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFA89F9F),
                    ),
                  ),
                  SizedBox(width: 7),
                  Text(
                    '14:28',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFA89F9F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '정보통신공학과 증원 신청',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '< 신청 마감 시간 >',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const Text(
                '1차 : 5일 오후 2시까지 신청',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const Text(
                '2차 : 6일 오후 2시까지 신청',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 17),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFE), // 박스 배경색
                  borderRadius: BorderRadius.circular(15.0), // Border radius
                ),
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleIcon(0), // 클릭 시 아이콘 토글
                      child: Card(
                        // 첫 번째 투표 상자
                        color: const Color(0xFFEFEFF2), // 투표 박스 색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 둥근 정도
                        ),
                        elevation: 0.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 6.0),
                          width: 171,
                          height: 28,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (_showIconList[0] && _hasVoted)
                                // index 0 -> _showIconList[0]의 값이 false에서 true로 변경
                                // 아이콘 생성
                                Image.asset(
                                  'assets/images/votecheck.png',
                                  width: 12,
                                  height: 12,
                                )
                              else if (_showIconList[0])
                                InkWell(
                                  onTap: () => _toggleIcon(0),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // InkWell의 경계 설정
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(1.0), // 테두리 두께 조절
                                    decoration: BoxDecoration(
                                      color: _circleColors[0], // 테두리 색상
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 10.0, // CircleAvatar 반지름 조절
                                      backgroundColor:
                                          Colors.white, // CircleAvatar 배경 색상
                                      child: Icon(
                                        Icons.circle,
                                        size: 6.0, // 아이콘 크기 조절
                                        color: _circleColors[0], // 아이콘 색상
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8.0),
                              const Text(
                                '대학물리학',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 38),
                              if (_hasVoted && _showIconList[0])
                                Text(
                                  '${_voteCounts[0]}명',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _toggleIcon(1), // 클릭 시 아이콘 토글
                      child: Card(
                        // 두 번째 투표 상자
                        color: const Color(0xFFEFEFF2), // 투표 박스 색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 둥근 정도
                        ),
                        elevation: 0.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 6.0),
                          width: 171,
                          height: 28,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (_showIconList[1] && _hasVoted)
                                // index 1 -> _showIconList[1]의 값이 false에서 true로 변경
                                // 아이콘 생성
                                Image.asset(
                                  'assets/images/votecheck.png',
                                  width: 12,
                                  height: 12,
                                )
                              else if (_showIconList[1])
                                InkWell(
                                  onTap: () => _toggleIcon(1),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // InkWell의 경계 설정
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(1.0), // 테두리 두께 조절
                                    decoration: BoxDecoration(
                                      color: _circleColors[1], // 테두리 색상
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 10.0, // CircleAvatar 반지름 조절
                                      backgroundColor:
                                          Colors.white, // CircleAvatar 배경 색상
                                      child: Icon(
                                        Icons.circle,
                                        size: 6.0, // 아이콘 크기 조절
                                        color: _circleColors[1], // 아이콘 색상
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8.0),
                              const Text(
                                '정보통신개론',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 32),
                              if (_hasVoted && _showIconList[1])
                                Text(
                                  '${_voteCounts[1]}명',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _toggleIcon(2), // 클릭 시 아이콘 토글
                      child: Card(
                        // 세 번째 투표 상자
                        color: const Color(0xFFEFEFF2), // 투표 박스 색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 둥근 정도
                        ),
                        elevation: 0.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 6.0),
                          width: 171,
                          height: 28,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (_showIconList[2] && _hasVoted)
                                // index 2 -> _showIconList[2]의 값이 false에서 true로 변경
                                // 아이콘 생성
                                Image.asset(
                                  'assets/images/votecheck.png',
                                  width: 12,
                                  height: 12,
                                )
                              else if (_showIconList[2])
                                InkWell(
                                  onTap: () => _toggleIcon(2),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // InkWell의 경계 설정
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(1.0), // 테두리 두께 조절
                                    decoration: BoxDecoration(
                                      color: _circleColors[2], // 테두리 색상
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 10.0, // CircleAvatar 반지름 조절
                                      backgroundColor:
                                          Colors.white, // CircleAvatar 배경 색상
                                      child: Icon(
                                        Icons.circle,
                                        size: 6.0, // 아이콘 크기 조절
                                        color: _circleColors[2], // 아이콘 색상
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8.0),
                              const Text(
                                '프로그래밍언어',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 23),
                              if (_hasVoted && _showIconList[2])
                                Text(
                                  '${_voteCounts[2]}명',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/addsquare.png',
                              width: 16.0,
                              height: 16.0,
                            ),
                            const SizedBox(width: 4.0),
                            const Text(
                              '항목 추가',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B72E7),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/good.png',
                              width: 16.0,
                              height: 16.0,
                            ),
                            const SizedBox(width: 4.0),
                            const Text(
                              '9명',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Center(
                      child: SizedBox(
                        height: 32,
                        width: 227,
                        child: TextButton(
                          onPressed: _isVoteBoxSelected
                              ? () {
                                  setState(() {
                                    _hasVoted = !_hasVoted;
                                  });
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor: _isVoteBoxSelected
                                ? MaterialStateProperty.all<Color>(
                                    const Color(0xff2A72E7))
                                : MaterialStateProperty.all<Color>(
                                    const Color(0xFFEFEFF2)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Text(
                            _hasVoted ? '다시 투표하기' : '투표하기',
                            style: TextStyle(
                              color: _isVoteBoxSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
