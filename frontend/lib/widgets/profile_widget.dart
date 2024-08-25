import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/screens/experience_screen.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final String status;
  final bool showSubTitle;
  final bool showExperienceButton;
  final String studentId;

  const Profile({
    required this.profileUrl,
    required this.name,
    required this.status,
    required this.showSubTitle,
    required this.studentId,
    this.showExperienceButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final projectExperienceProvider =
        Provider.of<ProjectExperienceProvider>(context, listen: false);

    return Card(
      color: const Color(0xFFFAFAFE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0), // 프로필 이미지 둥글게
              child: Image.asset(
                profileUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (showExperienceButton)
                        GestureDetector(
                          onTap: () async {
                            // 프로젝트 경험 데이터를 가져옴
                            await projectExperienceProvider.fetchExperiences();
                            // 가져온 프로젝트 경험 데이터를 리스트로 저장
                            List<ProjectExperience> experiences =
                                projectExperienceProvider.projectExperiences;

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExperiencePage(
                                    experiences: experiences,
                                    name: name,
                                  ),
                                ),
                              );
                            }
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
                                '내 경험 보러가기',
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
                  if (showSubTitle)
                    Row(
                      children: [
                        Text(studentId), // 학번 표시
                        const SizedBox(width: 5),
                        const CircleAvatar(
                          radius: 2,
                          backgroundColor: Color(0xFF808080),
                        ),
                        const SizedBox(width: 5),
                        Text(status), // 상태 표시
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
