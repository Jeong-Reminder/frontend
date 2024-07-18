import 'package:flutter/material.dart';
import 'package:frontend/models/projectExperience_model.dart';

class ExperiencePage extends StatelessWidget {
  final List<ProjectExperience> experiences;

  const ExperiencePage({required this.experiences, super.key});

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
            const Text(
              '✨소진수의 빛나는 경험✨',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  final experience = experiences[index];
                  return ExpansionTile(
                    title: userInfo(
                      title: '프로젝트명',
                      titleSize: 20,
                      info: experience.experienceName,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
  Widget userInfo(
      {required String title,
      required double titleSize,
      required String info}) {
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
}
