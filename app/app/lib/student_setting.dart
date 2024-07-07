import 'dart:convert';

import 'package:app/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var _name;
var _contact_number;
var _nic;
var _picture;
var role_param;

getData(email_address) async {
  try {
    final response = await http
        .get(Uri.parse("http://localhost:5000/fetchCustomer/${email_address}"));
    print(json.decode(response.body)["customer"]);

    _name = json.decode(response.body)["customer"]["username"];
    _nic = json.decode(response.body)["customer"]["cnic"];
    _picture = json.decode(response.body)["customer"]["picture_public_url"];

    _contact_number = json.decode(response.body)["customer"]["contact_number"];

    print("object");
  } catch (e) {
    print("====> $e");
  }
}

class ProfilePage extends StatefulWidget {
  var email_address;

  var status;

  var role;

  ProfilePage(
      {super.key,
      required this.email_address,
      required this.status,
      required this.role});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  getData(email_address) async {
    try {
      final response = await http.get(
          Uri.parse("http://localhost:5000/fetchCustomer/${email_address}"));
      print(json.decode(response.body)["customer"]);
      setState(() {
        _name = json.decode(response.body)["customer"]["username"];
        _nic = json.decode(response.body)["customer"]["cnic"];
        _picture = json.decode(response.body)["customer"]["picture_public_url"];
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
                    _name ?? "",
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
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
                    Profile(
                      icon: Icons.person,
                      title: 'Create Profile',
                      email_address: widget.email_address,
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
                    Profile(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      email_address: widget.email_address,
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
                    Profile(
                      icon: Icons.policy,
                      title: 'Terms and Conditions',
                      email_address: widget.email_address,
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
                    Profile(
                      icon: Icons.chat,
                      title: 'FAQs',
                      email_address: widget.email_address,
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
                    Profile(
                      icon: Icons.history,
                      title: 'History',
                      email_address: widget.email_address,
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
                    Profile(
                      icon: Icons.logout,
                      title: 'Logout',
                      email_address: widget.email_address,
                      status: widget.status,
                      name: _name,
                      contact_number: _contact_number,
                      nic: _nic,
                      picture: _picture,
                      role_param: widget.role,
                    ),
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
