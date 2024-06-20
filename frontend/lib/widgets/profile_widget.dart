import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String profileUrl;
  final String name;
  final bool showSubTitle;
  const Profile(
      {required this.profileUrl,
      required this.name,
      required this.showSubTitle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFAFAFE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
        child: ListTile(
          leading: ClipRRect(
            child: Image.asset(profileUrl),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: showSubTitle
              ? const Row(
                  children: [
                    Text('20190906'),
                    SizedBox(width: 5),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: Color(0xFF808080),
                    ),
                    SizedBox(width: 5),
                    Text('재학생'),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
