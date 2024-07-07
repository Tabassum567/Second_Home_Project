import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Image_file()));

class Image_file extends StatefulWidget {
  @override
  State<Image_file> createState() => _Image_fileState();
}

class _Image_fileState extends State<Image_file> {
  List<File> _pickedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _pickedImages.length,
              itemBuilder: (context, index) {
                return Image.file(_pickedImages[index], fit: BoxFit.cover);
              },
            ),
          ),
          ElevatedButton(
            child: Text("Add Images"),
            onPressed: _pickImages,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = (await picker.pickMultiImage());
    setState(() {
      _pickedImages = images as List<File>;
      print(images);
    });
  }
}
