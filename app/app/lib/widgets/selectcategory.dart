import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  final Function(String) onCategorySelect;

  const SelectCategory({required this.onCategorySelect, Key? key})
      : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          categoryButton(Icons.house_rounded, "House"),
          categoryButton(Icons.apartment_rounded, "Flat"),
          categoryButton(Icons.villa_rounded, "Banglow"),
        ],
      ),
    );
  }

  Widget categoryButton(IconData icon, String text) {
    return Container(
      margin: EdgeInsets.all(18.0),
      width: 80.0,
      height: 80.0,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade100)),
      child: InkWell(
        onTap: () {
          widget.onCategorySelect(text);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.0,
              color: Colors.black,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
