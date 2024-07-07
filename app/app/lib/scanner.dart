import 'dart:async';
import 'dart:io';
import 'package:app/preview_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the list of available cameras
  final cameras = await availableCameras();

  // Create a CameraController for the first camera in the list
  final cameraController =
      CameraController(cameras[0], ResolutionPreset.medium);

  // Initialize the camera controller
  await cameraController.initialize();

  runApp(MyApp(cameraController));
}

class MyApp extends StatelessWidget {
  final CameraController cameraController;

  const MyApp(this.cameraController);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Card Scanner',
      home: CameraScreen(cameraController),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;

  const CameraScreen(this.cameraController);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Start the camera preview
    _initializeControllerFuture = widget.cameraController.initialize();
    print(_initializeControllerFuture);
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    widget.cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID Card Scanner')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview
            return CameraPreview(widget.cameraController);
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          print('Camera button pressed');
          _captureImage();
        },
      ),
    );
  }

  void _captureImage() async {
    try {
      // Ensure that the camera is initialized before attempting to take a picture
      await _initializeControllerFuture;

      // Construct a filename for the new image
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath =
          join((await getTemporaryDirectory()).path, '$timestamp.png');

      // Take the picture and save it to disk
      final XFile picture = await widget.cameraController.takePicture();
      await File(picture.path).copy(filePath);
      print('Picture saved to $filePath');

      // Navigate to the preview screen, passing the image file path
      if (kIsWeb) {
        // Display the image directly on the web page
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Image.network('file://$filePath'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      } else {
        // Navigate to the preview screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(filePath),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error here, e.g. show an error message
    }
  }
}
