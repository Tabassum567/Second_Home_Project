import 'package:app/FAQ.dart';
import 'package:app/TC.dart';
import 'package:app/login_page_1.dart';
import 'package:app/owner_homescree.dart';
import 'package:app/privacy.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final IconData icon;
  final String title;

  var email_address;

  var status;
  Profile({
    Key? key,
    required this.icon,
    required this.title,
    required this.email_address,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
              icon,
              color: Colors.grey.withOpacity(0.9),
              size: 22,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ]),
          GestureDetector(
            onTap: () {
              if (title == 'Home') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => barNav(
                              email: email_address,
                              status: status,
                            )));
              } else if (title == 'Create Profile') {
                // Add code to navigate to CreateProfileScreen
              } else if (title == 'Privacy Policy') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()));
              } else if (title == 'Terms & Conditions') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TermsConditionsScreen()));
              } else if (title == 'FAQs') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FAQScreen()));
                // Add code to navigate to PrivacyPolicyScreen
              } else if (title == 'Logout') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Login()));
                // Add code to navigate to PrivacyPolicyScreen
              }
              // Add your code here to handle the tap event
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.withOpacity(0.9),
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
