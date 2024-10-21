import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/screens/myUserPage_screen.dart';
import 'package:frontend/screens/setExperience_screen.dart';
import 'package:frontend/services/login_services.dart';
import 'package:provider/provider.dart';

class ExperiencePage extends StatefulWidget {
  final List<ProjectExperience> experiences;
  final String name;
  String? category = '';

  ExperiencePage({
    required this.experiences,
    required this.name,
    this.category,
    super.key,
  });

  @override
  ExperiencePageState createState() => ExperiencePageState();
}

class ExperiencePageState extends State<ExperiencePage> {
  late List<bool> _isExpanded;

  String? name;

  @override
  void initState() {
    super.initState();
    _isExpanded = List<bool>.filled(widget.experiences.length, false);

    _loadCredentials();
  }

  // 사용자의 자격 증명을 불러오는 함수
  Future<void> _loadCredentials() async {
    final loginAPI = LoginAPI();
    final credentials = await loginAPI.loadCredentials();
    setState(() {
      name = credentials['name'] ?? ''; // 사용자의 이름
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            if (widget.category == 'recruit') {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyUserPage(),
                ),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 이름을 제목으로 설정하여 동적으로 표시
                Text(
                  '✨${widget.name}의 빛나는 경험✨',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Spacer(),
                Visibility(
                  visible: _isExpanded.contains(true),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _editSelectedExperience,
                        child: Container(
                          height: 20,
                          width: 78,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A72E7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text(
                              '경험 수정하기',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  if (widget.experiences.isEmpty)
                    Column(
                      children: [
                        const Center(
                          child: Text(
                            '프로젝트 경험이 없습니다', // 경험이 없을 때 표시할 문구
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        (widget.name == name)
                            ? GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SetExperiencePage(
                                        update: true,
                                        name: widget.name,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '경험 추가하기',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.experiences.length + 1,
                        itemBuilder: (context, index) {
                          // 마지막 항목에는 "경험 추가하기" 버튼을 배치
                          if (index == widget.experiences.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: (widget.name == name)
                                  ? GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SetExperiencePage(
                                              update: true,
                                              name: widget.name,
                                            ),
                                          ),
                                        );
                                        // final newExperiences = await Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => SetExperiencePage(
                                        //       update: true,
                                        //       name: widget.name,
                                        //     ),
                                        //   ),
                                        // );
                                        // // 새로운 경험 리스트가 추가된 경우 리스트에 반영
                                        // if (newExperiences != null &&
                                        //     newExperiences
                                        //         is List<ProjectExperience>) {
                                        //   setState(() {
                                        //     widget.experiences.addAll(newExperiences);
                                        //   });
                                        //   // 여러 개의 경험 추가 API 호출
                                        //   final provider = context
                                        //       .read<ProjectExperienceProvider>();
                                        //   await provider.createProjectExperiences(
                                        //       newExperiences);
                                        // }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '경험 추가하기',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            );
                          }
                          final experience = widget.experiences[index];
                          return Column(
                            children: [
                              ExpansionTile(
                                title: userInfo(
                                  title: '프로젝트명',
                                  titleSize: 20,
                                  info: experience.experienceName,
                                ),
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    _isExpanded[index] = expanded;
                                  });
                                },
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        userInfo(
                                          title: '나의 역할',
                                          titleSize: 18,
                                          info: experience.experienceRole,
                                        ),
                                        userInfo(
                                          title: '프로젝트 경험',
                                          titleSize: 18,
                                          info: experience.experienceContent,
                                        ),
                                        userInfo(
                                          title: '깃허브 프로젝트 링크',
                                          titleSize: 18,
                                          info: experience.experienceGithub,
                                        ),
                                        userInfo(
                                          title: '직무',
                                          titleSize: 18,
                                          info: experience.experienceJob,
                                        ),
                                        userInfo(
                                          title: '프로젝트 기간',
                                          titleSize: 18,
                                          info: experience.experienceDate,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 회원 정보 위젯
  Widget userInfo({
    required String title,
    required double titleSize,
    required String info,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            info,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF808080),
            ),
          ),
        ),
      ],
    );
  }

  // 선택한 경험 수정하는 메서드
  void _editSelectedExperience() {
    final selectedIndex = _isExpanded.indexWhere((expanded) => expanded);
    if (selectedIndex != -1) {
      final experience = context
          .read<ProjectExperienceProvider>()
          .projectExperiences[selectedIndex];
      _showEditExperienceDialog(context, experience, selectedIndex);
    }
  }

  // 경험 수정 다이얼로그
  void _showEditExperienceDialog(
      BuildContext context, ProjectExperience experience, int index) {
    final TextEditingController nameController =
        TextEditingController(text: experience.experienceName);
    final TextEditingController roleController =
        TextEditingController(text: experience.experienceRole);
    final TextEditingController contentController =
        TextEditingController(text: experience.experienceContent);
    final TextEditingController githubController =
        TextEditingController(text: experience.experienceGithub);
    final TextEditingController jobController =
        TextEditingController(text: experience.experienceJob);
    final TextEditingController dateController =
        TextEditingController(text: experience.experienceDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('경험 수정하기'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, '프로젝트명'),
                _buildTextField(roleController, '나의 역할'),
                _buildTextField(contentController, '프로젝트 경험'),
                _buildTextField(githubController, '깃허브 프로젝트 링크'),
                _buildTextField(jobController, '직무'),
                _buildTextField(dateController, '프로젝트 기간'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final updatedExperience = ProjectExperience(
                  id: experience.id,
                  experienceName: nameController.text,
                  experienceRole: roleController.text,
                  experienceContent: contentController.text,
                  experienceGithub: githubController.text,
                  experienceJob: jobController.text,
                  experienceDate: dateController.text,
                );

                Provider.of<ProjectExperienceProvider>(context, listen: false)
                    .updateProjectExperience(updatedExperience)
                    .then((_) {
                  setState(() {
                    widget.experiences[index] = updatedExperience;
                  });
                  Navigator.of(context).pop();
                });
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  // 텍스트 필드 생성 헬퍼 함수
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
