import 'dart:io';
import 'package:flutter/material.dart';

class DownloadImagePage extends StatelessWidget {
  final File imageFile;
  final int imageLength;
  final int index;
  final String imageUrl;
  final String imageName;
  const DownloadImagePage(
      {required this.imageFile,
      required this.imageLength,
      required this.index,
      required this.imageUrl,
      required this.imageName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          '$index/$imageLength',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: const [
          // IconButton(
          //   onPressed: () async {

          //     final announcementProvider =
          //         Provider.of<AnnouncementProvider>(context, listen: false);

          //     await announcementProvider.downloadFile(
          //         imageUrl, imageName, 'image');
          //   },
          //   icon: const Icon(
          //     Icons.download_sharp,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Hero(
            tag: 'image_$index',
            child: Image.file(
              imageFile,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 채움
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('이미지를 불러올 수 없습니다.');
              },
            ),
          ),
        ),
      ),
    );
  }
}
