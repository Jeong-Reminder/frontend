import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  // URL을 여는 함수
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          toolbarHeight: 70,
          automaticallyImplyLeading: false, // 기본 백 버튼 비활성화
          actions: [
            // 닫기 버튼
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 닫기 아이콘을 눌렀을 때 이전 화면으로 이동
                },
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "ANYTIME(애니타임) 개인정보처리방침",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "“ANYTIME은 개인정보 보호법 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리지침을 수립⋅공개합니다.”",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제1조(개인정보의 처리목적)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "ANYTIME은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "① 홈페이지 회원 가입 및 관리",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별⋅인증, 회원자격 유지⋅관리, 제한적 본인확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 만 14세 미만 아동의 개인정보 처리시 법정대리인의 동의여부 확인, 각종 고지⋅통지, 고충처리 등을 목적으로 개인정보를 처리합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "② 재화 또는 서비스 제공",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "서비스 제공, 계약서⋅청구서 발송, 컨텐츠 제공, 맞춤서비스 제공, 본인인증, 연령인증, 채권추심을 목적으로 개인정보를 처리합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "③ 고충처리",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락⋅통지, 처리결과 통보의 목적으로 개인정보를 처리합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "④ ANYTIME의 개인정보 처리업무",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "ANYTIME은 대학교 공지 알림 서비스 제공을 위해 다음과 같은 목적으로 개인정보를 처리합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(), // 테두리 추가
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: const [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '서비스',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '목적',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '공지사항 및 알림 전송',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'ANYTIME은 긴급 공지사항, 경진대회, 교내 행사 등을 효과적으로 전달하기 위해 개인정보를 처리합니다. 사용자가 공지사항을 적시에 수신할 수 있도록 푸시 알림의 방법으로 알림을 발송합니다.',
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '서비스 개선 및 사용자 피드백 처리',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '사용자 경험을 개선하기 위해 서비스 이용 내역을 분석하고, 서비스 제공 과정에서 발생하는 불만 및 고충 처리를 위해 개인정보를 처리합니다. 또한, 어플 사용 중 발생한 문제를 해결하거나 사용자 피드백을 반영하기 위해 연락 정보를 활용합니다.',
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '회원 관리 및 서비스 이용 통계',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '회원의 서비스 이용 현황을 분석하여 서비스 제공에 필요한 데이터를 확보하고, 회원의 가입 상태 및 이용 기록을 바탕으로 서비스 부정 이용 방지, 본인인증 및 유지 관리를 위한 개인정보를 처리합니다.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "개인정보 처리업무",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "ANYTIME은 위의 목적 외에 다른 용도로 개인정보를 사용하지 않으며, 처리 목적이 변경될 경우에는 별도의 동의를 받는 등 법령에 따라 필요한 절차를 이행합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제2조(개인정보의 처리 및 보유기간)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "① ANYTIME은 법령에 따른 개인정보 보유⋅이용 기간 또는 정보주체로부터 개인정보를 수집시에 동의받은 개인정보 보유⋅이용 기간 내에서 개인정보를 처리⋅보유합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "  1. 홈페이지 회원 가입 및 관리 : ANYTIME 앱 탈퇴시까지(졸업)\n  다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "    1) 관계 법령 위반에 따른 수사⋅조사 등이 진행중인 경우에는 해당 수사⋅조사 종료시까지\n    2) 앱 이용에 따른 채권⋅채무관계 잔존시에는 해당 채권⋅채무관계 정산시까지",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "  2. 재화 또는 서비스 제공 : 재화, 서비스 공급완료 및 요금 결제, 정산 완료시까지\n   다만, 다음의 사유에 해당하는 경우에는 해당 기간 종료시까지",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "    1) 「전자상거래 등에서의 소비자 보호에 관한 법률」에 따른 표시, 광고 계약내용 및 이행 등 거래에 관한 기록\n    - 표시, 광고에 관한 기록 : 6개월\n    - 계약 또는 청약철회, 대금결제, 재화 등의 공급기록 : 5년\n    - 소비자 불만 또는 분쟁처리에 관한 기록 : 3년",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "    2) 「통신비밀보호법」 제41조에 따른 통신사실확인자료 보관\n    - 가입자 전기통신일시, 개시⋅종료시간, 상대방 가입자번호, 사용도수, 발신기지국 위치추적자료 : 1년\n    - 컴퓨터 통신, 인터넷 로그기록자료, 접속지 추적자료 : 3개월",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "    3) 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」시행령 제29조에 따른 본인확인정보 보관 : 게시판에 정보 게시가 종료된 후 6개월",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제3조(처리하는 개인정보 항목)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "ANYTIME은 「개인정보 보호법」에 따라 서비스 제공을 위해 필요 최소한의 범위에서 개인정보를 수집⋅이용합니다.\n정보 주체의 동의를 받지 않고 처리하는 개인정보 항목",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(), // 테두리 추가
                columnWidths: const {
                  0: FlexColumnWidth(2.2),
                  1: FlexColumnWidth(1.4),
                  2: FlexColumnWidth(2.5),
                  3: FlexColumnWidth(2.4),
                  4: FlexColumnWidth(2.2),
                },
                children: const [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '법적근거',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '구분',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '수집 목적',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '수집 항목',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '보유 및 이용기간',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '개인정보 보호법 제 15조 제 1항 제 4호\n(계약의 이행)',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '회원 서비스 운영',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '회원 서비스 제공에 따른 본인 식별 및 인증, 회원자격 유지 및 관리, 서비스 부정 이용 방지',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'ID, 성명, 비밀번호, 학번',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '회원 탈퇴 시',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "제4조(정보주체의 권리⋅의무 및 행사방법)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "① 정보주체는 ANYTIME에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다. "
                "(※ 14세 미만 아동에 관한 개인정보의 열람 등 요구는 법정대리인이 직접 해야 하며, 14세 이상의 미성년자인 정보주체는 정보주체의 개인정보에 관하여 미성년자 본인이 권리를 행사하거나 법정대리인을 통하여 권리를 행사할 수도 있습니다.)",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "② 제1항에 따른 권리 행사는 ANYTIME에 대해「개인정보 보호법」 시행령 제41조 제1항에 따라 서면, 전화, 전자우편, 모사전송(FAX)등을 통하여 하실 수 있으며 리마인더는 이에 대해 지체없이 조치하겠습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "③ 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 리마인더는 정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "④ 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "⑤ 정보주체는 개인정보파일은 「개인정보 보호법」 제37조(개인정보의 처리정지 등)에 따라 처리정지를 요구할 수 있습니다. 다만, 개인정보 처리정지 요구 시 법 제37조 2항에 의하여 처리정지 요구가 거절될 수 있습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "▶ 개인정보 열람 등 청구 접수·처리 부서\n"
                "ANYTIME에서 보유하고 있는 개인정보 파일의 열람・정정・청구 장소는 아래와 같습니다.\n"
                "개인정보 파일의 열람, 정정,청구 장소 : 정보통신공학부\n"
                "위치 : 성결관 2층 206호\n"
                "책임관 : 공대학과장\n"
                "연락처 : 031-467-8073\n"
                "이메일 : 206sku@naver.com",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제5조(처리하는 개인정보 항목)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "ANYTIME은 다음의 개인정보 항목을 처리하고 있습니다.\n1. 홈페이지 회원 가입 및 관리\n .필수 항목 : 성명, 아이디, 비밀번호, 학번, 학년, 재학상태\n .선택 항목 : 깃허브 링크, 사용하고 있는 기술 스택, 프로젝트 경험\n\n"
                "2. 재화 또는 서비스 제공\n .필수 항목 : 성명, 아이디, 비밀번호, 학번, 학년, 재학상태\n .선택 항목 : 깃허브 링크, 사용하고 있는 기술 스택, 프로젝트 경험",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제6조(개인정보의 파기)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "① ANYTIME은 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 개인정보를 파기합니다.\n"
                "② 개인정보 파기의 절차, 기한, 방법은 다음과 같습니다.\n"
                " 1. 파기절차\n"
                "  ANYTIME은 파기 사유가 발생한 개인정보를 선정하고, 개인정보 보호책임자의 승인자를 받아 개인정보를 파기합니다.\n"
                " 2. 파기 기한 : 개인정보의 보유기간이 경과된 경우 5일 이내에 개인정보를 파기합니다.\n"
                " 3. 파기방법 : 전자적 파일은 재생할 수 없도록 로우레벨포맷, 종이 문서는 분쇄기로 분쇄합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제6조(개인정보의 안전성 확보조치)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "ANYTIME은 개인정보의 안정성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n"
                "① 관리적 조치 : 학교 후배 양성 교육\n"
                "② 기술적 조치 : 멘토⋅멘티를 통한 기술 스택 교육, 고유식별정보 등의 암호화\n"
                "③ 물리적 조치 : 해당 학교의 학생이 아닌 접근 통제",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제7조(개인정보 자동 수집 장치의 설치⋅운영 및 거부에 관한 사항)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "① ANYTIME은 이용자에게 개별적인 서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러 '쿠키(cookie)'를 사용합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "② 쿠키 및 유사한 기술의 사용에 관한 사항은 다음과 같습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                " 1) 쿠키 및 유사한 기술의 사용 목적\n"
                "앱에서는 사용자가 방문한 서비스 이용 기록, 접속 빈도, 사용 패턴, 인기 기능, 보안 접속 여부 등을 분석하여 사용자에게 최적화된 정보를 제공하기 위해 쿠키 및 유사한 기술을 사용합니다. 이를 통해 사용자의 앱 사용 경험을 향상시키고, 맞춤형 콘텐츠와 서비스 제공을 지원합니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                " 2) 쿠키 저장을 거부할 경우\n"
                "쿠키 및 유사한 기술의 저장을 거부할 경우, 앱에서 제공하는 맞춤형 서비스나 특정 기능 사용에 제한이 발생할 수 있으며, 사용자 맞춤형 콘텐츠 제공이 어려울 수 있습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                " 3) 쿠키 및 유사한 기술의 설치⋅운영 및 거부\n"
                "사용자는 모바일 기기 설정에서 쿠키 및 유사한 기술의 저장을 거부할 수 있습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                " ① 안드로이드\n설정 > 개인정보 보호 > 쿠키 설정",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                " ② 사파리(Safari)\n모바일 기기설정 > Safari > 고급 > ‘모든 쿠키 차단’ 체크\n모바일 기기설정 > ‘크로스 사이트 추적 방지’ 체크 해제",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                Platform.isIOS
                    ? "▶ 개인정보 보호 담당부서\n부서명 : 프론트\n담당자 : 민택기\n연락처 : 010-3412-6179"
                    : "▶ 개인정보 보호 담당부서\n부서명 : 프론트\n담당자 : 소진수\n연락처 : 010-2605-1892",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제8조(개인정보 보호책임자)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "① ANYTIME은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // 개인정보 보호책임자 정보 - 플랫폼별로 구분
              Platform.isIOS
                  ? Table(
                      border: TableBorder.all(), // 테두리 추가
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                      },
                      children: const [
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '개인정보 보호책임자',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '개인정보 보호 담당부서',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '성명 : 민택기\n직책 : 프론트 담당자\n연락처 : 010-3412-6179\n이메일 : tktwin00@gmail.com',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '부서명 : 프론트\n담당자 : 민택기\n연락처 : 010-3412-6179',
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Table(
                      border: TableBorder.all(), // 테두리 추가
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                      },
                      children: const [
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '개인정보 보호책임자',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '개인정보 보호 담당부서',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '성명 : 소진수\n직책 : 프론트 담당자\n연락처 : 010-2605-1892\n이메일 : thwlstn23@gmail.com',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '부서명 : 프론트\n담당자 : 소진수\n연락처 : 010-2605-1892',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              const Text(
                "② 정보주체께서는 ANYTIME의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. ANYTIME은 정보주체의 문의에 대해 지체없이 답변 및 처리해드릴 것입니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "제9조(권익침해 구제 방법)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "이 밖에 개인정보침해의 사고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black, // 기본 텍스트 색상 유지
                  ),
                  children: [
                    const TextSpan(text: "1. 개인정보 분쟁조정위원회 : (국번없이) 1833-6972 "),
                    TextSpan(
                      text: "(www.kopico.go.kr)",
                      style: const TextStyle(
                        color: Colors.blue, // 링크 색상을 파란색으로 지정
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchUrl('https://www.kopico.go.kr');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black, // 기본 텍스트 색상 유지
                  ),
                  children: [
                    const TextSpan(text: "2. 개인정보침해신고센터 : (국번없이) 118 "),
                    TextSpan(
                      text: "(privacy.kisa.or.kr)",
                      style: const TextStyle(
                        color: Colors.blue, // 링크 색상을 파란색으로 지정
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchUrl('https://privacy.kisa.or.kr');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black, // 기본 텍스트 색상 유지
                  ),
                  children: [
                    const TextSpan(text: "3. 대검찰청 : (국번없이) 1301 "),
                    TextSpan(
                      text: "(www.spo.go.kr)",
                      style: const TextStyle(
                        color: Colors.blue, // 링크 색상을 파란색으로 지정
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchUrl('https://www.spo.go.kr');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black, // 기본 텍스트 색상 유지
                  ),
                  children: [
                    const TextSpan(text: "4. 경찰청 : (국번없이) 182 "),
                    TextSpan(
                      text: "(ecrm.cyber.go.kr)",
                      style: const TextStyle(
                        color: Colors.blue, // 링크 색상을 파란색으로 지정
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchUrl('https://ecrm.cyber.go.kr');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "제10조(개인정보 처리방침 변경)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "이 개인정보 처리방침은 2024.09.14.에 개정되었습니다.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "이전 개인정보처리방침은 아래에서 확인하실 수 있습니다.",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    // TextSpan(
                    //   text: " [이전 개인정보처리방침 보기]",
                    //   style: const TextStyle(color: Colors.blue, fontSize: 16),
                    //   recognizer: TapGestureRecognizer()
                    //     ..onTap = () async {
                    //       final Uri url = Uri.parse(
                    //           "https://www.example.com/privacy-previous");
                    //       if (await canLaunchUrl(url)) {
                    //         await launchUrl(url);
                    //       }
                    //     },
                    // ),
                  ],
                ),
              ),
            ])));
  }
}
