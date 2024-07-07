import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  var email;

  MyHomePage({Key? key, required this.email}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Property> properties = [
    // Property(
    //   title: 'My Property',
    //   propertyName: 'My Property Name',
    //   isSharedRoom: false,
    //   monthlyRent: "1000",
    //   advancePayment: "2000",
    //   installment: "500",
    //   status: PropertyStatus.approved,
    // ),
    // Property(
    //   title: 'My Property',
    //   propertyName: 'My Property Name',
    //   isSharedRoom: false,
    //   monthlyRent: "1000",
    //   advancePayment: "2000",
    //   installment: "500",
    //   status: PropertyStatus.rejected,
    // ),
    // Property(
    //   title: 'My Property',
    //   propertyName: 'My Property Name',
    //   isSharedRoom: false,
    //   monthlyRent: "1000",
    //   advancePayment: "2000",
    //   installment: "500",
    //   status: PropertyStatus.approved,
    // ),
  ];

  List<Property> getPropertiesByStatus(PropertyStatus status) {
    return properties.where((property) => property.status == status).toList();
  }

  @override
  void initState() {
    getAds(widget.email, "Pending").then((data) {
      var response = data["ads"];
      for (var ad in response) {
        setState(() {
          properties.add(Property(
            title: ad["property_title"],
            propertyName: ad["property_title"],
            isSharedRoom: false,
            monthlyRent: ad["monthly_rent"],
            advancePayment: ad["advance_payment"],
            installment: ad["installment_allowed"],
            status: PropertyStatus.pending,
          ));
        });
      }
    });
    getAds(widget.email, "Approved").then((data) {
      var response = data["ads"];
      for (var ad in response) {
        setState(() {
          properties.add(Property(
            title: ad["property_title"],
            propertyName: ad["property_title"],
            isSharedRoom: false,
            monthlyRent: ad["monthly_rent"],
            advancePayment: ad["advance_payment"],
            installment: ad["installment_allowed"],
            status: PropertyStatus.approved,
          ));
        });
      }
    });

    getAds(widget.email, "Rejected").then((data) {
      var response = data["ads"];
      for (var ad in response) {
        setState(() {
          properties.add(Property(
            title: ad["property_title"],
            propertyName: ad["property_title"],
            isSharedRoom: false,
            monthlyRent: ad["monthly_rent"],
            advancePayment: ad["advance_payment"],
            installment: ad["installment_allowed"],
            status: PropertyStatus.rejected,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Flutter TabBar Example - Customized "),
        // ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Pending',
                    ),
                    Tab(
                      text: 'Approved',
                    ),
                    Tab(
                      text: 'Rejected',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPropertyList(PropertyStatus.pending),
                    _buildPropertyList(PropertyStatus.approved),
                    _buildPropertyList(PropertyStatus.rejected),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyList(PropertyStatus status) {
    final properties = getPropertiesByStatus(status);
    // final width = MediaQuery.of(context).size.width;
    // final height = width * 0.9;
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (BuildContext context, int index) {
        final property = properties[index];
        return Container(
          width: MediaQuery.of(context).size.width,
          // height: height,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Property Name: ${property.propertyName}'),
                  const SizedBox(height: 4),
                  Text('Room Type: ${property.roomType}'),
                  const SizedBox(height: 4),
                  Text('Monthly Rent: ${property.monthlyRent}'),
                  const SizedBox(height: 4),
                  Text('Advance Payment: ${property.advancePayment}'),
                  const SizedBox(height: 4),
                  Text('Installment: ${property.installment}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum PropertyStatus { pending, approved, rejected }

class Property {
  final String title;
  final String propertyName;
  final bool isSharedRoom;
  final String monthlyRent;
  final String advancePayment;
  final String installment;
  final PropertyStatus status;

  Property({
    required this.title,
    required this.propertyName,
    required this.isSharedRoom,
    required this.monthlyRent,
    required this.advancePayment,
    required this.installment,
    required this.status,
  });

  String get roomType => isSharedRoom ? 'Shared' : 'Private';
}

Future getAds(email, status) async {
  var response =
      await http.get(Uri.parse("http://localhost:5000/post$status/$email"));

  return json.decode(response.body);
}
