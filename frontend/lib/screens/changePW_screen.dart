import 'package:flutter/material.dart';
import 'package:frontend/services/login_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePWPage extends StatefulWidget {
  const ChangePWPage({super.key});

  @override
  State<ChangePWPage> createState() => _ChangePWPageState();
}

class _ChangePWPageState extends State<ChangePWPage> {
  final TextEditingController newController = TextEditingController();
  final TextEditingController checkController = TextEditingController();
  final TextEditingController presentController = TextEditingController();

  bool isVisible1 = false;
  bool isVisible2 = false;
  bool isVisible3 = false;

  final formKey = GlobalKey<FormState>();

  // 비밀번호 변경 처리 함수
  Future<void> _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('studentId') ?? '';
    final currentPassword = presentController.text;
    final newPassword = newController.text;

    final success = await LoginAPI()
        .changePassword(studentId, currentPassword, newPassword);

    if (success) {
      // 비밀번호 변경 성공 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
      );

      // 자동 로그인 설정 여부 확인 후 처리
      bool autoLogin = prefs.getBool('autoLogin') ?? false;
      if (!autoLogin) {
        // 자동 로그인이 체크되지 않았을 경우, 로그인 정보 삭제
        await prefs.remove('studentId');
        await prefs.remove('password');
      } else {
        // 자동 로그인이 체크된 경우, 새 비밀번호로 업데이트
        await prefs.setString('password', newPassword);
      }

      // 필요시 다른 화면으로 이동
      Navigator.pop(context);
    } else {
      // 비밀번호 변경 실패 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호 변경에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  // 비밀번호 변경 다이얼로그 함수
  Future<dynamic> changePasswordDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: const Icon(
            Icons.question_mark_rounded,
            size: 40,
            color: Color(0xFF2A72E7),
          ),
          // 메인 타이틀
          title: const Column(
            children: [
              Text("정말 비밀번호 변경하실 건가요?"),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "실수일 수도 있으니까요",
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 20),
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 모달창 닫기
                    Navigator.pop(context);
                    // 비밀번호 변경 처리
                    _changePassword();
                  },
                  style: TextButton.styleFrom(
                    fixedSize: const Size(100, 20),
                  ),
                  child: const Text(
                    '변경',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2A72E7),
                    ),
                  ),
                ),
              ],
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
        toolbarHeight: 70,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 25.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '비밀번호 변경',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '현재 비밀번호',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF848488),
                ),
              ),
              const SizedBox(height: 7),

              // 현재 비밀번호 입력 필드
              TextFormField(
                controller: presentController, // TextEditingController로 설정
                obscureText: !isVisible3,
                style: const TextStyle(height: 1.5),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible3 = !isVisible3;
                      });
                    },
                    icon: Icon(
                      isVisible3 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '현재 비밀번호를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              const Text(
                '새 비밀번호',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF848488),
                ),
              ),
              const SizedBox(height: 7),

              // 비밀번호 입력 필드
              TextFormField(
                controller: newController,
                obscureText: !isVisible1,
                style: const TextStyle(height: 1.5),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible1 = !isVisible1;
                      });
                    },
                    icon: Icon(
                      isVisible1 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  if (value.length > 20) {
                    return '20자 이하로 작성해주세요';
                  }
                  if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[!@#\$&*~]).{1,}$')
                      .hasMatch(value)) {
                    return '영문자와 특수문자가 포함되어야 합니다';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),

              // 비밀번호 확인 필드
              TextFormField(
                controller: checkController,
                obscureText: !isVisible2,
                style: const TextStyle(height: 1.5),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible2 = !isVisible2;
                      });
                    },
                    icon: Icon(
                      isVisible2 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 다시 입력하세요';
                  }
                  if (value != newController.text) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 85),

              // 비밀번호 변경 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 유효성 검사가 완료될 시 모달 창을 띄움
                    if (formKey.currentState?.validate() ?? false) {
                      changePasswordDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A72E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fixedSize: const Size(300, 40),
                  ),
                  child: const Text(
                    '비밀번호 변경',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}
