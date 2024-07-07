import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.file(File(imagePath)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => Navigator.pop(context, imagePath),
      ),
    );
  }
}
