import 'package:flutter/material.dart';
import 'map_screen.dart';

class LocationInputScreen extends StatefulWidget {
  @override
  _LocationInputScreenState createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? _errorMessage;

  void _submitLocation() {
    final location = _locationController.text.trim();
    if (location.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid location.';
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(location: location),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitLocation,
              child: Text('Show on Map'),
            ),
          ],
        ),
      ),
    );
  }
}
