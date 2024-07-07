import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/final_pay.dart';

var rooms;
int private_rooms = 0;
var shared_rooms;

class RoomBookingScreen extends StatefulWidget {
  var propertyId;

  var rooms;

  var userEmail;

  var monthlyRent;

  var advancePayment;

  var status;

  RoomBookingScreen({
    super.key,
    required this.monthlyRent,
    required this.advancePayment,
    required this.propertyId,
    required this.rooms,
    required this.userEmail,
    required this.status,
  });
  @override
  _RoomBookingScreenState createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  String _selectedRoomType = 'Private Room';
  // int _numBeds = 1;
  var _numBeds; // initial value
  var _privateRoomId; // initial value
  var _sharedRoomId; // initial value

  // Define variables to store the room availability data
  List _numPrivateRooms = [0];
  Map<String, int> _numBedsInSharedRooms = {};
  String _searchQuery = '';
  List<String> _searchResults = [];
  void _searchForPerson(String query) {
    // TODO: Implement the search logic based on the query.
    // Here, we're hardcoding some example search results for demo purposes.
    List<String> results = ['Person A', 'Person B', 'Person C'];
    setState(() {
      _searchResults = results;
    });
  }

  void _addPerson(String personName) {
    // TODO: Implement adding the person to the list of people to share the room with.
  }

  @override
  void initState() {
    super.initState();
    // Fetch room availability data from the backend
    // setState(() {
    for (var room in widget.rooms) {
      if (room["room_type"] == "private") {
        _privateRoomId = room["_id"];
        _numPrivateRooms[0] = room["available"];
      } else {
        _numBeds = "${room['bed_number']}-${room['_id']}";
        _numBedsInSharedRooms.addAll(
            {"${room['bed_number']}-${room['_id']} Beds": room["available"]});
      }
    }
    // });
    // fetchRoomAvailability();
  }

  void fetchRoomAvailability() async {
    // TODO: Implement API call to fetch room availability data
    // In this example, we're hardcoding the values for demo purposes
    // _numPrivateRooms = private_rooms;
    // _numBedsInSharedRooms = {
    //   '4 Beds': 2,
    //   '3 Beds': 4,
    //   '2 Beds': 6,
    // };
  }

  DateTime? _endDate;
  DateTime? _startDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime minimumDate = currentDate.add(const Duration(days: 90));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? minimumDate,
      firstDate: minimumDate,
      lastDate: currentDate.add(const Duration(days: 365)),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formattedDate = formatter.format(_startDate!);
        print(formattedDate);
      });

      // Check if the selected date range is at least three months
      if (_endDate != null && _endDate!.difference(_startDate!).inDays < 90) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('You must select a date range of at least three months.'),
        ));
        // Reset the selected start date to null to force the user to select a new date range
        setState(() {
          _startDate = null;
          // print(_endDate);
        });
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime minimumDate = _startDate!.add(const Duration(days: 90));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? minimumDate,
      firstDate: minimumDate,
      lastDate: currentDate.add(const Duration(days: 365)),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formateDate = formatter.format(_endDate!);
        print(formateDate);
      });

      // Check if the selected date range is at least three months
      if (_startDate != null && _endDate!.difference(_startDate!).inDays < 90) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('You must select a date range of at least three months.'),
        ));
        // Reset the selected end date to null to force the user to select a new date range
        setState(() {
          _endDate = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Room Booking'),
          backgroundColor: Colors.teal,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Select Room Type',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              DropdownButton<String>(
                value: _selectedRoomType,
                icon: const Icon(Icons.arrow_downward, color: Colors.teal),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Private Room',
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.teal),
                        const SizedBox(width: 8.0),
                        Text('Private Room (${_numPrivateRooms[0]} available)',
                            style: const TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Shared Room',
                    child: Row(
                      // Add icon to the left of the text
                      children: [
                        const Icon(Icons.people,
                            color: Colors.teal), // Add icon
                        const SizedBox(width: 8.0),
                        Text(
                            'Shared Room (${_numBedsInSharedRooms.values.reduce((a, b) => a + b)} available)'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRoomType = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              if (_selectedRoomType == 'Shared Room')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hotel),
                        const SizedBox(width: 8.0),
                        Text(
                          'Select Number of Beds',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButton<String>(
                      value: _numBeds.toString() + ' Beds',
                      items: _numBedsInSharedRooms.keys.map((numBeds) {
                        return DropdownMenuItem<String>(
                          value: numBeds,
                          child: Row(
                            children: [
                              Text(
                                '${numBeds.split("-")[0]} Beds (${_numBedsInSharedRooms[numBeds]} available)',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const SizedBox(width: 8.0),
                              const Icon(Icons.hotel),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _numBeds = value!.split(' ')[0];
                          _sharedRoomId = value!.split(' ')[0].split("-")[1];
                          // print(
                          // "$_numBeds selected and Rooms is $_selectedRoomType");
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _searchForPerson(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search for a person',
                        // prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_searchResults[index]),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              _addPerson(_searchResults[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8.0),
                          Text(
                            'Start Date',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextButton(
                        child: Row(
                          children: [
                            Text(
                              _startDate == null
                                  ? 'Select start date'
                                  : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.teal),
                            ),
                          ],
                        ),
                        onPressed: () => _selectStartDate(context),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8.0),
                          Text(
                            'End Date',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextButton(
                        child: Row(
                          children: [
                            Text(
                              _endDate == null
                                  ? 'Select end date'
                                  : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.teal),
                            ),
                          ],
                        ),
                        onPressed: () => _selectEndDate(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (_startDate != null && _endDate != null)
                Text(
                  'Selected date range: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Change button color
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                              propertyId: widget.propertyId,
                              monthlyRent: widget.monthlyRent,
                              advancePayment: widget.advancePayment,
                              startDate: _startDate ?? "start date",
                              endDate: _endDate ?? "end date",
                              privateRoomId: _privateRoomId,
                              sharedRoomId: _sharedRoomId,
                              selectedRoomType: _selectedRoomType,
                              userEmail: widget.userEmail,
                              status: widget.status,
                            )),
                  );
                  // TODO: Implement booking logic
                  // print(
                  //     "Room Selected is $_selectedRoomType and Room Id is  : ${_selectedRoomType == 'Shared Room' ? _sharedRoomId : _privateRoomId} and date is ${DateFormat('dd-MM-yyyy').format(_startDate!)} till ${DateFormat('dd-MM-yyyy').format(_endDate!)}");
                },
                child: const Text('Book Room'),
              ),
            ],
          ),
        ));
  }
}
