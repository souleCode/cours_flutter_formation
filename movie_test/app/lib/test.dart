// Import multiselct
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // DropDownMultiSelect comes from multiselect
          child: DropDownMultiSelect(
            onChanged: (List<String> x) {
              setState(() {
                selected = x;
              });
            },
            options: ['a', 'b', 'c', 'd'],
            selectedValues: selected,
            whenEmpty: 'Select Something',
          ),
        ),
      ),
    );
  }
}
