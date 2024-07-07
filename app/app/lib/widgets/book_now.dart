// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // routes: {'/shape': (context) => const Shape()},
    home: RoomBook()));

class RoomBook extends StatefulWidget {
  @override
  _RoomBookState createState() => _RoomBookState();
}

class _RoomBookState extends State<RoomBook> {
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 1));

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _checkInDate) {
      setState(() {
        // Create a new DateTime object with the time component set to midnight
        _checkInDate = picked;
        // print(_checkInDate);

        // Format the date as a string using the 'yyyy-MM-dd' format
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formattedDate = formatter.format(_checkInDate);
        print(formattedDate);

        // Save the formatted date to the database
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _checkOutDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
        print(_checkOutDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Book'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: const [
              Text(
                'Select Check-In Date:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Select Check-Out Date:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () {
                    _selectCheckInDate(context);
                  },
                  child: Text(
                    '${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    _selectCheckOutDate(context);
                  },
                  child: Text(
                    '${_checkOutDate.day}/${_checkOutDate.month}/${_checkOutDate.year}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
