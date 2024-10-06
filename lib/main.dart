import 'package:flutter/material.dart';
import 'screens/location_input_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(LocationApp());
}

class LocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationInputScreen(),
    );
  }
}
