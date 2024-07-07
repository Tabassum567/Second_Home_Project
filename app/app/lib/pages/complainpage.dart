// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:app/login_page_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // routes: {'/shape': (context) => const Shape()},
    home: ComplainPage(
      email: email_param.toString(),
    )));
const List<String> dropDownListData = <String>[
  '--Select Category--',
  'Property-damaged',
  'Communication-gap',
  'Rent payment disputes',
  'Privacy violations',
  'Breach of agreement'
];

class ComplainPage extends StatefulWidget {
  const ComplainPage({super.key, required this.email});
  final String email;
  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

registerComplain(title, category, description, email) async {
  var response = await http
      .post(Uri.parse("http://localhost:5000/complain/$email"), body: {
    "complain_category": category,
    "complain_title": title,
    "complain_description": description,
  });
  return response;
}

class _ComplainPageState extends State<ComplainPage> {
  String dropdownValue = dropDownListData.first;
  // String selectedCourseValue = "";
  // String selectedCourseValue = "";
  final title = TextEditingController();
  final description = TextEditingController();
  String category = "";

  @override
  Widget build(BuildContext context) {
    print("Printing in complain: ${widget.email}");
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
                child: Image.asset('edit.gif', height: 150, width: 150),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50, right: 40, left: 40, bottom: 40),
                child: Text(
                  "Easily lodge a complaint about any issues you may be experiencing in your living space. Simply fill out the complaint form with your specific concerns and our team will address the issue as soon as possible.",
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(right: 1, left: 1),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.teal),
                  child: TextButton.icon(
                    onPressed: () {
                      showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: 'Lodge Complain',
                          context: context,
                          pageBuilder: (context, _, __) => Center(
                                child: Container(
                                  height: 620,
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 32, horizontal: 24),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  child: Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Lodge Complain",
                                              style: TextStyle(
                                                  fontSize: 34,
                                                  fontFamily:
                                                      "Times New Roman"),
                                            ),
                                            Form(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              // filled: true,
                                                              // fillColor: Colors.white,
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              labelText:
                                                                  'Complain-Title'),
                                                      controller: title,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16, bottom: 16),
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              // filled: true,
                                                              // fillColor: Colors.white,
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              labelText:
                                                                  'Description'),
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      // maxLines: null,
                                                      minLines: 5,
                                                      maxLines: null,
                                                      controller: description,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16, bottom: 16),
                                                    child:
                                                        DropdownButtonFormField(
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                      value: dropdownValue,
                                                      items: dropDownListData.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          enabled: value !=
                                                              dropDownListData
                                                                  .first,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          dropdownValue =
                                                              value!;
                                                          category = value;
                                                          print(dropdownValue);
                                                          // print(title);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: TextButton(
                                                        style: TextButton.styleFrom(
                                                            minimumSize: Size(
                                                                double.infinity,
                                                                50),
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors.teal,
                                                            textStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic)),
                                                        onPressed: () async {
                                                          var response =
                                                              await registerComplain(
                                                                  title.text,
                                                                  category,
                                                                  description
                                                                      .text,
                                                                  widget.email);
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            Alert(
                                                                    context: this
                                                                        .context,
                                                                    title:
                                                                        "Complain Registered Succesfully",
                                                                    desc: jsonDecode(
                                                                        response
                                                                            .body)['message'])
                                                                .show();
                                                          } else {
                                                            Alert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        "Error",
                                                                    desc: jsonDecode(
                                                                        response
                                                                            .body)['message'])
                                                                .show();
                                                          }
                                                        },
                                                        child: Text('Submit')),
                                                  )

                                                  // This trailing comma makes a
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          left: 0,
                                          bottom: -48,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
