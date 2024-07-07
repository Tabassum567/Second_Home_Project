import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String) onSearch;

  const SearchField({required this.onSearch, Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: widget.onSearch,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Color.fromARGB(255, 245, 245, 245),
        hintText: "Search",
        prefixIcon: Icon(CupertinoIcons.search),
        suffixIcon: Icon(Icons.filter_alt_outlined),
      ),
    );
  }
}
