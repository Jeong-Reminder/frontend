import 'package:flutter/material.dart';
import 'package:frontend/screens/viewVote_screen.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
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

class _VotePageState extends State<VotePage> {
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
  final List<TextEditingController> _itemInputControllers = []; // 항목 입력 컨트롤러
  final List<bool> _isItemVisibleList = []; // 각 항목의 가시성 상태를 추적하는 리스트
  final List<String> _voteItems = ["대학물리학", "정보통신개론", "프로그래밍언어"]; // 초기 투표 항목

  void _toggleIcon(int index) {
    setState(() {
      // 해당 인덱스의 아이콘 상태를 토글
      _showIconList[index] = !_showIconList[index];

      // 만약 아이콘이 표시되어야 하는 상태라면, 선택된 아이콘의 색상 설정
      // 그렇지 않으면 검은색으로 설정
      _circleColors[index] =
          _showIconList[index] ? const Color(0xFF7B88C2) : Colors.black;

      // 아이콘 상태에 따라 투표 수 업데이트
      if (_showIconList[index]) {
        _voteCounts[index]++; // 선택됐다면 투표 수 증가
      } else {
        _voteCounts[index]--; // 선택이 해제됐다면 투표 수 감소
      }

      // 하나 이상의 아이콘이 선택되었는지 확인
      _isVoteBoxSelected = _showIconList.contains(true);
    });
  }

  void _vote() {
    // 하나 이상의 아이콘이 선택되어 있으면 투표 진행
    if (_isVoteBoxSelected) {
      setState(() {
        _hasVoted = true; // 사용자가 투표했음을 나타냄

        // 선택된 아이콘에 해당하는 투표 여부를 업데이트
        for (int i = 0; i < _showIconList.length; i++) {
          if (_showIconList[i]) {
            _hasVotedList[i] = true; // 해당 항목에 투표한 것을 나타냄
          }
        }
      });
    }
  }

  void _addItem(String newItem) {
    // 새로운 항목을 추가
    if (newItem.isNotEmpty) {
      setState(() {
        _voteItems.add(newItem); // 새로운 항목을 리스트에 추가
        _showIconList.add(false); // 새 항목에 대한 아이콘을 표시하지 않음
        _circleColors.add(Colors.black); // 새 항목에 대한 아이콘 색상을 기본으로 설정
        _hasVotedList.add(false); // 새 항목에 대한 투표 여부를 기본으로 설정
        _voteCounts.add(0); // 새 항목에 대한 투표 수 초기화
      });
    }
  }

  // 확인 버튼을 눌렀을 때 호출되는 함수
  void _onConfirmButtonPressed(int index) {
    // 입력된 인덱스가 유효한지 확인하고 새 항목 추가
    if (index >= 0 && index < _itemInputControllers.length) {
      String newItemName = _itemInputControllers[index].text;
      if (newItemName.isNotEmpty) {
        _addItem(newItemName); // 새 항목 추가
      }
    }
  }

  @override
  void initState() {
    super.initState();
    int numberOfFields = _showIconList.length;
    for (int i = 0; i < numberOfFields; i++) {
      // 입력 컨트롤러를 초기화하고 각 항목의 가시성을 기본으로 설정
      _itemInputControllers.add(TextEditingController());
      _isItemVisibleList.add(false);
    }
  }

  @override
  void dispose() {
    // 사용한 입력 컨트롤러를 모두 해제
    for (var controller in _itemInputControllers) {
      controller.dispose();
    }
    super.dispose();
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
        body: SingleChildScrollView(
          child: Padding(
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
                      for (int i = 0; i < _voteItems.length; i++)
                        GestureDetector(
                          onTap: () => _toggleIcon(i),
                          child: Card(
                            color: const Color(0xFFEFEFF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            elevation: 0.5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 6.0),
                              width: 171,
                              height: 28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // 투표 아이콘이 선택되었고 이미 투표를 한 경우, 체크 아이콘을 표시
                                  if (_showIconList[i] && _hasVoted)
                                    Image.asset(
                                      'assets/images/votecheck.png',
                                      width: 12,
                                      height: 12,
                                    )
                                  // 투표 아이콘만 선택된 경우, 터치 가능한 원 모양 아이콘을 표시하고 토글 기능 추가
                                  else if (_showIconList[i])
                                    InkWell(
                                      onTap: () => _toggleIcon(i),
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(1.0),
                                        decoration: BoxDecoration(
                                          color: _circleColors[i],
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          radius: 10.0,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.circle,
                                            size: 6.0,
                                            color: _circleColors[i],
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    _voteItems[i], // 투표 항목 텍스트를 표시
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // 이미 투표한 경우, 투표한 사람 수를 표시
                                  if (_hasVoted && _showIconList[i])
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ViewVotePage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        '${_voteCounts[i]}명',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 4.0),
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
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    // 새 항목 입력 필드 표시하기 위해 가시성 리스트에 true 값을 추가
                                    _isItemVisibleList.add(true);
                                    // 새 항목 입력 필드에 대한 텍스트 편집 컨트롤러를 생성하여 리스트에 추가
                                    _itemInputControllers
                                        .add(TextEditingController());
                                  });
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0)),
                                child: const Text(
                                  '항목 추가',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B72E7),
                                  ),
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
                      // _isItemVisibleList에 따라 항목 입력 필드 및 관련 작업 버튼을 표시하거나 숨김
                      for (int i = 0; i < _isItemVisibleList.length; i++)
                        _isItemVisibleList[i]
                            ? // 만약 항목 입력 필드를 표시해야 하는 경우
                            Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: const Color(0xFFEFEFF2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 0.5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 6.0),
                                        height: 28,
                                        child: TextFormField(
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          controller: _itemInputControllers
                                                  .isNotEmpty
                                              ? _itemInputControllers[i %
                                                  _itemInputControllers.length]
                                              : TextEditingController(),
                                          decoration: const InputDecoration(
                                              hintText: "항목 입력",
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 8),
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            setState(() {
                                              _isItemVisibleList[i] =
                                                  true; // 항목이 가시적으로 보일 수 있도록
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isItemVisibleList[i] =
                                              false; // 항목을 가시적으로 숨김
                                          _onConfirmButtonPressed(i);
                                        });
                                      },
                                      child: Card(
                                        color: const Color(0xFFEFEFF2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        elevation: 0.5,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 6.0),
                                          height: 28,
                                          child: const Center(
                                            child: Text(
                                              '확인',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isItemVisibleList
                                              .removeAt(i); // 항목 제거
                                        });
                                      },
                                      child: Card(
                                        color: const Color(0xFFEFEFF2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        elevation: 0.5,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 6.0),
                                          height: 28,
                                          child: const Center(
                                            child: Text(
                                              '취소',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      const SizedBox(height: 6.0),
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
                            style: TextButton.styleFrom(
                              backgroundColor: _isVoteBoxSelected
                                  ? const Color(0xff2A72E7)
                                  : const Color(0xFFEFEFF2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
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
      ),
    );
  }
}
