import 'package:app/pages/owner_setting.dart';
import 'package:flutter/material.dart';
import 'package:app/Dashboard.dart';
import 'package:app/owner_history_PostListing.dart';
import 'package:app/PropertyManagement.dart';
import 'package:app/UserSettings.dart';
import 'package:app/Search.dart';

// void main() {
//   runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: barNav()));
// }
var emailAddress;
var userStatus;

class barNav extends StatefulWidget {
  var email;

  var status;

  barNav({super.key, required this.email, required this.status});

  @override
  // ignore: no_logic_in_create_state
  State<barNav> createState() {
    emailAddress = email;
    userStatus = status;
    return _barNavState();
  }
}

class _barNavState extends State<barNav> {
  int currentTab = 0;
  final List<Widget> screens = [
    Dashboard(email_address: emailAddress, status: userStatus),
    MyHomePage(
      email: emailAddress,
    ),
    StudentRecordsScreen(
      email: emailAddress,
    ),
    const UserSettings(),
    const Search(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget CurentScreen = Dashboard(
    email_address: emailAddress,
    status: userStatus,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: CurentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        CurentScreen = Dashboard(
                          email_address: widget.email,
                          status: widget.status,
                        );
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: currentTab == 0 ? Colors.teal : Colors.grey,
                        ),
                        Text('Dashboard',
                            style: TextStyle(
                                color: currentTab == 0
                                    ? Colors.teal
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        CurentScreen = MyHomePage(
                          email: emailAddress,
                        );
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          color: currentTab == 1 ? Colors.teal : Colors.grey,
                        ),
                        Text('Post Listings',
                            style: TextStyle(
                                color: currentTab == 1
                                    ? Colors.teal
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        CurentScreen = StudentRecordsScreen(
                          email: emailAddress,
                        );
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.manage_history,
                          color: currentTab == 3 ? Colors.teal : Colors.grey,
                        ),
                        Text('Manage',
                            style: TextStyle(
                                color: currentTab == 3
                                    ? Colors.teal
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        CurentScreen = OwnerSetting(
                          email_address: widget.email,
                        );
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: currentTab == 4 ? Colors.teal : Colors.grey,
                        ),
                        Text('Settings',
                            style: TextStyle(
                                color: currentTab == 4
                                    ? Colors.teal
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
