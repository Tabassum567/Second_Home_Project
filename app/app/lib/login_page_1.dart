import 'dart:convert';
import 'dart:js';

import 'package:app/chat_screen.dart';
import 'package:app/owner_homescree.dart';
import 'package:app/pages/student_navbar.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
//import 'package:secondhome/home.dart';
import 'package:app/pages/student_first_screen.dart';
import 'shape.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:rflutter_alert/rflutter_alert.dart';

String? email_param;
String? role_param;
String? status;
void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/navbar': (context) => NavBar(
            email: email_param,
            role: role_param,
            status: status,
          ),
    },
    home: Login()));

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isHidden = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validate() {
    if (formKey.currentState!.validate()) {
      print("OK");
    } else {
      print("Error");
    }
  }

  void updateStatus() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool isSignupScreen = true;
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController(text: "a@gmail.com");
  final password = TextEditingController(text: "12345");
  final username = TextEditingController();
  final contact_number = TextEditingController();
  final cnic = TextEditingController();
  bool _isStudent = false;
  bool _isOwner = false;
  String _status = "";
  String role = "";
  // regular expression to check if stri  ng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      SizedBox(
        height: 250,
        child: const Shape(),
      ),
      Form(
          key: formKey,
          child: Stack(alignment: Alignment.center, children: [
            Column(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.bounceInOut,
                  top: isSignupScreen ? 200 : 230,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.bounceInOut,
                    height: isSignupScreen ? 470 : 250,
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width - 40,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5),
                        ]),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: !isSignupScreen
                                              ? const Color.fromARGB(
                                                  255, 9, 18, 108)
                                              : const Color.fromARGB(
                                                  255, 167, 188, 199)),
                                    ),
                                    if (!isSignupScreen)
                                      Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: Colors.teal,
                                      )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = true;
                                  });
                                },
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "SIGNUP",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignupScreen
                                              ? const Color.fromARGB(
                                                  255, 9, 18, 108)
                                              : const Color.fromARGB(
                                                  255, 167, 188, 199)),
                                    ),
                                    if (isSignupScreen)
                                      Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: Colors.teal,
                                      )
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (isSignupScreen) signup(),
                          if (!isSignupScreen) login(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]))
    ]));
  }

  Container signup() {
    return Container(
        height: MediaQuery.of(this.context).size.height,
        margin: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: Icon(Icons.person),
                  hintText: 'Full Name',
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                ]),
                controller: username,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: Icon(Icons.mail),
                  hintText: 'Email',
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  EmailValidator(errorText: " Not valid")
                ]),
                controller: email,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: Icon(Icons.phone),
                  hintText: 'Contact-Number',
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  MaxLengthValidator(11, errorText: "11 required"),
                  PatternValidator(r'^(?:[+0][1-9])?[0-9]{10,12}$',
                      errorText: 'error'),
                ]),
                controller: contact_number,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.card_membership),
                  hintText: 'CNIC',
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  MinLengthValidator(13, errorText: "13 required"),
                ]),
                controller: cnic,
              ),
              TextFormField(
                obscureText: _isHidden ? false : true,
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: const Icon(Icons.lock),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => updateStatus(),
                    icon: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  MinLengthValidator(5, errorText: "More than 5 reuired"),
                ]),
                controller: password,
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Color.fromARGB(255, 0, 150, 136),
                    value: _isStudent,
                    onChanged: (value) {
                      setState(() {
                        _isStudent = value!;
                        _isOwner = !value;
                        if (_isStudent) {
                          role = "Student";
                        } else {
                          role = "Owner";
                        }
                      });
                    },
                  ),
                  const Text(
                    'Student',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  Checkbox(
                    value: _isOwner,
                    // checkColor: Colors.white,
                    activeColor: Color.fromARGB(255, 0, 150, 136),
                    onChanged: (value) {
                      setState(() {
                        _isOwner = value!;
                        _isStudent = !value;
                        if (_isStudent) {
                          role = "Student";
                        } else {
                          role = "Owner";
                        }
                      });
                    },
                  ),
                  const Text(
                    'Owner',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Container(
                width: 200,
                margin: const EdgeInsets.only(top: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: "By pressing 'Submit' you agree to our ",
                      style: TextStyle(color: Color.fromARGB(255, 155, 179, 192)
                          // Palette.textColor2
                          ),
                      children: [
                        TextSpan(
                          //recognizer: ,
                          text: "term & conditions",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ]),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 1, left: 1),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  gradient: LinearGradient(
                      colors: <Color>[
                        Colors.teal,
                        Color.fromARGB(255, 13, 191, 173)
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: TextButton(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'Sign-Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'WorkSansBold'),
                      ),
                    ),
                    onPressed: () async {
                      validate();
                      var response = await postRegisterData(
                          username.text,
                          email.text,
                          contact_number.text,
                          cnic.text,
                          password.text,
                          role);

                      if (response.statusCode == 200) {
                        Alert(
                                context: this.context,
                                title: "Succesful",
                                desc: jsonDecode(response.body)['message'])
                            .show();
                        username.clear();
                        email.clear();
                        password.clear();
                        contact_number.clear();
                        cnic.clear();
                      } else {
                        Alert(
                                context: this.context,
                                title: "Error",
                                desc: jsonDecode(response.body)['message'])
                            .show();
                      }

                      //validatePassword(d);
                    }),
              ),
            ],
          ),
        ));
  }

  Container login()
  // IconData icon, String hintText, bool isPassword, bool isEmail)
  {
    return Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Form(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: Icon(Icons.mail),
                  hintText: 'Email',
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  EmailValidator(errorText: " Not valid")
                ]),
              ),
              TextFormField(
                controller: password,
                obscureText: _isHidden ? false : true,
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.white,
                  border: InputBorder.none,
                  icon: const Icon(Icons.lock),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => updateStatus(),
                    icon: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  MinLengthValidator(5, errorText: "More than 5 reuired")
                ]),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?",
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 167, 188, 199))),
              ),
              Container(
                margin: const EdgeInsets.only(right: 1, left: 1),
                //margin: const EdgeInsets.only(top: 340.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Colors.yellow,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  //   BoxShadow(
                  //     color: Color.fromARGB(255, 242, 168, 8),
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  // ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        Colors.teal,
                        Color.fromARGB(255, 13, 191, 173)
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: TextButton(

                    // highlightColor: Colors.transparent,
                    // splashColor: Colors.black,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'LOG-IN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'WorkSansBold'),
                      ),
                    ),
                    onPressed: () async {
                      validate();
                      var response =
                          await postLoginData(email.text, password.text);

                      print("Method Ran");
                      if (response.statusCode == 200) {
                        role_param = json.decode(response.body)["user"]["role"];
                        _status = json.decode(response.body)["user"]["status"];
                        print("here in 200 $_status");
                        Navigator.push(this.context,
                            MaterialPageRoute(builder: (context) {
                          if (role_param == "Student") {
                            return NavBar(
                              email: email_param,
                              role: role_param,
                              status: _status,
                            );
                          } else if (role_param == "Owner") {
                            return barNav(
                              email: email_param,
                              status: _status,
                            );
                          } else if (role_param == "Consultant") {
                            return ChatScreen(email: email_param);
                          } else {
                            return Login();
                          }
                        }));
                        email.clear();
                        password.clear();
                      } else {
                        print("here in 400");
                        Alert(
                                context: this.context,
                                title: "Error",
                                desc: jsonDecode(response.body)['message'])
                            .show();
                      }
                      //validatePassword(d);
                    }),
              ),
            ],
          ),
        ));
  }

  postLoginData(email_address, password) async {
    var response =
        await http.post(Uri.parse("http://localhost:5000/login"), body: {
      "email_address": email_address,
      "password": password,
    });
    email_address = email_address;
    // role_param = json.decode(response.body)["user"].role;
    // print("--------------------------->" +
    // json.decode(response.body)["user"]["role"]);
    email_param = email_address;
    return response;
  }

  postRegisterData(
      username, email_address, contact_number, cnic, password, role) async {
    var response =
        await http.post(Uri.parse("http://localhost:5000/register"), body: {
      "username": username,
      "email_address": email_address,
      "contact_number": contact_number,
      "cnic": cnic,
      "password": password,
      "role": role,
    });
    return response;
  }
}
