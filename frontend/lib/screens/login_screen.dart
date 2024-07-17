import 'package:flutter/material.dart';
import 'package:frontend/services/login_services.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  bool isAutoLogin = false;
  bool pwInvisible = true; // 비밀번호 숨김 기본값 true
  late PersistCookieJar cookieJar; // 쿠키를 관리할 객체

  final formKey = GlobalKey<FormState>(); // 폼 유효성을 검사하는데 사용

  // 토큰 재발급을 위한 서버 주소 상수
  static const tokenRefreshAddress =
      'https://reminder.sungkyul.ac.kr/api/v1/reissue';

  @override
  void initState() {
    super.initState();
    _initCookieJar(); // 초기화 함수 호출
    _autoLogin(); // 자동 로그인 시도
  }

  // refreshToken 추출 메서드
  String? extractRefreshToken(String setCookieHeader) {
    final regex = RegExp(r'refresh=([^;]+)');
    final match = regex.firstMatch(setCookieHeader);
    return match?.group(1);
  }

  // 쿠키 관리를 위한 초기화 함수
  Future<void> _initCookieJar() async {
    final appDocDir =
        await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리 경로 가져오기
    final appDocPath = appDocDir.path; // 디렉토리 경로 저장
    print('쿠키 저장 경로: $appDocPath/.cookies/'); // 디버그 출력
    cookieJar = PersistCookieJar(
      storage: FileStorage('$appDocPath/.cookies/'), // 파일 저장소로 쿠키 저장
    );
  }

  // 저장된 학번과 비밀번호 불러오기
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('studentId');
    final password = prefs.getString('password');
    final autoLogin = prefs.getBool('isAutoLogin') ?? false;

    if (studentId != null && password != null && autoLogin) {
      setState(() {
        idController.text = studentId;
        pwController.text = password;
        isAutoLogin = autoLogin;
      });
    }
  }

  // 자동 로그인 시도 함수
  Future<void> _autoLogin() async {
    await _loadCredentials();
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final studentId = prefs.getString('studentId');
    final password = prefs.getString('password');

    if (accessToken != null && studentId != null && password != null) {
      final isExpired = JwtDecoder.isExpired(accessToken);
      if (isExpired) {
        await againToken(); // 토큰 재발급 시도
      } else {
        print('유효한 토큰이 존재합니다.');
        final userRole = prefs.getString('userRole');
        if (userRole != null) {
          _navigateBasedOnRole(userRole);
        }
      }
    }
  }

  // 역할에 따라 페이지로 이동하는 함수
  void _navigateBasedOnRole(String role) {
    if (role == 'ROLE_ADMIN') {
      Navigator.pushReplacementNamed(context, '/user-info');
    } else if (role == 'ROLE_USER') {
      Navigator.pushReplacementNamed(context, '/homepage');
    }
  }

  // 이전 토큰 삭제 함수
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await cookieJar.deleteAll(); // 쿠키 삭제
  }

  // 토큰 재발급 API(자동 로그인 체크 시)
  Future<void> againToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken') ?? '';

      if (refreshToken.isEmpty) {
        print('invalid refresh token');
        return;
      }

      final url = Uri.parse(tokenRefreshAddress);
      final cookieHeader = 'refresh=$refreshToken';

      final response = await http.post(url, headers: {
        'Cookie': cookieHeader,
      });

      print('토큰 재발급 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final newAccessToken = response.headers['access'];
        final setCookieHeader = response.headers['set-cookie'];
        print('새로운 엑세스 토큰 $newAccessToken');

        final newRefreshToken = setCookieHeader != null
            ? extractRefreshToken(setCookieHeader)
            : null;
        print('새로운 리프래시 토큰 $newRefreshToken');

        if (newAccessToken != null && newRefreshToken != null) {
          await clearTokens();

          await prefs.setString('accessToken', newAccessToken);
          await prefs.setString('refreshToken', newRefreshToken);

          final uri = Uri.parse(tokenRefreshAddress);
          cookieJar.saveFromResponse(uri, [Cookie('refresh', newRefreshToken)]);
        } else {
          print('응답 데이터에 토큰이 없습니다');
        }

        print('토큰 재발급 성공!');
        // 토큰 재발급 성공 시 역할에 따라 페이지로 이동
        final userRole = prefs.getString('userRole');
        if (userRole != null) {
          _navigateBasedOnRole(userRole);
        }
      } else {
        print('토큰 재발급 실패: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('토큰 재발급 요청 중 에러 발생: ${e.toString()}');
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

              ElevatedButton(
                onPressed: () {
                  // 유효성 통과 시 홈 화면으로 이동
                  if (formKey.currentState!.validate()) {
                    String studentId = idController.text;
                    String password = pwController.text;
                    LoginAPI()
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
                          // techStack 값이 null이거나 값이 비어있는 경우
                          if (result['techStack'] == null ||
                              result['techStack'].isEmpty) {
                            Navigator.pushNamed(context, '/setting-profile');
                            // memberExperience 값이 null이거나 값이 비어있는 경우
                          } else if (result['memberExperiences'] == null ||
                              result['memberExperiences'].isEmpty) {
                            Navigator.pushNamed(context, '/member-experience');
                          } else {
                            // techStack, memberExperiences 값이 둘 다 채워진 경우
                            Navigator.pushNamed(context, '/homepage');
                          }
                        }
                        // userRole 저장
                        await prefs.setString('userRole', result['role']);
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
