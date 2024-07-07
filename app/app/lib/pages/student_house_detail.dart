import 'package:app/pages/student_book_room.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

var full_name;
var phoneNumber;
var contact_Email;
var _rooms;

// void main() => runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     // routes: {'/shape': (context) => const Shape()},
//     home: HotelDetailsPage()));
// void main() {
//   runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DefaultTabController(
//         length: 5,
//         child: Details(
//             email_address: "ali.mobin@szabist.pk",
//             contact_email: "",
//             contact_name: "",
//             contact_number: ""),
//       )));
// }

Future fetchRooms(propertyId) async {
  var response =
      await http.get(Uri.parse("http://localhost:5000/getRooms/$propertyId"));
  print(json.decode(response.body)["rooms"]);
  return response;
}

bookVisit(email_address, property_id, contact_number, date) async {
  try {
    final response = await http.post(
        Uri.parse("http://localhost:5000/bookVisit/${email_address}"),
        body: {
          "property_id": property_id,
          "contact_number": contact_number,
          "date": date.toString(),
        });
    return response;
  } catch (e) {
    print("====> $e");
  }
}

class Details extends StatefulWidget {
  // static final String path = "lib/src/pages/hotel/details.dart";

  var category;

  var location;

  var price;

  var thumbUrl;

  var title;
  var city;
  var availability_period;

  var additional_informtion;

  var facilities;

  var email;

  var property_type;

  var property_id;

  var advance_payment;
  
  var status;

  // Details({
  //   super.key,
  //   required this.email_address,
  //   required this.contact_email,
  //   required this.contact_number,
  //   required this.contact_name,
  // });

  Details(
      this.title,
      this.city,
      this.thumbUrl,
      this.location,
      this.price,
      this.availability_period,
      this.additional_informtion,
      this.facilities,
      this.email,
      this.property_type,
      this.property_id,
      this.advance_payment,
      this.status,
      {Key? key})
      : super(key: key);
//   @override
//   State<Details> createState() {
//     full_name = TextEditingController(text: contact_name);
//     phoneNumber = TextEditingController(text: contact_number);
//     contact_Email = TextEditingController(text: contact_email);
//     return _Details();
//   }
// }

// Item item;

  @override
  State<Details> createState() => _Details();
}

class _Details extends State<Details> {
  getData(email_address) async {
    try {
      final response = await http.get(
          Uri.parse("http://localhost:5000/fetchCustomer/${email_address}"));
      setState(() {
        full_name = new TextEditingController(
            text: json.decode(response.body)["customer"]["username"]);
        contact_Email = new TextEditingController(
            text: json.decode(response.body)["customer"]["email_address"]);
        phoneNumber = new TextEditingController(
            text: json.decode(response.body)["customer"]["contact_number"]);
      });
    } catch (e) {
      print("====> $e");
    }
  }

  final String image = "hotel1.png";
  List<String> photosList = [];
  bool _showFullText = false;
  final now = DateTime.now();
  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData(widget.email);
    fetchRooms(widget.property_id).then((response) {
      setState(() {
        print(json.decode(response.body)["rooms"]);
        _rooms = json.decode(response.body)["rooms"][0]["data"];
      });
    });

