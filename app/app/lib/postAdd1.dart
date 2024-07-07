// import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:app/owner_homescree.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class Facility {
  final String name;
  final String imageAsset;
  final IconData icon;

  Facility({
    required this.name,
    required this.imageAsset,
    required this.icon,
  });
}

const List<String> list = <String>[
  '--Select City--',
  'Clifton',
  'Defense',
  'Malir',
  'Cantt-Station'
];
const List<String> room = <String>['--Select Rooms--', '1', '2', '3', '4', '5'];
// List<String> selectedOptions = [];

DateFormat? formatter;
String? availableStartDate;
String? availableEndDate;
String? stringdateRange;

var property_type;
var city = TextEditingController();
var rooms = TextEditingController();
final property_title = TextEditingController();
final addressController = TextEditingController();
final searchText = TextEditingController();
var availability_period = TextEditingController();
var monthly_rent = TextEditingController();
var currency = TextEditingController();
var installment_allowed = TextEditingController();
var advance_payment = TextEditingController();
var additional_informtion = TextEditingController();
var contactName;
var contactNumber;
var contactEmail;
var finalImage;
sendData(
    property_type,
    city,
    rooms,
    property_title,
    address,
    availability_period,
    monthly_rent,
    currency,
    installment_allowed,
    advance_payment,
    additional_informtion,
    facilities,
    contact_name,
    contact_number,
    contact_email,
    email_address,
    image_upload,
    private_rooms,
    shared_rooms) async {
  var response;
  try {
    response = await http.post(
        Uri.parse("http://localhost:5000/postAd/$email_address"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "property_type": property_type,
          "city": city,
          "rooms": rooms,
          "property_title": property_title,
          "address": address,
          "availability_period": availability_period,
          "monthly_rent": monthly_rent,
          "currency": currency,
          "installment_allowed": installment_allowed,
          "advance_payment": advance_payment,
          "additional_informtion": additional_informtion,
          "facilities": facilities,
          "contact_name": contact_name,
          "contact_number": contact_number,
          "contact_email": contact_email,
          "image": image_upload,
          "private_room": private_rooms,
          "shared_room": shared_rooms,
        }));
  } catch (error) {
    print("Error is $error");
  }

  print("Sent data");
  return response;
}

class postAdd extends StatefulWidget {
  final PageController controller = PageController(initialPage: 0);
  var email_address;

  var contact_email;

  var contact_number;

  var contact_name;

  var status;

  postAdd({
    super.key,
    required this.email_address,
    required this.contact_email,
    required this.contact_number,
    required this.contact_name,
    required this.status,
  });

  @override
  State<postAdd> createState() {
    contactName = TextEditingController(text: contact_name);
    contactNumber = TextEditingController(text: contact_number);
    contactEmail = TextEditingController(text: contact_email);

    return _postAddState();
  }
}

class _postAddState extends State<postAdd> {
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  final _formKey = GlobalKey<FormState>();
  TextEditingController price = TextEditingController();
  TextEditingController installments = TextEditingController();
  TextEditingController advance = TextEditingController();

