import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverLocation {
  final double lat;
  final double lng;
  final int etaSeconds;

  DriverLocation({required this.lat, required this.lng, required this.etaSeconds});
}


final driverSimulatorProvider = StreamProvider.family<DriverLocation, String>((ref, tripId) {
  var eta = 30;
  var lat = 12.0;
  var lng = 77.0;

  return Stream<DriverLocation>.periodic(const Duration(seconds: 3), (_) {
    lat += 0.001;
    lng += 0.001;
    eta = (eta - 3).clamp(0, 9999);
    return DriverLocation(lat: lat, lng: lng, etaSeconds: eta);
  }).takeWhile((loc) => loc.etaSeconds > 0).asBroadcastStream();
});
