import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future getBookings(email) async {
  var response =
      await http.get(Uri.parse("http://localhost:5000/booking/$email"));
  return json.decode(response.body);
}

class StudentRecordsScreen extends StatefulWidget {
  var email;

  StudentRecordsScreen({Key? key, required this.email}) : super(key: key);
  @override
  _StudentRecordsScreenState createState() => _StudentRecordsScreenState();
}

class _StudentRecordsScreenState extends State<StudentRecordsScreen> {
  // List of student data
  List studentRecords = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookings(widget.email).then((data) {
      setState(() {
        studentRecords = data["data"];
        print(studentRecords);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Records'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: studentRecords.length,
        itemBuilder: (context, index) {
          return BookingDetailsScreen(
            student: studentRecords[index],
          );
        },
      ),
    );
  }
}

class BookingDetailsScreen extends StatefulWidget {
  var student;

  BookingDetailsScreen({required this.student});

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    print("Here");
    print("Record = ${widget.student}");
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.teal,
              ),
              title: Text(
                widget.student['data']['contact_name'] ?? "gmail.com",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              subtitle: Text(
                widget.student['user_email'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Check-in/Check-out Dates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check-in',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.student['start_date'] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-out',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.student['end_date'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Rental Duration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.teal,
                ),
                SizedBox(width: 16),
                Text(
                  "90",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Payment Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: Colors.teal,
                ),
                SizedBox(width: 16),
                Text(
                  "Paid",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
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
