import 'package:app/student_setting.dart';
import 'package:app/pages/complainpage.dart';
import 'package:app/pages/student_first_screen.dart';
import 'package:app/pages/querypage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String? emailAddress;
String? userRole;
String? userStatus;
List? item;
String? name;

class NavBar extends StatefulWidget {
  var email;
  var role;
  var name;
  var status;

  NavBar({
    super.key,
    required this.email,
    required this.role,
    required this.status,
  });

  @override
  State<NavBar> createState() {
    emailAddress = email;
    userRole = role;
    userStatus = status;
    print(email + " " + role);
    return _NavBar();
  }
}

class _NavBar extends State<NavBar> {
  String? email;
  String? role;
  String? status;
  // late List<Widget> pages;
  int currentIndex = 0;
  void onTapBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late List<Widget> pages = [
    HomePage(
      email: emailAddress.toString(),
      status: userStatus,
      items: [item],
      name: null,
    ),
    ComplainPage(email: emailAddress.toString()),
    LiveChatScreen(
        email_address: widget.email, role: widget.role, status: widget.status),
    ProfilePage(
      email_address: emailAddress.toString(),
      status: userStatus,
      role: userRole,
    ),
    // CreateProfile(
    //   email_address: emailAddress,
    //   contact_number: "",
    //   name: "",
    //   nic: "",
    //   picture_url: "",
    // )
    // role == "Student" ? const ProfilePage() : const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        onTap: onTapBar,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble), label: "Complain"),
          BottomNavigationBarItem(
              icon: Icon(Icons.support_agent), label: "Query"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), label: "Settings"),
        ],
        currentIndex: currentIndex,
        // onTap: onTap,
      ),
    );
  }
}
