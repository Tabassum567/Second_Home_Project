import 'dart:convert';
import 'dart:io';
import 'package:app/createPofile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Image_file extends StatefulWidget {
  var email;

  Image_file({super.key, required this.email});

  @override
  State<Image_file> createState() => _Image_fileState();
}

class _Image_fileState extends State<Image_file> {
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  bool isVerified = false;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context, false);
            },
          ), // ... other AppBar properties
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.image_outlined,
              color: Colors.black,
              size: 50,
            ),
            SizedBox(
              height: 20,
              width: 20,
            ),
            // _pickedImage == null
            //     ? dotted_border()
            //     : kIsWeb
            //         ? Image.memory(
            //             webImage,
            //             fit: BoxFit.fill,
            //           )
            // : CircleAvatar(
            //     backgroundColor: Colors.black,
            //     radius: 10,
            //     child: CircleAvatar(
            //       backgroundImage: NetworkImage(_pickedImage!.path),
            //       radius: 70,
            //     ),
            //   ),
            SizedBox(
              height: 300,
              width: 300,
              child: _pickedImage == null
                  ? dotted_border()
                  : kIsWeb
                      ? Image.memory(
                          webImage,
                          fit: BoxFit.fill,
                        )
                      : Image.file(
                          _pickedImage!,
                          fit: BoxFit.fill,
                        ),
            ),
            // SizedBox(
            //   height: 100,
            //   width: 100,
            //   child: _pickedImage == null
            //       ? dotted_border()
            //       : kIsWeb
            //           ? Image.memory(
            //               webImage,
            //               fit: BoxFit.fill,
            //             )
            //           : Image.file(
            //               _pickedImage!,
            //               fit: BoxFit.fill,
            //             ),
            // ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    textStyle: const TextStyle(
                        fontSize: 15, fontStyle: FontStyle.italic)),
                child: Text(
                  "Upload Image",
                ),
                onPressed: () async {
                  Uint8List base64Data = webImage;
                  String image64 = base64.encode(base64Data);
                  uploadDocument(widget.email, image64).then((response) => {
                        if (response.statusCode == 200)
                          {print("Image Uploaded")}
                          
                        else
                          {print("Image Uploading Failed")}
                      });
                },
              ),
            ),
          ]),
        ));
  }

  Widget dotted_border() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300,
        width: 300,
        child: DottedBorder(
            strokeWidth: 3, //thickness of dash/dots
            dashPattern: [10, 6],
            borderType: BorderType.RRect,
            child: TextButton(
                onPressed: (() {
                  _pickImage();
                }),
                child: Center(
                  child: const Icon(
                    Icons.add,
                    color: Colors.teal,
                  ),
                ))),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print("No Image has been Picked");
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print("No image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }
}

Future uploadDocument(email, image) async {
  var response =
      await http.post(Uri.parse("http://localhost:5000/documents"), body: {
    "emailAddress": email,
    "image": image,
  });
  return response;
}
