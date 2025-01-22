import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search recipes...',
          prefixIcon: Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 214, 193, 1), width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: const Color.fromARGB(255, 241, 225, 72), width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
