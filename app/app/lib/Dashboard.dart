import 'dart:convert';
import 'package:app/agreement_owner.dart';
import 'package:app/pages/image_file.dart';
// import 'package:app/pages/navbar_owner.dart';
import 'package:app/postAdd1.dart';
import 'package:flutter/material.dart';
import 'package:app/createPofile.dart';
import 'package:http/http.dart' as http;

// import 'main.dart';

// void main() {
//   runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Dashboard()));
// }
var _name;
var _contact_number;
var _email;
var _nic;
var _picture;
var _agreement;

class Dashboard extends StatefulWidget {
  var email_address;

  var status;

  Dashboard({super.key, required this.email_address, required this.status});
  bool termsChecked = false;

  @override
  State<Dashboard> createState() => _DashboardState();
}

// bool termsChecked = false;

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<String> selectedDays = [];
  bool _fabVisible = true;
  bool _isBlinking = true;
  getData(email_address) async {
    try {
      final response = await http.get(
          Uri.parse("http://localhost:5000/fetchCustomer/${email_address}"));
      setState(() {
        _name = json.decode(response.body)["customer"]["username"];
        _email = json.decode(response.body)["customer"]["email_address"];
        _nic = json.decode(response.body)["customer"]["cnic"];
        _picture = json.decode(response.body)["customer"]["picture_public_url"];
        _contact_number =
            json.decode(response.body)["customer"]["contact_number"];
        _agreement =
            json.decode(response.body)["customer"]["agreement"] ?? "false";
      });

      if (response.statusCode == 200) {
        print("Data is fetched and agreement = $_agreement");
      }
      print("object");
    } catch (e) {
      print("====> $e");
    }
  }

  void _showMenu(BuildContext context) async {
    // _controller.forward(from: 0.0);
    List<String> availableDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    List<String> selectedOptions = []; // create list to hold selected options

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select availability days"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (String day in availableDays)
              StatefulBuilder(
                builder: (context, setState) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: selectedOptions.contains(day),
                    activeColor: Colors.teal,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedOptions.add(day); // add to list if selected
                        } else {
                          selectedOptions
                              .remove(day); // remove from list if unselected
                        }
                      });
                    },
                  );
                },
              )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.teal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context, selectedOptions); // pass selectedOptions as result
              _controller.stop();
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        // print(selectedOptijons);
        // save selected options in a variable
        List<String> selectedDays = List.from(selectedOptions);
        print(selectedDays);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData(widget.email_address);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
        if (selectedDays.isNotEmpty) {
          _controller.stop();
        }
      });
    _controller.forward(); // start animation automatically
  }

  bool isVerified = true;
  bool _agreed = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: Stack(
                children: [
                  Container(
                    color: Colors.teal,
                    height: 180,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(_picture ?? 'Sir.jpg'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$_name",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  "${widget.email_address}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                widget.status != "verified"
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Image_file(
                                                  email: widget.email_address,
                                                )),
                                      ).then((value) {
                                        // When the user navigates back from the Image_file screen,
                                        // this callback will be called, and you can update the verification status.
                                        if (value == true) {
                                          setState(() {
                                            isVerified = true;
                                          });
                                        }
                                      })
                                    : "";
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cloud_upload,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.status,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // const Padding(
                          //   padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          //   child: Icon(
                          //     Icons.notifications_active,
                          //     color: Colors.white,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 125,
                    child: SizedBox(
                      height: 180,
                      width: width,
                      child: Column(
                        children: [
                          Container(
                            height: 130,
                            width: width - 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                  offset: const Offset(0, 7),
                                )
                              ],
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.teal,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Get Better Property Placement",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                                // const Divider(
                                //   thickness: 2,
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.message,
                                              size: 35,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          const Text(
                                            "Message",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.call,
                                              size: 35,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          const Text(
                                            "Helpline",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _agreement == "false"
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Agreement(
                                                                email_address:
                                                                    widget
                                                                        .email_address,
                                                                status: widget
                                                                    .status,
                                                              )),
                                                    )
                                                  : null;
                                            },
                                            child: const Icon(
                                              Icons.handshake_outlined,
                                              size: 35,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          const Text(
                                            "E-Agreement",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateProfile(
                                                          contact_number:
                                                              _contact_number,
                                                          email_address: widget
                                                              .email_address,
                                                          name: _name,
                                                          nic: _nic,
                                                          picture_url: _picture,
                                                          status: widget.status,
                                                        )),
                                              );
                                            },
                                            child: Icon(
                                              Icons.person,
                                              size: 35,
                                              color: Colors.teal,
                                            ),
                                          ),
                                          const Text(
                                            "Profile",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: width,
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Looking to Rent a Property?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    "Post Now to Reach Millions of Users",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(children: const [
                        Icon(
                          Icons.verified,
                          color: Colors.teal,
                        ),
                        Text(
                          "Connect with Real Buyers",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ]),
                      Row(children: const [
                        Icon(
                          Icons.verified,
                          color: Colors.teal,
                        ),
                        Text(
                          "Get Better Price",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ]),
                    ],
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(40),
                      child: TextButton.icon(
                          icon: const Icon(
                            Icons.add_location_alt,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Post Property',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(24),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            textStyle: const TextStyle(
                                fontSize: 15, fontStyle: FontStyle.normal),
                          ),
                          onPressed: () {
                            _agreement == "true"
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => postAdd(
                                              email_address:
                                                  widget.email_address,
                                              contact_email: _email,
                                              contact_name: _name,
                                              contact_number: _contact_number,
                                              status: widget.status,
                                            )),
                                  )
                                : null;
                          }))
                ],
              ),
            ),
            Positioned(
              bottom: 20, // adjust the value as needed
              right: 20, // adjust the value as needed
              child: Container(
                child: _fabVisible
                    ? AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) => Transform.scale(
                          scale: 1.0 + _animation.value * 0.1,
                          child: FloatingActionButton(
                            onPressed: () => _showMenu(context),
                            child: Container(
                              width: 50,
                              height: 50,
                              child: Image.asset('logo2.png'),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
