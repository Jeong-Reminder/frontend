import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';
import 'package:frontend/providers/projectExperience_provider.dart';
import 'package:frontend/screens/experience_screen.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final bool showSubTitle;
  final bool showExperienceButton;

  const Profile({
    required this.profileUrl,
    required this.name,
    required this.showSubTitle,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExperiencePage(
                                  experiences: experiences,
                                ),
                              ),
                            );
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
                    const Row(
                      children: [
                        Text('20190906'), // 학번 또는 다른 정보를 표시
                        SizedBox(width: 5),
                        CircleAvatar(
                          radius: 2,
                          backgroundColor: Color(0xFF808080),
                        ),
                        SizedBox(width: 5),
                        Text('재학생'),
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