  DateTimeRange dateRange = DateTimeRange(
    // start: DateTime(2022 - 11 - 05),
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 365)),
    // end: DateTime(2022, 12, 24),
  );

  String dropdownValue = list.first;
  String roomValue = room.first;

  List allTextField = [];
  String city = "";
  // int rooms = 1;
  String rooms = "";
  String currency = "PKR";

  List displayTextField = [];

  List<String> items = ["House", "Flat", "Bungalow"];
  List<String> selectedOptions = [];

  int current = 0;
  List<bool> _isClicked = List.generate(8, (_) => false);

  final List<Facility> facilities = [
    Facility(
      name: 'Gym',
      imageAsset: 'Gym-weights.jpg',
      icon: Icons.fitness_center,
    ),
    Facility(
      name: 'Wifi',
      imageAsset: 'wifi.png',
      icon: Icons.wifi,
    ),
    Facility(
      name: 'Cooking',
      imageAsset: 'cooking1.jpg',
      icon: Icons.local_dining,
    ),
    Facility(
      name: 'Laundry',
      imageAsset: 'laundry.jpg',
      icon: Icons.wash,
    ),
    Facility(
      name: 'Security',
      imageAsset: 'security.jpg',
      icon: Icons.security,
    ),
    Facility(
      name: 'Helper',
      imageAsset: 'helper.jpg',
      icon: Icons.help,
    ),
    Facility(
      name: 'Fridge',
      imageAsset: 'fridge.jpg',
      icon: Icons.kitchen,
    ),
    Facility(
      name: 'Swimming Pool',
      imageAsset: 'assets/images/swimming-pool.jpg',
      icon: Icons.pool,
    ),
  ];
  void _toggleSaved(int index) {
    setState(() {
      _isClicked[index] = !_isClicked[index];
      final facility = facilities[index];
      if (_isClicked[index]) {
        selectedOptions.add(facility.name);
        print(selectedOptions);
      } else {
        selectedOptions.remove(facility.name);
        print(selectedOptions);
      }
    });
  }

  bool _isShared = false;
  int _numPrivateRooms = 1;
  int _numBedsPerRoom = 1;
  List<int> _bedsPerRoomList = [];
  List<int> _sharedBedsPerRoomList = [0];
  List<Uint8List> _images = [];

  Future<void> _selectImages() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (result != null && result.count <= 4) {
      List<Uint8List> selectedImages = [];

      for (var file in result.files) {
        Uint8List? bytes;
        if (file.bytes != null) {
          // On web, use the bytes property to display images.
          bytes = file.bytes!;
        } else {
          // On mobile, read the file as bytes to display images.
          File platformFile = File(file.path!);
          bytes = await platformFile.readAsBytes();
        }
        selectedImages.add(bytes);
      }

      setState(() {
        // _images = selectedImages;
        _images.addAll(selectedImages);
      });
    } else {
      // Snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    //  final difference = dateRange.duration;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.teal,
        // toolbarHeight: 20,
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Scaffold(
          appBar: _appBar(),
          body: Center(
            child: TabBarView(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Select Property Type",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: items.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          current = index;
                                          property_type = items[index];
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.all(3),
                                        width: 80,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: current == index
                                                ? Colors.teal
                                                : Colors.grey,
                                            borderRadius: current == index
                                                ? BorderRadius.circular(15)
                                                : BorderRadius.circular(10),
                                            border: current == index
                                                ? Border.all(
                                                    color: Colors.blue,
                                                    width: 2)
                                                : null),
                                        child: Center(
                                            child: Text(
                                          items[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: current == index
                                                  ? Colors.white
                                                  : Colors.black),
                                        )),
                                      ),
                                    ),
                                    Visibility(
                                        visible: current == index,
                                        child: Container(
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.teal),
                                        )),
                                  ],
                                );
                              }),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: const OutlineInputBorder(),
                            ),
                            value: dropdownValue,
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                enabled: value != list.first,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                                city = value;
                              });
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: DropdownButtonFormField(
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Colors.grey[200],
                        //       border: const OutlineInputBorder(),
                        //     ),
                        //     value: roomValue,
                        //     items: room
                        //         .map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         enabled: value != room.first,
                        //         child: Text(value),
                        //       );
                        //     }).toList(),
                        //     onChanged: (String? value) {
                        //       setState(() {
                        //         roomValue = value!;
                        //         rooms = value;
                        //       });
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(),
                                labelText: 'Property Title',
                              ),
                              onChanged: (value) {},
                              controller: property_title),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            maxLines: 2,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: const OutlineInputBorder(),
                              labelText: 'Property address',
                            ),
                            onChanged: (value) {},
                            controller: addressController,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Provide Period for Room Availabity",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    pickDateRange();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.teal,
                                  ),
                                  child: Text(
                                      '${start.year}/${start.month}/${start.day}'),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    pickDateRange();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: Colors.teal,
                                  ),
                                  child: Text(
                                      '${end.year}/${end.month}/${end.day}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 16,),
                        // Text("Difference: ${difference.inDays} days", style: TextStyle(fontSize: 32),)
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: price,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(),
                                labelText: 'Monthly Rent',
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "required"),
                                PatternValidator(r'^[0-9]+$',
                                    errorText: 'Provide Digits'),
                              ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: currency,
                              enabled: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "required"),
                                PatternValidator(r'^[0-9]+$',
                                    errorText: 'Provide Digits'),
                              ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              controller: installments,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(),
                                labelText: 'Installment Allowed',
                              ),
                              validator:
                                  RequiredValidator(errorText: "required"),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              controller: advance,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(),
                                labelText: 'Advance Payment',
                              ),
                              validator:
                                  RequiredValidator(errorText: "required"),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     const Text(
                            //       "More:",
                            //       style: TextStyle(
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: addTextField,
                            //       style: ElevatedButton.styleFrom(
                            //         padding: const EdgeInsets.all(20),
                            //         backgroundColor: Colors.teal,
                            //       ),
                            //       child: const Text("Add"),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: removeTextField,
                            //       style: ElevatedButton.styleFrom(
                            //         padding: const EdgeInsets.all(20),
                            //         backgroundColor: Colors.teal,
                            //       ),
                            //       child: const Text("Remove"),
                            //     ),
                            //   ],
                            // ),
                            // ...displayTextField
                            //     .map(
                            //       (e) => Row(
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets.only(
                            //                 top: 20, right: 20),
                            //             child: Text(
                            //               e['label'],
                            //             ),
                            //           ),
                            //           Expanded(child: e['text_field']),
                            //         ],
                            //       ),
                            //     )
                            //     .toList(),
                            const SizedBox(
                              height: 30,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Select Room Type:',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isShared = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .teal, // Set the button's background color to blue
                                  ),
                                  child: const Text('Shared'),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isShared = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .teal, // Set the button's background color to blue
                                  ),
                                  child: const Text('Private'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Visibility(
                              visible: _isShared,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total number of rooms:',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: 8.0),
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _numBedsPerRoom,
                                    // keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _numBedsPerRoom = value!;

                                        print(_numBedsPerRoom);
                                        // _numPrivateRooms = int.parse(value);
                                        if (_numBedsPerRoom <
                                            _sharedBedsPerRoomList.length) {
                                          _sharedBedsPerRoomList =
                                              _sharedBedsPerRoomList.sublist(
                                                  0, _numBedsPerRoom);
                                        } else {
                                          for (int i =
                                                  _sharedBedsPerRoomList.length;
                                              i < _numBedsPerRoom;
                                              i++) {
                                            _sharedBedsPerRoomList.add(0);
                                          }
                                        }
                                      });
                                    },
                                    items: [
                                      1,
                                      2,
                                      3,
                                      4
                                    ].map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                  ),
                                  // decoration: InputDecoration(
                                  //   filled: true,
                                  //   fillColor: Colors.grey[200],
                                  //   border: OutlineInputBorder(),
                                  //   ),
                                  // ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Enter room details:',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: 8.0),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _sharedBedsPerRoomList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                                  DropdownButtonFormField<int>(
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Beds in Room ${index + 1}',
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: _sharedBedsPerRoomList[
                                                    index],
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    if (_sharedBedsPerRoomList
                                                            .length >
                                                        index) {
                                                      _sharedBedsPerRoomList[
                                                          index] = newValue!;
                                                      print(
                                                          _sharedBedsPerRoomList);
                                                    } else {
                                                      _sharedBedsPerRoomList
                                                          .add(newValue!);
                                                    }
                                                  });
                                                },
                                                items:
                                                    List.generate(4, (value) {
                                                  return DropdownMenuItem<int>(
                                                    value: value,
                                                    child:
                                                        Text(value.toString()),
                                                  );
                                                }),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _sharedBedsPerRoomList
                                                      .removeAt(index);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal,
                                              ),
                                              child: Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _sharedBedsPerRoomList.add(0);
                                        print(_sharedBedsPerRoomList);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                    ),
                                    child: Text('Add Room'),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !_isShared,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Number of private rooms:',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  const SizedBox(height: 8.0),
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _numPrivateRooms,
                                    // keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _numPrivateRooms = value!;
                                        print(_numPrivateRooms);
                                      });
                                    },
                                    items: [
                                      1,
                                      2,
                                      3,
                                      4
                                    ].map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    // decoration: InputDecoration(
                                    //   filled: true,
                                    //   fillColor: Colors.grey[200],
                                    //   border: const OutlineInputBorder(),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: const OutlineInputBorder(),
                                labelText: 'Additional Information',
                              ),
                              onChanged: (value) {},
                              controller: additional_informtion,
                              validator:
                                  RequiredValidator(errorText: "required"),
                            )
                          ],
                        )),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  children: facilities.asMap().entries.map((entry) {
                    int index = entry.key;
                    Facility facility = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _toggleSaved(index);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        transform: Matrix4.translationValues(
                            0, _isClicked[index] ? -5 : 0, 0),
                        child: Card(
                          elevation: _isClicked[index] ? 10 : 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: _isClicked[index] ? Colors.grey : Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                facility.imageAsset,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                facility.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Icon(
                                facility.icon,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Contact Information",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Text("Provide valid Email and Phone number"),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: contactName,
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: "Name",
                              fillColor: Color.fromARGB(255, 238, 238, 238),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: contactNumber,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Contact",
                              fillColor: Colors.grey[200],
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: contactEmail,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Email",
                              fillColor: Colors.grey[200],
                              border: const OutlineInputBorder(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Column(children: [
                  Icon(Icons.photo_library, color: Colors.black, size: 50),
                  TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic)),
                    child: const Text(
                      "Upload Multiple Images",
                    ),
                    onPressed: () {
                      _selectImages();
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: _images
                          .map((imageBytes) => Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.teal,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                ),
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)),
                      child: const Text(
                        "Post-Add",
                      ),
                      onPressed: () async {
                        // print("Sending data");
                        var images = [];
                        for (var element in _images) {
                          // Uint8List base64Data = await element!.readAsBytes();

                          images.add(
                              await "data:image/jpeg;base64,${base64.encode(element)}");
                        }
                        print(
                            "Property Type : $property_type ~ Property Title : $property_title ~ Address: ${addressController.text} ~ Images: ${images}");
                        final response = await sendData(
                            property_type ?? "property type",
                            city,
                            rooms,
                            property_title.text ?? "title",
                            addressController.text ?? "-",
                            stringdateRange ?? "-",
                            price.text ?? "-",
                            currency,
                            installments.text ?? "-",
                            advance.text ?? "-",
                            additional_informtion.text ?? "-",
                            selectedOptions.join(","),
                            contactName.text ?? "-",
                            contactNumber.text ?? "-",
                            contactEmail.text ?? "-",
                            widget.email_address,
                            images,
                            _numPrivateRooms,
                            _sharedBedsPerRoomList);
                        if (response.statusCode == 200) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => barNav(
                                        email: widget.email_address,
                                        status: widget.status,
                                      )));
                        } else {
                          Alert(
                                  context: this.context,
                                  title: "Succesful",
                                  desc: "Error Posting data")
                              .show();
                        }
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        // margin: const EdgeInsets.only(top: 5),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              TopBar(),
              const SizedBox(height: 5),
              searchBox(),

              // locationPurpose(),
              tapBar(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      color: Colors.teal,
    );
  }

  Widget TopBar() {
    return Row(
      children: [
        Image.asset(
          "pic1.png",
          scale: 500,
        ),
        const Expanded(
          child: Text(
            "Profile",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        // const CircleAvatar(radius: 20, backgroundImage: AssetImage("1662135955026.jpg"),)
      ],
    );
  }

  Widget searchBox() {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: searchText,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Search Here',
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: InkWell(
              child: const Icon(Icons.close),
              onTap: () {
                searchText.clear();
              },
            )),
      ),
    );
  }

  Widget tapBar() {
    return const TabBar(
        labelPadding: EdgeInsets.all(0),
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        unselectedLabelColor: Colors.white,
        tabs: [
          Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.location_city_outlined),
            text: "Location",
          ),
          Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.sell),
            text: "Price",
          ),
          Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.featured_play_list),
            text: "Facilities",
          ),
          Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.phone),
            text: "Contact",
          ),
          Tab(
            iconMargin: EdgeInsets.all(0),
            icon: Icon(Icons.photo_library),
            text: "Multiple",
          ),
          // Tab(
          //   iconMargin: EdgeInsets.all(0),
          //   icon: Icon(Icons.image),
          //   text: "Image",
          // ),
        ]);
  }

  Widget tabBarViewItem(IconData icon, String name) {
    return Column(
      children: [
        Icon(
          icon,
          size: 100,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget dotted_border() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300,
        width: 300,
        child: DottedBorder(
            strokeWidth: 3, //thickness of dash/dots
            dashPattern: [10, 6],
            borderType: BorderType.RRect,
            child: TextButton(
                onPressed: (() {
                  _pickImage();
                }),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.teal,
                  ),
                ))),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
          finalImage = image;
        });
      } else {
        print("No Image has been Picked");
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print("No image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      formatter = DateFormat('yyyy-MM-dd');
      availableStartDate = formatter?.format(dateRange.start);
      availableEndDate = formatter?.format(dateRange.end);
      stringdateRange = '$availableStartDate - $availableEndDate';
      print(dateRange);
    });
  }

  void addTextField() {
    setState(() {
      if (allTextField.length == displayTextField.length) {
        return;
      } else {
        displayTextField.add(allTextField[displayTextField.length]);
      }
    });
  }

  void removeTextField() {
    setState(() {
      if (displayTextField.isNotEmpty) {
        displayTextField.removeLast();
      }
    });
  }
}
