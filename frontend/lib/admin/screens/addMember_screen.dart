import 'package:flutter/material.dart';
import 'package:frontend/admin/models/admin_model.dart';
import 'package:frontend/admin/services/userInfo_service.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  int grade = 1; // 학년
  String status = '재학'; // 재적 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 109.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title('이름'),
            const SizedBox(height: 10),

            // 이름
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: '이름을 입력하세요',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 학번
            title('학번'),
            const SizedBox(height: 10),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                hintText: '학번을 입력하세요',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 학년
            title('학년'),
            const SizedBox(height: 10),
            toggleSwitch(
                switchCount: 4,
                labels: ['1학년', '2학년', '3학년', '4학년'],
                onToggle: (index) {
                  if (index != null) {
                    grade = index + 1;
                  }
                }),
            const SizedBox(height: 22),

            // 재적 상태
            title('재적상태'),
            const SizedBox(height: 10),
            toggleSwitch(
                switchCount: 2,
                labels: ['재학', '휴학'],
                onToggle: (index) {
                  if (index != null) {
                    status = index == 0 ? '재학' : '휴학';
                  }
                }),
            const SizedBox(height: 70),

            // 추가하기 버튼
            ElevatedButton(
              onPressed: () async {
                final user = Admin(
                  studentId: idController.text,
                  password: null,
                  name: nameController.text,
                  level: grade,
                  status: status,
                  userRole: 'ROLE_ADMIN',
                );

                try {
                  await UserService().createUser(user);
                  Navigator.pushNamed(context, '/user-info');
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원 추가 실패: $e')),
                  );
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
                '추가하기',
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
    );
  }

  // 타이틀 위젯
  Widget title(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }

  // 토글 스위치 위젯
  Widget toggleSwitch(
      {required int switchCount,
      required List<String> labels,
      required void Function(int?) onToggle}) {
    return ToggleSwitch(
      initialLabelIndex: 0,
      totalSwitches: switchCount,
      labels: labels,
      onToggle: onToggle,
      inactiveBgColor: Colors.white,
      inactiveFgColor: const Color(0xFF808080),
      activeBgColor: const [Color(0xFF2A72E7)],
      borderColor: const [Colors.black],
      borderWidth: 0.5,
      dividerColor: Colors.black,
      dividerMargin: 0,
      minWidth: MediaQuery.of(context).size.width,
    );
  }
}
