import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: confirmPrompt()));
}

class confirmPrompt extends StatefulWidget {
  const confirmPrompt({super.key});

  @override
  State<confirmPrompt> createState() => _confirmPromptState();
}

class _confirmPromptState extends State<confirmPrompt> {
  void showAlert() {
    QuickAlert.show(
      context: context,
      text: "Are you sure to proceed with the payment",
      type: QuickAlertType.success,
      onConfirmBtnTap: () {
        print("Ok");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showAlert();
            },
            child: Text("Confirmation Alert"),
          )
        ],
      )),
    );
  }
}
