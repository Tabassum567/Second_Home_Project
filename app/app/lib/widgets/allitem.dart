import 'package:app/pages/student_house_detail.dart';
import 'package:app/widgets/searchbar.dart';
import 'package:app/widgets/selectcategory.dart';
import 'package:flutter/material.dart';

class AllItem extends StatefulWidget {
  final List items;
  final int length;
  final String email;
  var status;
  AllItem(this.items, this.length, this.email, this.status, {Key? key})
      : super(key: key);

  @override
  State<AllItem> createState() => _AllItemState();
}

class _AllItemState extends State<AllItem> {
  List filteredItems = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

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

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredItems = widget.items
          .where((item) => item['property_type']
              .toString()
              .toLowerCase()
              .contains(category.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchField(
              onSearch: _filterItems,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                            filteredItems[index]["property_type"],
                            filteredItems[index]["city"] ?? "city",
                            filteredItems[index]["propertyData"].length > 0
                                ? filteredItems[index]["propertyData"][0]
                                    ["picture_url"]
                                : "https://www.thegreenage.co.uk/wp-content/uploads/2013/11/Block-of-flats.jpg",
                            filteredItems[index]["address"],
                            filteredItems[index]["monthly_rent"],
                            filteredItems[index]["availability_period"],
                            filteredItems[index]["additional_informtion"],
                            filteredItems[index]["facilities"],
                            widget.email,
                            filteredItems[index]["property_title"] ?? "title",
                            filteredItems[index]["property_id"] ?? "id",
                            filteredItems[index]["advance_payment"] ??
                                "advance_payment",
                            widget.status),
                      ),
                    );
                  },
                  child: Container(
                    width: 300.0,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Handle the item tap
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey.shade200,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    filteredItems[index]["propertyData"]
                                                .length >
                                            0
                                        ? filteredItems[index]["propertyData"]
                                            [0]["picture_url"]
                                        : "https://www.thegreenage.co.uk/wp-content/uploads/2013/11/Block-of-flats.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              filteredItems[index]['city'] ?? "Karachi",
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              filteredItems[index]['property_type'] ??
                                  "Property Type 2",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                                Text(
                                  filteredItems[index]['address'] ?? "Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${filteredItems[index]['monthly_rent']}\$/Month",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Handle favorite button press
                                  },
                                  icon: const Icon(
                                    Icons.favorite_outline_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
