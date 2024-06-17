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
              SizedBox(
                height: 50,
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
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: pwController,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    labelStyle: TextStyle(fontSize: 14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

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
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('아이디'),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('비밀번호'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
