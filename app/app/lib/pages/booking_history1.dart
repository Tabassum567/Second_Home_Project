import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class BookingHistory extends StatefulWidget {
  var email_address;

  BookingHistory({super.key, required this.email_address});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  var _bookings = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingHistory(widget.email_address).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _bookings = json.decode(response.body)["history"];
          print(_bookings);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Booking History'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: BookingCard(booking: _bookings[index]),
          );
        },
      ),
    );
  }
}

class Booking {
  final String roomTitle;
  final String propertyType;
  final String period;
  final double monthlyRent;
  final String imageUrl;

  Booking({
    required this.roomTitle,
    required this.propertyType,
    required this.period,
    required this.monthlyRent,
    required this.imageUrl,
  });
}

class BookingCard extends StatelessWidget {
  final booking;

  const BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              booking["images"][0]["picture_url"],
              // fit: BoxFit.cover,
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking["bookings"][0]["property_type"],
                    style: TextStyle(fontSize: 18.0)),
                Text(booking["bookings"][0]["address"]),
                Text("${booking['start_date']} - ${booking['end_date']}"),
                Text('Monthly Rent: ${booking["total_amount"].toString()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future bookingHistory(emailAddress) async {
  var response = await http
      .get(Uri.parse("http://localhost:5000/bookingHistory/$emailAddress"));
  return response;
}
