import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;

class MapScreen extends StatefulWidget {
  final String location;

  MapScreen({required this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _locationCoordinates;
  LatLng? _currentLocation;
  String? _errorMessage;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromLocation();
  }

  Future<void> _getCoordinatesFromLocation() async {
    try {
      List<geo.Location> locations =
          await geo.locationFromAddress(widget.location);
      setState(() {
        _locationCoordinates =
            LatLng(locations[0].latitude, locations[0].longitude);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not find the location. Please try again.';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    loc.LocationData _locationData = await location.getLocation();
    setState(() {
      _currentLocation =
          LatLng(_locationData.latitude!, _locationData.longitude!);
    });

    mapController.animateCamera(
      CameraUpdate.newLatLng(_currentLocation!),
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : _currentMapType == MapType.satellite
              ? MapType.terrain
              : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _toggleMapType,
            tooltip: 'Toggle Map Type',
          ),
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Go to Current Location',
          ),
        ],
      ),
      body: _locationCoordinates == null
          ? Center(
              child: _errorMessage != null
                  ? Text(_errorMessage!)
                  : CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _locationCoordinates!,
                zoom: 12,
              ),
              mapType: _currentMapType,
              markers: {
                Marker(
                  markerId: MarkerId('location'),
                  position: _locationCoordinates!,
                  infoWindow: InfoWindow(title: widget.location),
                ),
                if (_currentLocation != null)
                  Marker(
                    markerId: MarkerId('current_location'),
                    position: _currentLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure),
                    infoWindow: InfoWindow(title: 'Your Location'),
                  ),
              },
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
    );
  }
}
