import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  bool isAutoLogin = false;
  bool pwInvisible = false; // 비밀번호 숨김
  final formKey = GlobalKey<FormState>(); // 폼 유효성을 검사하는데 사용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/sungkyul.png'),
                  Row(
                    children: [
                      Text(
                        '지금',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '알리미',
                        style: TextStyle(
                          color: Color(0xFF2A72E7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '시작해보세요!',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 아이디 텍스트폼필드
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 65,
                      child: TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: '아이디',
                          labelStyle: TextStyle(fontSize: 14.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력하세요';
                          }
                          if (value.length < 4 || value.length > 10) {
                            return '4자 이상 10자 이하로 작성해주세요';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 비밀번호 텍스트폼필드
                    SizedBox(
                      height: 65,
                      child: TextFormField(
                        controller: pwController,
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          labelStyle: const TextStyle(fontSize: 14.0),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                pwInvisible = !pwInvisible;
                              });
                            },
                            icon: Icon(pwInvisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        obscureText: pwInvisible ? true : false,
                        // validator : 유효성 검사
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력하세요';
                          }
                          if (value.length > 10) {
                            return '10자 이하로 작성해주세요';
                          }
                          if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[!@#\$&*~]).{1,}$')
                              .hasMatch(value)) {
                            return '영문자와 특수문자가 포함되어야 합니다';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 자동 로그인
                  Row(
                    children: [
                      Checkbox(
                        value: isAutoLogin,
                        onChanged: (value) {
                          setState(() {
                            isAutoLogin = !isAutoLogin;
                          });
                        },
                        activeColor: const Color(0xFF2A72E7), // 체크 시 배경색
                        // 기본 패딩 없애기
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '자동 로그인',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ],
                  ),

                  // 아이디 / 비밀번호 찾기
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        idAndPwTextBtn('아이디'),
                        const VerticalDivider(
                          color: Color(0xFF808080),
                          thickness: 2,
                        ),
                        idAndPwTextBtn('비밀번호'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 27),

              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  // 유효성 통과 시 홈 화면으로 이동
                  if (formKey.currentState!.validate()) {
                    // 홈 화면 이동
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A72E7),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 아이디 / 비밀번호 찾기 텍스트 버튼
  Widget idAndPwTextBtn(String title) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF808080),
        ),
      ),
    );
  }
}
