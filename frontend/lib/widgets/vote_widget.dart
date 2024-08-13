import 'package:flutter/material.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/viewVote_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VoteWidget extends StatefulWidget {
  final List<Vote>? votes;
  const VoteWidget({this.votes, super.key});

  @override
  State<VoteWidget> createState() => _VoteWidgetState();
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

class _VoteWidgetState extends State<VoteWidget> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var vote in widget.votes!) {
        await Provider.of<VoteProvider>(context, listen: false)
            .fetchVote(vote.id!);
      }
    });

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
    final voteList = Provider.of<VoteProvider>(context).voteList;
    print('투표 조회 성공: $voteList');

    final contentList = Provider.of<VoteProvider>(context).contentList;

    return Material(
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: voteList.length,
          itemBuilder: (context, index) {
            final vote = voteList[index];

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 학년 공지 상단바
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vote.subjectTitle ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          vote.endTime != null && vote.endTime!.isNotEmpty
                              ? DateFormat("d일 H시 mm분까지").format(DateTime.parse(
                                  vote.endTime!)) // format() 메서드를 사용하여 DateTime 객체를 지정한 형식의 문자열로 변환
                              : 'No End Time',
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFE), // 박스 배경색
                        borderRadius:
                            BorderRadius.circular(15.0), // Border radius
                      ),
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (vote.voteItemIds!.isNotEmpty &&
                              contentList.isNotEmpty)
                            for (int i = 0; i < vote.voteItemIds!.length; i++)
                              GestureDetector(
                                // onTap: () => _toggleIcon(i),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          contentList[i]
                                              ['content'], // 투표 항목 텍스트를 표시
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        // 투표 아이콘이 선택되었고 이미 투표를 한 경우, 체크 아이콘을 표시
                                        // if (_showIconList[i] && _hasVoted)
                                        //   Image.asset(
                                        //     'assets/images/votecheck.png',
                                        //     width: 12,
                                        //     height: 12,
                                        //   )
                                        // // 투표 아이콘만 선택된 경우, 터치 가능한 원 모양 아이콘을 표시하고 토글 기능 추가
                                        // else if (_showIconList[i])
                                        //   InkWell(
                                        //     onTap: () => _toggleIcon(i),
                                        //     borderRadius:
                                        //         BorderRadius.circular(10.0),
                                        //     child: Container(
                                        //       padding:
                                        //           const EdgeInsets.all(1.0),
                                        //       decoration: BoxDecoration(
                                        //         color: _circleColors[i],
                                        //         shape: BoxShape.circle,
                                        //       ),
                                        //       child: CircleAvatar(
                                        //         radius: 10.0,
                                        //         backgroundColor: Colors.white,
                                        //         child: Icon(
                                        //           Icons.circle,
                                        //           size: 6.0,
                                        //           color: _circleColors[i],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // const SizedBox(width: 8.0),
                                        // Text(
                                        //   _voteItems[i], // 투표 항목 텍스트를 표시
                                        //   style: const TextStyle(
                                        //     fontSize: 11,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.black,
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 20),
                                        // // 이미 투표한 경우, 투표한 사람 수를 표시
                                        // if (_hasVoted && _showIconList[i])
                                        //   GestureDetector(
                                        //     onTap: () {
                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               const ViewVotePage(),
                                        //         ),
                                        //       );
                                        //     },
                                        //     child: Text(
                                        //       '${_voteCounts[i]}명',
                                        //       style: const TextStyle(
                                        //         fontSize: 11,
                                        //         fontWeight: FontWeight.bold,
                                        //         color: Colors.black,
                                        //       ),
                                        //     ),
                                        //   ),
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
                                                horizontal: 20.0,
                                                vertical: 6.0),
                                            height: 28,
                                            child: TextFormField(
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              controller: _itemInputControllers
                                                      .isNotEmpty
                                                  ? _itemInputControllers[i %
                                                      _itemInputControllers
                                                          .length]
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
                                              onSaved: (val) {
                                                setState(() {
                                                  _itemInputControllers[i]
                                                      .text = val!;
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
                                          // GestureDetector 안의 onTap 이벤트에서 항목 추가 메서드 호출하기
                                          onTap: () async {
                                            // 사용자 입력값 가져오기
                                            final content =
                                                _itemInputControllers[i].text;

                                            // 값이 비어있지 않은지 확인
                                            if (content.isNotEmpty) {
                                              try {
                                                // addVoteItem 메서드 호출, await로 비동기 처리
                                                await Provider.of<VoteProvider>(
                                                        context,
                                                        listen: false)
                                                    .addVoteItem(
                                                        vote.id!, content);

                                                // 성공적으로 추가된 경우, 리스트에서 항목 삭제
                                                setState(() {
                                                  _isItemVisibleList[i] = false;
                                                  _itemInputControllers[i]
                                                      .clear();
                                                });
                                              } catch (e) {
                                                print('항목 추가 실패: $e');
                                              }
                                            } else {
                                              print('항목을 입력해주세요');
                                            }
                                          },

                                          child: Card(
                                            color: const Color(0xFFEFEFF2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            elevation: 0.5,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 6.0),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 6.0),
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
            );
          },
        ),
      ),
    );
  }
}
