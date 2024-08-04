import 'package:flutter/material.dart';

import 'package:frontend/widgets/badge_widget.dart';
import 'package:frontend/widgets/field_list.dart';

class EditFieldPage extends StatefulWidget {
  const EditFieldPage({super.key});

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  List<Map<String, dynamic>> selectedFields = []; // 선택된 Field 리스트
  String developmentField = '';

  @override
  void initState() {
    super.initState();
    _resetIsSelected();
  }

  void _resetIsSelected() {
    for (var field in fieldList) {
      field['isSelected'] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Development Field 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEVELOPMENT FIELD 선택',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 10,
              children: fieldList.map((field) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      field['isSelected'] = !field['isSelected'];
                      if (field['isSelected']) {
                        selectedFields.add(field);
                      } else {
                        selectedFields.remove(field);
                      }
                    });
                    print('${field['title']} : ${field['isSelected']}');
                  },
                  child: DevelopmentBadge(
                    logoUrl: field['logoUrl'],
                    title: field['title'],
                    titleColor: field['titleColor'],
                    badgeColor: field['badgeColor'],
                    isSelected: field['isSelected'],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: selectedFields.isNotEmpty,
        child: BottomSheet(
          onClosing: () {},
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height / 3.6,
          ),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          builder: (context) {
            return Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: 400,
                    height: 160,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F6F6),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedFields.map((stack) {
                        return DevelopmentBadge(
                          logoUrl: stack['logoUrl'],
                          title: stack['title'],
                          titleColor: stack['titleColor'],
                          badgeColor: stack['badgeColor'],
                          isSelected: stack['isSelected'],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    // 선택된 필드를 보여주도록 작성
                    setState(() {
                      if (selectedFields.isNotEmpty) {
                        developmentField = selectedFields
                            .map((f) => f['title'])
                            .toList()
                            .join(',');
                      }
                    });

                    print('선택된 필드: $developmentField');

                    if (context.mounted) {
                      // 변경된 developmentField를 이전 페이지로 전달하면서 이동
                      Navigator.pop(context, developmentField);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color(0xFF2A72E7),
                    minimumSize: const Size(319, 46),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
