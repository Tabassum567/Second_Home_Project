import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // routes: {'/shape': (context) => const Shape()},
    home: ImagePickerPage()));

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<Uint8List> _images = [];

  Future<void> _selectImages() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null && result.count <= 4) {
      List<Uint8List> selectedImages = [];

      for (var file in result.files) {
        Uint8List? bytes;
        if (file.bytes != null) {
          // On web, use the bytes property to display images.
          bytes = file.bytes!;
        } else {
          // On mobile, read the file as bytes to display images.
          File platformFile = File(file.path!);
          bytes = await platformFile.readAsBytes();
        }
        selectedImages.add(bytes);
      }

      setState(() {
        _images = selectedImages;
      });
    } else {
      // Snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Image Picker"),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            // ElevatedButton(
            //   onPressed: _selectImages,
            //   child: Text("Select Multiple Images"),
            // ),
            TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(
                      fontSize: 15, fontStyle: FontStyle.italic)),
              child: const Text(
                "Upload Multiple Images",
              ),
              onPressed: () {
                _selectImages();
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: _images
                    .map((imageBytes) => Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.teal,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          child: Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
