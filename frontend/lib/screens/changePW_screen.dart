import 'package:flutter/material.dart';

class changePWPage extends StatelessWidget {
  const changePWPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController newController = TextEditingController();
    TextEditingController presentController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '비밀번호 변경',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '새 비밀번호',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF848488),
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              height: 35,
              child: TextFormField(
                controller: newController,
                obscureText: true,
                style: const TextStyle(height: 1.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.visibility),
                  suffixIconColor: const Color(0xFF848488),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 35,
              child: TextFormField(
                controller: newController,
                obscureText: true,
                style: const TextStyle(height: 1.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.visibility),
                  suffixIconColor: const Color(0xFF848488),
                ),
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              '현재 비밀번호',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF848488),
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              height: 35,
              child: TextFormField(
                obscureText: true,
                controller: presentController,
                style: const TextStyle(height: 1.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFEFF2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.visibility),
                  suffixIconColor: const Color(0xFF848488),
                ),
              ),
            ),
            const SizedBox(height: 68),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A72E7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fixedSize: const Size(300, 40),
                ),
                child: const Text(
                  '비밀번호 변경',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