    // Initialize your imageList here
    photosList = [
      'hotel1.png',
      'hotel2.png',
      'hotel3.png',
      'hotel4.png',
      'hotel5.png',
      'hotel6.png'
      // Add more images to the list as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    List facilities = widget.facilities.split(",");
    // List facilities_icon = [];
    print(
        "------------------------------------------------>${widget.email}-------------------------------------");
    List<Icon> facilities_icon = [];
    for (int i = 0; i < facilities.length; i++) {
      if (facilities[i].trim() == "Cooking") {
        print("Cooking icon added");
        facilities_icon.add(Icon(Icons.kitchen));
      } else if (facilities[i].trim() == "Helper") {
        print("Helper icon added");
        facilities_icon.add(Icon(Icons.help));
      } else if (facilities[i].trim() == "Security") {
        print("Security icon added");
        facilities_icon.add(Icon(Icons.security));
      } else if (facilities[i].trim() == "Gym") {
        print("Helper icon added");
        facilities_icon.add(Icon(Icons.fitness_center));
      } else if (facilities[i].trim() == "Wifi") {
        print("Helper icon added");
        facilities_icon.add(Icon(Icons.wifi));
      } else {
        print("Laundry icon added");
        facilities_icon.add(Icon(Icons.local_laundry_service));
      }
      print("Iteration ${i + 1}");
    }
    print("Length is ${facilities_icon.length}");
    Size size = MediaQuery.of(context).size;
    final textLength = widget.additional_informtion.length;
    final defaultMaxLines = textLength > 200 ? 100 : 1;
    final maxLines = _showFullText ? null : defaultMaxLines;
    return Scaffold(
      bottomNavigationBar: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                    barrierDismissible: true,
                    barrierLabel: 'Book A Visit',
                    context: context,
                    pageBuilder: (context, _, __) => Center(
                        child: Container(
                            height: 620,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(
                                vertical: 32, horizontal: 24),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Stack(clipBehavior: Clip.none, children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Second Home",
                                        style: TextStyle(
                                            fontSize: 34,
                                            fontFamily: "Times New Roman"),
                                      ),
                                      Form(
                                        child: Column(children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  // filled: true,
                                                  // fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  labelText: 'full_name'),
                                              controller: full_name,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  // filled: true,
                                                  // fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  labelText: 'phoneNumber'),
                                              controller: phoneNumber,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  // filled: true,
                                                  // fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  labelText: 'emailAddress'),
                                              controller: contact_Email,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    minimumSize: const Size(
                                                        double.infinity, 50),
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Colors.teal,
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontStyle:
                                                            FontStyle.italic)),
                                                onPressed: () async {
                                                  var response =
                                                      await bookVisit(
                                                          widget.email,
                                                          widget.property_id,
                                                          phoneNumber.text,
                                                          DateTime.now());
                                                  if (response.statusCode ==
                                                      200) {
                                                    Alert(
                                                            context:
                                                                this.context,
                                                            title:
                                                                "Book a visit Succesfully",
                                                            desc: json.decode(
                                                                    response
                                                                        .body)[
                                                                'message'])
                                                        .show();
                                                  } else {
                                                    Alert(
                                                            context: context,
                                                            title: "Error",
                                                            desc: jsonDecode(
                                                                    response
                                                                        .body)[
                                                                'message'])
                                                        .show();
                                                  }
                                                },
                                                child: const Text(
                                                    'Request For Visit')),
                                          )

                                          // This trailing comma makes a
                                        ]),
                                      )
                                    ],
                                  ),
                                  const Positioned(
                                    left: 0,
                                    bottom: -48,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ])))));
              },
              child: Container(
                width: 132,
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.chat, color: Colors.white),
                    Text("BOOK A VISIT", style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoomBookingScreen(
                              propertyId: widget.property_id,
                              rooms: _rooms,
                              userEmail: widget.email,
                              monthlyRent: widget.price,
                              advancePayment: widget.advance_payment,
                              status: widget.status,
                            )),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.teal,
                  child: const Text("BOOK NOW",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: const BoxDecoration(color: Colors.black26),
              height: 400,
              child: Image.network(
                  widget.thumbUrl.length > 0
                      ? widget.thumbUrl[0]["picture_url"]
                      : widget.thumbUrl,
                  fit: BoxFit.cover)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property_type,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.city!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                        widget.title!,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.calendar_month,
                                      size: 16.0,
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: widget.availability_period)
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    const WidgetSpan(
                                        child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: widget.location)
                                  ]),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "${widget.price}\ ",
                                style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              const Text(
                                "/per month",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      const Text("Facilities & Security:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: facilities_icon.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      facilities_icon[index].icon,
                                      color: Colors.grey,
                                      size: 30.0,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   height: 50,
                      //   child: Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: facilities_icon.length,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             return facilities_icon[index];
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // GestureDetector(
                      //   onTap: () {
                      //     // Add your code here for when the card is tapped
                      //   },
                      //   child: Container(
                      //     height: 120,
                      //     child: ListView.builder(
                      //       padding: const EdgeInsets.only(
                      //           top: 0, bottom: 8, right: 16),
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: photosList.length,
                      //       itemBuilder: (context, index) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8),
                      //           child: Card(
                      //             color: Colors.white,
                      //             child: ClipRRect(
                      //               borderRadius: const BorderRadius.all(
                      //                   Radius.circular(8)),
                      //               child: AspectRatio(
                      //                 aspectRatio: 1,
                      //                 child: Image.asset(
                      //                   photosList[index],
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // GridView.builder(
                      //   itemCount: widget.facilities.length,
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2, // Number of columns
                      //     mainAxisSpacing: 10,
                      //     crossAxisSpacing: 10,
                      //     childAspectRatio: 2.5,
                      //   ),
                      //   itemBuilder: (context, int index) {
                      //     // Replace the Text widget with your actual facility object
                      //     return Text(widget.facilities[index]);
                      //   },
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    elevation: 0.0,
                                    title: Text('Property Images'),
                                    backgroundColor: Colors.teal,
                                  ),
                                  body: SingleChildScrollView(
                                      child: Container(
                                          height: size.height,
                                          width: double.infinity,
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: widget.thumbUrl.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  width: 300.0,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade200)),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              // Navigate to a new page that shows the full image
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      Scaffold(
                                                                    appBar:
                                                                        AppBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal,
                                                                    ),
                                                                    body:
                                                                        Center(
                                                                      child: Image
                                                                          .network(
                                                                        widget.thumbUrl[index]
                                                                            [
                                                                            "picture_url"],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 250,
                                                              width: double
                                                                  .infinity,
                                                              // width: 500,

                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                              ),
                                                              child:
                                                                  Image.network(
                                                                widget.thumbUrl[
                                                                        index][
                                                                    "picture_url"],
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ))
                                                      ]),
                                                );
                                              }))),
                                ),
                              ));
                        },
                        child: Container(
                          height: 120,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 8, right: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.thumbUrl.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(
                                        widget.thumbUrl[index]["picture_url"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30.0),
                      Text(
                        "Description",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        widget.additional_informtion,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFullText = !_showFullText;
                          });
                        },
                        child: Text(
                          _showFullText ? 'Read more' : 'Read Less',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "DETAIL",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
