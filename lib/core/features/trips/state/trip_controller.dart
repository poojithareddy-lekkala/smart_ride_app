import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_ride_booking/core/utils/logger.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/utils/fare_calculator.dart';

import '../data/trip_model.dart';
import 'trip_storage.dart';

class TripController extends StateNotifier<List<TripModel>> {
  TripController(this._storage, {Duration tickDuration = const Duration(seconds: 3)})
      : _tickDuration = tickDuration,
        super(_storage.values.toList());

  final Duration _tickDuration;

  final TripStorage _storage;

  void addTrip(TripModel trip) {
    appLogger.i('Adding trip ${trip.id} ${trip.pickup}→${trip.drop} (${trip.rideType.name})');
    _storage.put(trip.id, trip);
    state = [...state, trip];
    _simulate(trip);
  }

  void updateTrip(TripModel trip) {
    appLogger.i('Updating trip ${trip.id}');
    _storage.put(trip.id, trip);
    state = state.map((t) => t.id == trip.id ? trip : t).toList();
  }

  void removeTrip(String id) {
    appLogger.w('Removing trip $id');
    _storage.remove(id);
    state = state.where((t) => t.id != id).toList();
    final timer = _timers.remove(id);
    timer?.cancel();
  }

  final Map<String, Timer> _timers = {};

  void _simulate(TripModel trip) {
    if (_timers.containsKey(trip.id)) return;

    final timer = Timer.periodic(_tickDuration, (timer) {
      if (trip.status.isFinal) {
        timer.cancel();
        _timers.remove(trip.id);
        return;
      }

      final nextStatus = trip.status.next();
      if (nextStatus == null) {
        timer.cancel();
        _timers.remove(trip.id);
        return;
      }

      trip.status = nextStatus;
      appLogger.d('Trip ${trip.id} status -> ${trip.status.name}');
      trip.fare = FareCalculator.calculate(trip.rideType);
      _storage.put(trip.id, trip);

      state = [...state];
    });

    _timers[trip.id] = timer;
  }

  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    appLogger.i('TripController disposed, timers cancelled');
    super.dispose();
  }

  void startSimulationForExisting() {
    for (var trip in _storage.values) {
      if (!trip.status.isFinal) {
        _simulate(trip);
      }
    }
  }
}
