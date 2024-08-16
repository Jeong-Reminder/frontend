import 'package:flutter/material.dart';
import 'package:frontend/models/vote_model.dart';
import 'package:frontend/providers/vote_provider.dart';
import 'package:frontend/screens/viewVote_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VoteWidget extends StatefulWidget {
  final List<Vote>? votes; // 외부에서 받아오는 투표 목록
  const VoteWidget({this.votes, super.key});

  @override
  State<VoteWidget> createState() => _VoteWidgetState();
}

// 팝업 메뉴 항목 구성 함수
PopupMenuItem<PopUpItem> popUpItem(String text, PopUpItem item) {
  return PopupMenuItem<PopUpItem>(
    enabled: true,
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

// 팝업 메뉴 항목을 나열
enum PopUpItem { popUpItem1, popUpItem2, popUpItem3 }

class _VoteWidgetState extends State<VoteWidget> {
  // 투표 항목의 상태를 관리하는 리스트들
  List<bool> _showIconList = []; // 각 카드의 아이콘 상태(숨김 여부)
  List<Color> _circleColors = []; // 각 카드의 초기 동그라미 색상
  List<bool> _hasVotedList = []; // 각 항목별 투표 여부
  List<int> _voteCounts = []; // 투표 선택 명수

  bool _isVoteBoxSelected = false; // 투표 박스 선택 여부
  bool _hasVoted = false; // 투표 여부
  final List<TextEditingController> _itemInputControllers =
      []; // 항목 입력 컨트롤러 리스트
  final List<bool> _isItemVisibleList = []; // 각 항목의 가시성 상태를 추적하는 리스트

  String userRole = ''; // 사용자 역할
  List<int> itemIdList = []; // 선택된 투표 항목 아이디

  // 투표 항목 선택 시 아이콘 상태를 토글하는 함수
  void _toggleIcon(int index, int voteItemId, bool repetition) {
    setState(() {
      if (index < _showIconList.length) {
        // 반복 투표를 허용하거나, 해당 항목에 대해 아직 투표하지 않은 경우에만 실행
        if (repetition || !_hasVotedList[index]) {
          // 아이콘 상태와 색상 토글
          _showIconList[index] = !_showIconList[index];
          _circleColors[index] =
              _showIconList[index] ? const Color(0xFF7B88C2) : Colors.black;

          // 투표 수를 증가 또는 감소
          if (_showIconList[index]) {
            _voteCounts[index]++;
            // 중복 투표 허용 여부와 관계없이 항목 ID를 리스트에 추가
            itemIdList.add(voteItemId);
          } else {
            _voteCounts[index]--;
            // 선택 해제 시 항목 ID를 리스트에서 제거
            itemIdList.remove(voteItemId);
          }

          // 투표 여부 업데이트 (repetition이 false일 때만)
          if (!repetition) {
            _hasVotedList[index] = _showIconList[index];
          }

          // 투표 박스가 선택되었는지 확인
          _isVoteBoxSelected = _showIconList.contains(true);
        } else {
          // 중복 투표가 허용되지 않는 경우
          print("이 항목에 대해서는 이미 투표했습니다.");
        }
      }
    });
  }

  // 새로운 항목을 추가하는 함수
  // void _addItem(String newItem) {
  //   if (newItem.isNotEmpty) {
  //     setState(() {
  //       _voteItems.add(newItem); // 새로운 항목을 리스트에 추가
  //       _showIconList.add(false); // 새 항목에 대한 아이콘을 표시하지 않음
  //       _circleColors.add(Colors.black); // 새 항목에 대한 아이콘 색상을 기본으로 설정
  //       _hasVotedList.add(false); // 새 항목에 대한 투표 여부를 기본으로 설정
  //       _voteCounts.add(0); // 새 항목에 대한 투표 수 초기화
  //     });
  //   }
  // }

  // 항목 추가 버튼을 눌렀을 때 호출되는 함수
  // void _onConfirmButtonPressed(int index) {
  //   if (index >= 0 && index < _itemInputControllers.length) {
  //     String newItemName = _itemInputControllers[index].text;
  //     if (newItemName.isNotEmpty) {
  //       _addItem(newItemName); // 새 항목 추가
  //     }
  //   }
  // }

  // 사용자 정보를 로드하는 함수
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI(); // LoginAPI 인스턴스 생성
    final credentials = await loginAPI.loadCredentials(); // 저장된 자격증명 로드
    setState(() {
      userRole = credentials['userRole']; // 로그인 정보에 있는 userRole를 가져와 저장
    });
  }

  @override
  void initState() {
    super.initState();

    // 위젯이 처음 빌드된 후, 서버에서 투표 정보를 가져오는 작업 수행
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var vote in widget.votes!) {
        await Provider.of<VoteProvider>(context, listen: false)
            .fetchVote(vote.id!);

        // 투표 정보 가져온 후, 해당 투표의 항목 개수에 맞게 리스트 초기화
        if (mounted) {
          // mounted: setState가 호출되는 시점에 위젯이 이미 화면에 존재하지 않아 발생하는 예외를 방지하기 위해
          // mounted를 통해 확인
          setState(() {
            _showIconList =
                List<bool>.from(List.filled(vote.voteItemIds!.length, false));
            _circleColors = List<Color>.from(
                List.filled(vote.voteItemIds!.length, Colors.black));
            _hasVotedList =
                List<bool>.from(List.filled(vote.voteItemIds!.length, false));
            _voteCounts =
                List<int>.from(List.filled(vote.voteItemIds!.length, 0));
          });
        }
      }
    });

    _loadCredentials();
  }

  @override
  void dispose() {
    // 사용된 입력 컨트롤러를 모두 해제
    for (var controller in _itemInputControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voteList =
        Provider.of<VoteProvider>(context).voteList; // 투표 리스트를 제공받음
    print('투표 조회 성공: $voteList');

    final contentList =
        Provider.of<VoteProvider>(context).contentList; // 항목 내용 리스트를 제공받음

    return Material(
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: voteList.length, // 투표 리스트 길이만큼 아이템 생성
          itemBuilder: (context, index) {
            final vote = voteList[index];

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 투표 제목과 종료 시간을 표시하는 상단 바
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
                              ? DateFormat("d일 H시 mm분까지")
                                  .format(DateTime.parse(vote.endTime!))
                              : 'No End Time',
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFE), // 박스 배경색
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 투표 항목을 동적으로 생성하여 표시
                          if (vote.voteItemIds!.isNotEmpty &&
                              contentList.isNotEmpty)
                            for (int i = 0; i < vote.voteItemIds!.length; i++)
                              if (i < contentList.length)
                                Row(
                                  children: [
                                    InkWell(
                                      // GestureDetector를 InkWell로 대체
                                      onTap: () => _toggleIcon(
                                          i,
                                          vote.voteItemIds![i],
                                          vote.repetition!), // 아이콘 토글 함수 호출
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
                                          width: 171,
                                          height: 28,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // 이미 투표를 완료한 경우 체크 아이콘 표시
                                              if (i < _showIconList.length &&
                                                  _showIconList[i] &&
                                                  _hasVoted)
                                                Image.asset(
                                                  'assets/images/votecheck.png',
                                                  width: 12,
                                                  height: 12,
                                                )
                                              // 투표 아이콘만 선택된 경우, 터치 가능한 원 모양 아이콘 표시
                                              else if (i <
                                                      _showIconList.length &&
                                                  _showIconList[i])
                                                InkWell(
                                                  onTap: () => _toggleIcon(
                                                      i,
                                                      vote.voteItemIds![i],
                                                      vote.repetition!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    decoration: BoxDecoration(
                                                      color: _circleColors[i],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 10.0,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 6.0,
                                                        color: _circleColors[i],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(width: 8.0),
                                              // 투표 항목 내용 표시
                                              Text(
                                                contentList[i]['content'],
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              // 투표 완료한 경우 투표 인원 표시
                                              if (_hasVoted &&
                                                  i < _showIconList.length &&
                                                  _showIconList[i])
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 삭제 버튼(관리자만 보이게 설정)
                                    if (userRole == 'ROLE_ADMIN')
                                      IconButton(
                                        onPressed: () async {
                                          // 투표 항목 강제 삭제 API
                                          await Provider.of<VoteProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteVoteItem(
                                                  vote.voteItemIds![i]);

                                          setState(() {
                                            // 항목을 삭제하면서 상태 리스트에서도 제거
                                            vote.voteItemIds!.removeAt(i);
                                            _showIconList.removeAt(i);
                                            _circleColors.removeAt(i);
                                            _hasVotedList.removeAt(i);
                                            _voteCounts.removeAt(i);
                                          });

                                          // 투표 조회 API
                                          if (context.mounted) {
                                            await Provider.of<VoteProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchVote(vote.id!);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color(0xFF2B72E7),
                                        ),
                                      ),
                                  ],
                                ),
                          const SizedBox(height: 4.0),

                          // 항목 추가 및 투표 인원 표시
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
                                        if (userRole == 'ROLE_USER') {
                                          _isItemVisibleList
                                              .add(true); // 새 항목 입력 필드 표시
                                          _itemInputControllers.add(
                                              TextEditingController()); // 입력 컨트롤러 추가
                                        } else if (userRole == 'ROLE_ADMIN') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                                            const SnackBar(
                                              content: Text(
                                                  '관리자는 사용하실 수 없습니다.'), //snack bar의 내용. icon, button같은것도 가능하다.
                                              duration: Duration(
                                                  seconds: 3), //올라와있는 시간
                                            ),
                                          );
                                        }
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

                          // 새로 추가된 항목 입력 필드 생성
                          for (int i = 0; i < _isItemVisibleList.length; i++)
                            if (_isItemVisibleList[i])
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
                                          controller: _itemInputControllers[i],
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
                                              _isItemVisibleList[i] = true;
                                            });
                                          },
                                          onSaved: (val) {
                                            setState(() {
                                              _itemInputControllers[i].text =
                                                  val!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),

                                  // 확인 버튼(항목 추가)
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final content =
                                            _itemInputControllers[i].text;

                                        // 투표 항목 추가 API
                                        if (content.isNotEmpty) {
                                          await Provider.of<VoteProvider>(
                                                  context,
                                                  listen: false)
                                              .addVoteItem(vote.id!, content);

                                          setState(() {
                                            _isItemVisibleList[i] = false;
                                            _itemInputControllers[i].clear();
                                            _showIconList.add(false);
                                            _circleColors.add(Colors.black);
                                            _hasVotedList.add(false);
                                            _voteCounts.add(0);
                                          });
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

                                  // 취소 버튼
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
                              ),
                          const SizedBox(height: 6.0),

                          // 투표하기 버튼
                          Center(
                            child: SizedBox(
                              height: 32,
                              width: 227,
                              child: TextButton(
                                onPressed: (userRole == 'ROLE_USER')
                                    ? _isVoteBoxSelected
                                        ? () async {
                                            setState(() {
                                              _hasVoted = !_hasVoted;
                                            });

                                            print(
                                                'voteId: ${vote.id} \n itemId: $itemIdList');

                                            for (int itemId in itemIdList) {
                                              await VoteProvider()
                                                  .vote(vote.id!, itemId);
                                            }
                                          }
                                        : null
                                    : () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                                          const SnackBar(
                                            content: Text(
                                                '관리자는 사용하실 수 없습니다.'), //snack bar의 내용. icon, button같은것도 가능하다.
                                            duration:
                                                Duration(seconds: 3), //올라와있는 시간
                                          ),
                                        );
                                      },
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
