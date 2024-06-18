import 'package:flutter/material.dart';

class changePWPage extends StatefulWidget {
  const changePWPage({super.key});

  @override
  State<changePWPage> createState() => _changePWPageState();
}

class _changePWPageState extends State<changePWPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController newController = TextEditingController();
    TextEditingController checkController = TextEditingController();

    String presentPW = 'alsxorrl1205!';

    final formKey = GlobalKey<FormState>();

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
                obscureText: true,
                style: const TextStyle(height: 1.5),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.visibility),
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

              // 비밀번호 확인 핃드
              TextFormField(
                controller: checkController,
                obscureText: true,
                style: const TextStyle(height: 1.5),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.visibility),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                ),
                validator: (value) {
                  // 새 비밀번호에서 작성한 비밀번호와 같지 않다면 에러 메세지 표시
                  if (checkController.text != newController.text) {
                    return '다시 입력해주세요';
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
                obscureText: true,
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
                  suffixIcon: const Icon(Icons.visibility),
                  suffixIconColor: const Color(0xFF848488),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                ),
              ),
              const SizedBox(height: 68),

              // 비밀번호 변경 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {},
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
