import 'dart:convert';

import 'package:app/widgets/searchbar.dart';
import 'package:app/widgets/selectcategory.dart';
import 'package:app/widgets/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'image_file.dart';

List postAd_data = [];
var namestudent;

class HomePage extends StatefulWidget {
  var email;

  var status;

  var name;

  // var email;
  // var role;

  HomePage(
      {this.email,
      required this.status,
      required this.name,
      required this.items,
      super.key});
  final List items;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getPostData() async {
    final response = await http.get(Uri.parse("http://localhost:5000/postAd"));
    setState(() {
      postAd_data = json.decode(response.body)["ads"];
      postAd_data = new List.from(postAd_data.reversed);
      print("Post Ad Data: ${postAd_data}");
      // print(postAd_data);
    });
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostData();
  }

  List filteredItems = [];
  void _filterItems(String searchText) {
    setState(() {
      filteredItems = widget.items
          .where((item) =>
              item['property_type']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              item['city']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              item['monthly_rent']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  var selectedCategory;
  void _filterByCategory(String category) {
    print("Here $category");
    setState(() {
      selectedCategory = category;
      filteredItems = postAd_data
          .where((ad) => ad['property_type'] == selectedCategory)
          .toList();
      print(filteredItems);
    });
  }

  bool isVerified = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 80.0,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'logo2.png', // Replace 'logo2.png' with the actual path to your logo image
              width: 40, // Adjust the width as needed
              height: 40, // Adjust the height as needed
            ),
            Text(
              'SecondHome',
              style: TextStyle(
                  fontSize: 8,
                  color: Colors.teal), // Adjust the font size as needed
            ),
          ],
        ),
        title: Row(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                widget.status != "verified"
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Image_file(
                                  email: widget.email,
                                )),
                      ).then((value) {
                        // When the user navigates back from the Image_file screen,
                        // this callback will be called, and you can update the verification status.
                        if (value == true) {
                          setState(() {
                            var isVerified = true;
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
                    color: Colors.teal,
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.status ?? "unverified",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SelectCategory(
                onCategorySelect: _filterByCategory,
              ),
              const SizedBox(
                height: 20,
              ),
              Suggestion(
                  "Latest",
                  selectedCategory != null ? filteredItems : postAd_data,
                  selectedCategory != null
                      ? (filteredItems.length / 2).round()
                      : (postAd_data.length / 2).round(),
                  "recommendation",
                  widget.email,
                  widget.status),
              const SizedBox(
                height: 20,
              ),
              Suggestion(
                  "View All",
                  selectedCategory != null ? filteredItems : postAd_data,
                  selectedCategory != null
                      ? filteredItems.length
                      : postAd_data.length,
                  "View",
                  widget.email,
                  widget.status),
            ],
          ),
        ),
      ),
    );
  }
}
