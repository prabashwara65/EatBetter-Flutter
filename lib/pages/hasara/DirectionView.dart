import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:http/http.dart' as http;

class DirectionView extends StatefulWidget {
  final LatLng destination; // Destination (restaurant) location
  final String restaurantName; // Add restaurant name parameter

  const DirectionView({
    required this.destination,
    required this.restaurantName,
    super.key,
  });

  @override
  _DirectionViewState createState() => _DirectionViewState();
}

class _DirectionViewState extends State<DirectionView> {
  final location_package.Location _locationController =
      location_package.Location();
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  List<LatLng> _routeCoordinates =
      []; // Stores the polyline coordinates for the route
  Set<Polyline> _polylines = {}; // Store the route polylines
  final String _directionsApiKey = "//Api key";
  Set<Marker> _markers = {};
  double _distanceToDestination = 0.0; // Distance between user and restaurant

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
    _addRestaurantMarker();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Destination",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF86A2E),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFFF86A2E),
                size: 25,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 7,
            child: _currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      _moveCameraToCurrentLocation();
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    polylines: _polylines,
                    markers: _markers,
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 8.0),
                          const Text(
                            'Your Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${_distanceToDestination.toStringAsFixed(2)} km",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Icon(Icons.restaurant, color: Colors.orange),
                          const SizedBox(width: 8.0),
                          Text(
                            widget.restaurantName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      // Line connecting the two points (user and restaurant)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.orange],
                                  stops: [
                                    0.2, // Proximity of user to the restaurant can change the stop
                                    1.0
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "You're navigating to this location.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Fetch live location updates
  void _getLocationUpdates() async {
    bool _serviceEnabled;
    location_package.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == location_package.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != location_package.PermissionStatus.granted)
        return;
    }

    _locationController.onLocationChanged
        .listen((location_package.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        // Update user location marker
        _addUserLocationMarker();

        // Calculate distance
        _calculateDistance();

        // Get directions route when current location is updated
        _fetchRoute(_currentLocation!, widget.destination);
      }
    });
  }

  // Add restaurant marker
  void _addRestaurantMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('restaurant'),
          position: widget.destination,
          infoWindow: InfoWindow(
            title: widget.restaurantName,
            snippet: 'Your destination',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    });
  }

  // Add user location marker
  void _addUserLocationMarker() {
    if (_currentLocation != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            infoWindow: const InfoWindow(
              title: 'Your Location',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });
    }
  }

  // Move the camera to the current location
  void _moveCameraToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  // Calculate distance between user and restaurant using Haversine formula
  void _calculateDistance() {
    if (_currentLocation != null && widget.destination != null) {
      double distance = _getDistanceBetweenCoordinates(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        widget.destination.latitude,
        widget.destination.longitude,
      );
      setState(() {
        _distanceToDestination = distance;
      });
    }
  }

  // Haversine formula to calculate distance between two lat/lng points
  double _getDistanceBetweenCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarthKm = 6371;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radiusOfEarthKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Fetch the route from the current location to the destination
  Future<void> _fetchRoute(LatLng origin, LatLng destination) async {
    String directionsUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_directionsApiKey";

    try {
      final response = await http.get(Uri.parse(directionsUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          List<LatLng> route =
              _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          setState(() {
            _routeCoordinates = route;
            //Clear previous polylines and add a new one
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: _routeCoordinates,
                color: const Color.fromARGB(255, 160, 205, 249),
                width: 5,
              ),
            );
          });
        }
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  // Decode the polyline string to LatLng coordinates
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
  }
}
