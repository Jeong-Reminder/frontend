import 'package:flutter/material.dart';

class HiddenPage extends StatefulWidget {
  final List<Map<String, dynamic>> hiddenList;
  const HiddenPage({required this.hiddenList, super.key});

  @override
  State<HiddenPage> createState() => _HiddenPageState();
}

class _HiddenPageState extends State<HiddenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 스크롤 시 상단바 색상 바뀌는 오류
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/images/logo.png'),
            color: Colors.black,
          ),
        ),
        leadingWidth: 120,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.add_alert,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '숨김 목록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: widget.hiddenList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        color: const Color(0xFFFAFAFE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 0.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 18.0),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.hiddenList[index]['title'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Text(
                                widget.hiddenList[index]['subtitle'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                widget.hiddenList[index]['content'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7D7D7F),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero, // 패딩 설정
                                    constraints: const BoxConstraints(),
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Color(0xFFEA4E44),
                                    ),
                                  ),
                                  const Text(
                                    '4',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
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
}
