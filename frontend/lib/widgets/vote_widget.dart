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
PopupMenuItem<PopUpItem> popUpItem(
    String text, PopUpItem item, Function() onTap) {
  return PopupMenuItem<PopUpItem>(
    enabled: true,
    onTap: onTap,
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
  String userRole = ''; // 사용자 역할
  bool isOpened = false; // 항목 입력 칸 열고 닫기 여부
  int? selectedIndex; // 선택된 항목의 인덱스를 추적하기 위한 변수
  List<int> selectedIndexList = []; // 중복일 경우 이 변수를 사용
  TextEditingController voteItemController =
      TextEditingController(); // 항목 입력 컨트롤러

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
      }
    });

    _loadCredentials();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voteList =
        Provider.of<VoteProvider>(context).voteList; // 투표 리스트를 제공받음

    // print('투표 조회 성공: $voteList');

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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vote.subjectTitle ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              vote.endDateTime != null &&
                                      vote.endDateTime!.isNotEmpty
                                  ? DateFormat("d일 H시 mm분까지")
                                      .format(DateTime.parse(vote.endDateTime!))
                                  : 'No End Time',
                            ),
                          ],
                        ),

                        // 투표 삭제/종료 버튼
                        if (userRole == 'ROLE_ADMIN')
                          // 팝업 메뉴 창
                          PopupMenuButton<PopUpItem>(
                            color: const Color(0xFFEFF0F2),
                            itemBuilder: (BuildContext context) {
                              return [
                                popUpItem('종료', PopUpItem.popUpItem1, () {}),
                                const PopupMenuDivider(),
                                popUpItem('삭제', PopUpItem.popUpItem2, () {}),
                              ];
                            },
                            child: const Icon(Icons.more_vert),
                          ),
                      ],
                    ),
                    const SizedBox(height: 17),

                    // 투표 항목
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
                          if (vote.voteItems!.isNotEmpty)
                            for (int i = 0; i < vote.voteItems!.length; i++)
                              if (i < vote.voteItems!.length)
                                Row(
                                  children: [
                                    // GestureDetector를 InkWell로 대체
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (vote.repetition!) {
                                            // 선택한 항목 아이디가 있으면 해당 요소 삭제
                                            if (selectedIndexList.contains(
                                                vote.voteItemIds![i])) {
                                              selectedIndexList.removeWhere(
                                                  (element) =>
                                                      element ==
                                                      vote.voteItemIds![i]);
                                              print(
                                                  'selectedIndexList: $selectedIndexList');
                                            }
                                            // 선택한 항목 아이디 추가
                                            else {
                                              selectedIndexList
                                                  .add(vote.voteItemIds![i]);
                                              print(
                                                  'selectedIndexList: $selectedIndexList');
                                            }
                                          } else {
                                            // 선택한 항목이 현재 항목 아이디와 동일하다면 null로 변경
                                            if (selectedIndex ==
                                                vote.voteItemIds![i]) {
                                              selectedIndex = null;
                                              print(
                                                  'selectedIndex: $selectedIndex');
                                            } else {
                                              selectedIndex =
                                                  vote.voteItemIds![i];
                                              print(
                                                  'selectedIndex: $selectedIndex');
                                            }
                                          }
                                        });
                                      }, // 아이콘 토글 함수 호출
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
                                              // 투표 항목 선택 리스트가 비어있지 않을 경우 보이게 설정

                                              vote.voteItems![i]['hasVoted']
                                                  ? Image.asset(
                                                      'assets/images/votecheck.png',
                                                      width: 12,
                                                      height: 12,
                                                    )

                                                  // 투표를 하지 않았고 투표를 할려고 할 때
                                                  // 다중 선택 모드에서 현재 항목의 아이디가 selectedIndexList에 포함되어 있으면 원 모양을 표시
                                                  // 단일 선택 모드에서 selectedIndex가 현재 아이디와 같다면 원 모양을 표시합니다.
                                                  : ((vote.repetition! &&
                                                              selectedIndexList
                                                                  .contains(vote
                                                                          .voteItemIds![
                                                                      i])) ||
                                                          (!vote.repetition! &&
                                                              selectedIndex ==
                                                                  vote.voteItemIds![
                                                                      i]))
                                                      ? InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            child:
                                                                const CircleAvatar(
                                                              radius: 10.0,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: Icon(
                                                                Icons.circle,
                                                                size: 6.0,
                                                                color: Color(
                                                                    0xFF7B88C2),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),

                                              const SizedBox(width: 8.0),

                                              // 투표 항목 내용 표시
                                              Text(
                                                vote.voteItems![i]['content'],
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 20),

                                              // 투표 완료한 경우 투표 인원 표시
                                              (vote.voteItems![i]['hasVoted'])
                                                  ? GestureDetector(
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
                                                        '${vote.voteItems![i]['voters'].length}명',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
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
                                              .deleteVoteItem(vote.id!,
                                                  vote.voteItemIds![i]);

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

                          // 항목 추가
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
                                  if (userRole == 'ROLE_ADMIN' ||
                                      vote.hasVoted!) {
                                    alertSnackBar(context, '항목을 추가할 수 없습니다.');
                                  } else {
                                    setState(() {
                                      isOpened = !isOpened;
                                    });
                                  }
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

                          // 항목 입력, 확인과 취소 버튼
                          isOpened
                              ? Row(
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
                                            controller: voteItemController,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
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
                                            onSaved: (val) {
                                              setState(() {
                                                voteItemController.text = val!;
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
                                              voteItemController.text;

                                          // 항목을 입력했을 때 추가 api 호출
                                          if (content.isNotEmpty) {
                                            await VoteProvider()
                                                .addVoteItem(vote.id!, content);

                                            if (context.mounted) {
                                              await Provider.of<VoteProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetchVote(vote.id!);
                                            }

                                            setState(() {
                                              isOpened = false;
                                              voteItemController
                                                  .clear(); // 작성한 내용 없애기(다른 내용을 작성할 수 있음)
                                            });
                                          } else {
                                            alertSnackBar(
                                                context, '항목을 입력해주세요.');
                                          }
                                        },
                                        child: Card(
                                          color: const Color(0xFFEFEFF2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          elevation: 0.5,
                                          child: const SizedBox(
                                            height: 28,
                                            child: Center(
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
                                            isOpened = false;
                                          });
                                        },
                                        child: Card(
                                          color: const Color(0xFFEFEFF2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          elevation: 0.5,
                                          child: const SizedBox(
                                            height: 28,
                                            child: Center(
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
                          const SizedBox(height: 15),

                          // 투표하기 버튼
                          Center(
                            child: SizedBox(
                              height: 32,
                              width: 227,
                              child: TextButton(
                                onPressed: () async {
                                  // 선택한 투표 항목이 있을 경우에만 투표 API 호출
                                  if (selectedIndexList.isNotEmpty ||
                                      selectedIndex != null) {
                                    if (vote.repetition!) {
                                      await VoteProvider()
                                          .vote(vote.id!, selectedIndexList);

                                      if (context.mounted) {
                                        await Provider.of<VoteProvider>(context,
                                                listen: false)
                                            .fetchVote(vote.id!);
                                      }

                                      setState(() {
                                        // 선택된 항목 클리어(재투표할때 선택된 항목만 투표가 가능)
                                        selectedIndexList.clear();
                                      });
                                    } else {
                                      final indexList = selectedIndex
                                          .toString()
                                          .split('')
                                          .map(int.parse)
                                          .toList();
                                      await VoteProvider()
                                          .vote(vote.id!, indexList);

                                      if (context.mounted) {
                                        await Provider.of<VoteProvider>(context,
                                                listen: false)
                                            .fetchVote(vote.id!);
                                      }

                                      setState(() {
                                        indexList.clear();
                                        selectedIndex = null;
                                      });
                                    }
                                  } else {
                                    alertSnackBar(context, '투표 항목을 선택해주세요.');
                                  }
                                },
                                style: TextButton.styleFrom(
                                  // 선택한 항목이 있으면 파란색으로 변경
                                  backgroundColor: (selectedIndex != null ||
                                          selectedIndexList.isNotEmpty)
                                      ? const Color(0xff2A72E7)
                                      : const Color(0xFFEFEFF2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  (vote.hasVoted!) ? '재투표하기' : '투표하기',
                                  style: TextStyle(
                                    // 선택한 항목이 있으면 하얀색으로 변경
                                    color: (selectedIndex != null ||
                                            selectedIndexList.isNotEmpty)
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

// 팝업 알림 위젯
void alertSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title), //snack bar의 내용. icon, button같은것도 가능하다.
      duration: const Duration(seconds: 3), //올라와있는 시간
    ),
  );
}
