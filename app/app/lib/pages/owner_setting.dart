import 'package:app/owner_homescree.dart';
import 'package:flutter/material.dart';
import 'owner_setting_profile.dart';

class OwnerSetting extends StatefulWidget {
  var email_address;
  var username;

  var status;

  OwnerSetting(
      {super.key, required this.email_address, this.username, this.status});

  @override
  State<OwnerSetting> createState() => _OwnerSettingState();
}

class _OwnerSettingState extends State<OwnerSetting> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,

                // ignore: sort_child_properties_last
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 60,
                  backgroundImage: ExactAssetImage('1662135955026.jpg'),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 5,
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    widget.username ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 22,
                    child: Image.asset('verified.png'),
                  ),
                ]),
              ),
              Text(
                widget.email_address,
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ignore: avoid_unnecessary_containers
                    Profile(
                        icon: Icons.home,
                        title: 'Home',
                        email_address: widget.email_address,
                        status: widget.status),
                    // Profile(
                    //   icon: Icons.person,
                    //   title: ' Create Profile',
                    //   email_address: widget.email_address,
                    // ),
                    Profile(
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        email_address: widget.email_address,
                        status: widget.status),
                    Profile(
                        icon: Icons.policy,
                        title: 'Terms and Conditions',
                        email_address: widget.email_address,
                        status: widget.status),
                    Profile(
                        icon: Icons.chat,
                        title: 'FAQs',
                        email_address: widget.email_address,
                        status: widget.status),

                    Profile(
                        icon: Icons.logout,
                        title: 'Logout',
                        email_address: widget.email_address,
                        status: widget.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
