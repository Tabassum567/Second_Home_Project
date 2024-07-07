import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';


import 'package:flutter/material.dart';
class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Text("Settings")
    );
  }
}