import 'package:flutter/material.dart';
import 'package:frontend/widgets/badge_widget.dart';
import 'package:frontend/widgets/tool_list.dart';

class EditToolPage extends StatefulWidget {
  const EditToolPage({super.key});

  @override
  State<EditToolPage> createState() => _EditToolPageState();
}

class _EditToolPageState extends State<EditToolPage> {
  List<Map<String, dynamic>> selectedTools = []; // 선택된 Tools 리스트
  String developmentTool = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Development Tool Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '2. DEVELOPMENT TOOLS 선택',
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
              children: toolsList.map((tools) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tools['isSelected'] = !tools['isSelected'];
                      if (tools['isSelected']) {
                        selectedTools.add(tools);
                      } else {
                        selectedTools.remove(tools);
                      }
                    });
                    print('${tools['title']} : ${tools['isSelected']}');
                  },
                  child: DevelopmentBadge(
                    logoUrl: tools['logoUrl'],
                    title: tools['title'],
                    titleColor: tools['titleColor'],
                    badgeColor: tools['badgeColor'],
                    isSelected: tools['isSelected'],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: selectedTools.isNotEmpty,
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
                      children: selectedTools.map((tools) {
                        return DevelopmentBadge(
                          logoUrl: tools['logoUrl'],
                          title: tools['title'],
                          titleColor: tools['titleColor'],
                          badgeColor: tools['badgeColor'],
                          isSelected: tools['isSelected'],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // 선택된 툴을 보여주도록 작성
                    setState(() {
                      developmentTool = selectedTools
                          .map((f) => f['title'])
                          .toList()
                          .join(',');
                    });
                    print('선택된 툴: $developmentTool');
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
