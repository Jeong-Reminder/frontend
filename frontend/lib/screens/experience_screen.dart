import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:provider/provider.dart';

class ExperiencePage extends StatefulWidget {
  final List<ProjectExperience> experiences;
  final String name;

  const ExperiencePage({
    required this.experiences,
    required this.name,
    super.key,
  });

  @override
  ExperiencePageState createState() => ExperiencePageState();
}

class ExperiencePageState extends State<ExperiencePage> {
  late List<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = List<bool>.filled(widget.experiences.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                        onTap: () {
                          _editSelectedExperience();
                        },
                        child: Container(
                          height: 20,
                          width: 100,
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
              child: Consumer<ProjectExperienceProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.projectExperiences.length,
                    itemBuilder: (context, index) {
                      final experience = provider.projectExperiences[index];
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
                  );
                },
              ),
            ),
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
    // _isExpanded 리스트에서 확장된 타일의 인덱스 찾음
    final selectedIndex = _isExpanded.indexWhere((expanded) => expanded);
    // 확장된 타일이 있는 경우
    if (selectedIndex != -1) {
      // 해당 인덱스의 경험 데이터를 가져옴
      final experience = context
          .read<ProjectExperienceProvider>()
          .projectExperiences[selectedIndex];
      // 경험 수정 다이얼로그를 표시
      _showEditExperienceDialog(context, experience, selectedIndex);
    }
  }

  // 경험 수정 다이얼로그
  void _showEditExperienceDialog(
      BuildContext context, ProjectExperience experience, int index) {
    // 각 필드를 위한 TextEditingController를 생성하고, 초기값을 설정
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

    // 다이얼로그를 생성하고 표시
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('경험 수정하기'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 각각의 TextField를 생성하고 해당 컨트롤러와 라벨을 설정
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
                // 업데이트된 경험 데이터를 생성
                final updatedExperience = ProjectExperience(
                  id: experience.id, // 기존 ID 유지
                  experienceName: nameController.text,
                  experienceRole: roleController.text,
                  experienceContent: contentController.text,
                  experienceGithub: githubController.text,
                  experienceJob: jobController.text,
                  experienceDate: dateController.text,
                );

                // Provider를 사용하여 경험 데이터를 업데이트하고, UI를 갱신
                Provider.of<ProjectExperienceProvider>(context, listen: false)
                    .updateProjectExperience(updatedExperience)
                    .then((_) {
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

  // 텍스트 필드를 생성하는 헬퍼 함수
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
