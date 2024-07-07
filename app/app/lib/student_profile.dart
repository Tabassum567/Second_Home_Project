import 'dart:convert';

import 'package:app/FAQ.dart';
import 'package:app/TC.dart';
import 'package:app/createPofile.dart';
import 'package:app/login_page_1.dart';
import 'package:app/pages/booking_history1.dart';
import 'package:app/pages/student_first_screen.dart';
import 'package:app/pages/student_navbar.dart';
import 'package:app/privacy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var _name;
var _contact_number;
var _nic;
var _picture;
var role_param;

class Profile extends StatefulWidget {
  var email_address;

  var status;

  var icon;

  var title;

  var name;

  var contact_number;

  var nic;

  var picture;

  var role_param;

  Profile(
      {super.key,
      required this.name,
      required this.contact_number,
      required this.nic,
      required this.picture,
      required this.role_param,
      required this.email_address,
      required this.status,
      required this.icon,
      required this.title});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var email_address;

  var status;

  getData(email_address) async {
    try {
      final response = await http.get(
          Uri.parse("http://localhost:5000/fetchCustomer/${email_address}"));
      print(json.decode(response.body)["customer"]);
      setState(() {
        _name = json.decode(response.body)["customer"]["username"];
        _nic = json.decode(response.body)["customer"]["cnic"];
        _picture = json.decode(response.body)["customer"]["picture_public_url"];
        print(_picture);
        _contact_number =
            json.decode(response.body)["customer"]["contact_number"];
      });

      print("object");
    } catch (e) {
      print("====> $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.email_address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(
              widget.icon,
              color: Colors.grey.withOpacity(0.9),
              size: 22,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ]),
          GestureDetector(
            onTap: () {
              if (widget.title == 'Home') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NavBar(
                              email: email_address,
                              role: role_param ?? 'student',
                              status: status,
                            )));
              } else if (widget.title == 'Create Profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateProfile(
                              contact_number: _contact_number,
                              email_address: widget.email_address,
                              name: _name,
                              nic: _nic,
                              picture_url: _picture,
                              status: status,
                            )));
              } else if (widget.title == 'Privacy Policy') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()));
              } else if (widget.title == 'Terms & Conditions') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TermsConditionsScreen()));
              } else if (widget.title == 'FAQs') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FAQScreen()));
              } else if (widget.title == 'History') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            BookingHistory(email_address: email_address)));
                // Add code to navigate to PrivacyPolicyScreen
              } else if (widget.title == 'Logout') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Login()));
                // Add code to navigate to PrivacyPolicyScreen
              }

              // Add your code here to handle the tap event
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.withOpacity(0.9),
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
