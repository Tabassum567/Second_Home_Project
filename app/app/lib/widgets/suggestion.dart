import 'package:app/pages/student_horizontal_images.dart';
import 'package:app/pages/student_house_detail.dart';
import 'package:app/widgets/allitem.dart';
import 'package:app/widgets/house_card.dart';
import 'package:flutter/material.dart';

class Suggestion extends StatefulWidget {
  var length;

  var email;

  var status;

  Suggestion(
      this.title, this.items, this.length, this.places, this.email, this.status,
      {Key? key})
      : super(key: key);

  var places;
  String? title;
  List items;

  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  @override
  Widget build(BuildContext context) {
    // print("Run");
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title ?? "Title",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              TextButton(
                onPressed: () {
                  if (widget.places == "recommendation") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllItem(
                                widget.items,
                                (widget.items.length / 2).round(),
                                widget.email,
                                widget.status)));
                  } else {
                    // print("Near By");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllItem(
                                widget.items,
                                widget.items.length,
                                widget.email,
                                widget.status)));
                  }
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.teal, // Change the text color to teal
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
              height: 340.0,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.length,
                itemBuilder: (context, index) => ItemCard(
                    widget.items[index]["propertyData"].length > 0
                        ? widget.items[index]["propertyData"]
                        : "https://www.thegreenage.co.uk/wp-content/uploads/2013/11/Block-of-flats.jpg",
                    widget.items[index]["city"] ?? "city",
                    widget.items[index]["property_type"],
                    widget.items[index]["address"],
                    widget.items[index]["monthly_rent"], () {
                  print(
                      "Length of images ${widget.items[index]["propertyData"].length}");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Details(
                      widget.items[index]["property_type"] ?? "Property type",
                      widget.items[index]["city"] ?? "city",
                      widget.items[index]["propertyData"].length > 0
                          ? widget.items[index]["propertyData"]
                          : "https://www.thegreenage.co.uk/wp-content/uploads/2013/11/Block-of-flats.jpg",
                      widget.items[index]["address"] ?? "Address",
                      widget.items[index]["monthly_rent"] ?? "Rent",
                      widget.items[index]["availability_period"],
                      widget.items[index]["additional_informtion"],
                      widget.items[index]["facilities"],
                      widget.email,
                      widget.items[index]["property_title"] ?? "title",
                      widget.items[index]["property_id"] ?? "id",
                      widget.items[index]["advance_payment"] ??
                          "advance_payment",
                      widget.status,
                    );
                  }));
                }),
              ))
        ],
      ),
    );
  }
}
