import 'package:flutter/material.dart';

class ChangePWPage extends StatefulWidget {
  const ChangePWPage({super.key});

  @override
  State<ChangePWPage> createState() => _ChangePWPageState();
}

class _ChangePWPageState extends State<ChangePWPage> {
  final TextEditingController newController = TextEditingController();
  final TextEditingController checkController = TextEditingController();

  String presentPW = 'alsxorrl1205!';
  bool isVisible1 = false;
  bool isVisible2 = false;
  bool isVisible3 = false;

  final formKey = GlobalKey<FormState>();

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
                obscureText: !isVisible1, // !isVisible1 = false
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
                        isVisible1 ? Icons.visibility_off : Icons.visibility),
                  ),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
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
                        isVisible2 ? Icons.visibility_off : Icons.visibility),
                  ),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                ),
                validator: (value) {
                  // 새 비밀번호에서 작성한 비밀번호와 같지 않다면 에러 메시지 표시
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
              const SizedBox(height: 35),
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
                obscureText: !isVisible3,
                initialValue: presentPW,
                readOnly: true, // 읽기 전용
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
                        isVisible3 ? Icons.visibility_off : Icons.visibility),
                  ),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                ),
              ),
              const SizedBox(height: 68),

              // 비밀번호 변경 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 유효성 검사가 완료될 시 변경 다이얼로그 표시
                    if (formKey.currentState?.validate() ?? false) {
                      changePWDialog(context);

                      Navigator.pop(context);
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

  // 비밀번호 변경 다이엉로그
  Future<dynamic> changePWDialog(BuildContext context) {
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
              Text("이대로 변경하시겠습니까?"),
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
                    Navigator.pop(context);
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
}
