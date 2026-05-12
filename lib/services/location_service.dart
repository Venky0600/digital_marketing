import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

/// LocationService provides real device GPS integration.
/// Used for nearby campaign, influencer, and franchise discovery.
class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _lastKnownPosition;

  /// Returns the last known cached position, or null if not yet fetched.
  Position? get lastKnownPosition => _lastKnownPosition;

  /// Checks and requests location permission, then fetches current position.
  /// Returns [Position] on success, throws descriptive [Exception] on failure.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS in device settings.');
    }

    // Check current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission from the user
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied. Please allow location access to discover nearby opportunities.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied. Please enable it in app settings.');
    }

    // Permission granted — fetch current position
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Only update if device moves more than 100m
      ),
    );

    _lastKnownPosition = position;

    if (kDebugMode) {
      print('LocationService: Got position — lat: ${position.latitude}, lng: ${position.longitude}');
    }

    return position;
  }

  /// Returns current position as a human-readable string (for debugging/display).
  String formatPosition(Position position) {
    return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
  }

  /// Calculates distance in kilometers between two lat/lng points.
  double distanceBetween(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) / 1000.0;
  }
}
