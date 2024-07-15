import 'package:flutter/material.dart';
import 'package:frontend/screens/settingProFile1_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/login_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  final LoginAPI loginAPI = LoginAPI(); // API 객체 생성

  bool isAutoLogin = false;
  bool pwInvisible = true; // 비밀번호 숨김 기본값 true

  final formKey = GlobalKey<FormState>(); // 폼 유효성을 검사하는데 사용

  @override
  void initState() {
    super.initState();
    _autoLogin(); // 자동 로그인 시도
  }

  // 저장된 학번과 비밀번호 불러오기
  Future<void> _loadCredentials() async {
    final credentials = await loginAPI.loadCredentials();
    final studentId = credentials['studentId'];
    final password = credentials['password'];
    final autoLogin = credentials['isAutoLogin'];

    if (studentId != null && password != null && autoLogin) {
      setState(() {
        idController.text = studentId;
        pwController.text = password;
        isAutoLogin = autoLogin;
      });
    }
  }

  // 자동 로그인 시 페이지 이동 적용
  Future<void> _autoLogin() async {
    await _loadCredentials();
    final isAutoLoggedIn = await loginAPI.autoLogin();

    if (isAutoLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingProfile1Page(),
        ),
      );
    }
  }

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

              // 학번 텍스트폼필드
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: '학번',
                        labelStyle: TextStyle(fontSize: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '학번을 입력하세요';
                        }
                        if (value.length < 4 || value.length > 10) {
                          return '4자 이상 10자 이하로 작성해주세요';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 12),

                    // 비밀번호 텍스트폼필드
                    TextFormField(
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                      obscureText: pwInvisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        }
                        if (value.length < 4 && value.length > 15) {
                          return '4자 이상 15자 이하로 작성해주세요';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onChanged: (value) async {
                          setState(() {
                            isAutoLogin = value!;
                          });
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isAutoLogin', isAutoLogin);
                          if (!isAutoLogin) {
                            await prefs.remove('studentId');
                            await prefs.remove('password');
                          }
                        },
                        activeColor: const Color(0xFF2A72E7),
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
                ],
              ),
              const SizedBox(height: 27),

              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  // 유효성 통과 시 홈 화면으로 이동
                  if (formKey.currentState!.validate()) {
                    String studentId = idController.text;
                    String password = pwController.text;
                    loginAPI
                        .handleLogin(studentId, password)
                        .then((result) async {
                      if (result['success']) {
                        final prefs = await SharedPreferences.getInstance();
                        if (isAutoLogin) {
                          // 자동 로그인 체크 시에만 학번과 비밀번호 저장
                          await prefs.setString('studentId', studentId);
                          await prefs.setString('password', password);
                        }
                        // userRole 값에 따라 다른 페이지로 이동
                        if (result['role'] == 'ROLE_ADMIN') {
                          Navigator.pushNamed(context, '/user-info');
                        } else if (result['role'] == 'ROLE_USER') {
                          Navigator.pushNamed(context, '/setting-profile');
                        }
                      } else {
                        // 로그인 실패 처리
                      }
                    });
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
}
