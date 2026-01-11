import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/features/dashbaord/ui/dashboard_screen.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/provider.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_storage.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_controller.dart';

void main() {
  testWidgets('Dashboard shows totals and legend', (tester) async {
    // Fake storage with one completed trip
    final storage = _FakeStorage();
    final controller = TripController(storage, tickDuration: const Duration(seconds: 3600));

    final trip = TripModel(
      id: 't1',
      pickup: 'A',
      drop: 'B',
      rideType: RideType.mini,
      status: RideStatus.completed,
      fare: 100,
      dateTime: DateTime.now(),
    );

    controller.addTrip(trip);

  await tester.pumpWidget(ProviderScope(overrides: [tripControllerOverrideProvider.overrideWithValue(controller)], child: const MaterialApp(home: DashboardScreen())));

    await tester.pumpAndSettle();

    expect(find.text('Completed Trips'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.textContaining('mini', findRichText: false), findsAtLeastNWidgets(1));

  // controller is provided to the widget tree and will be disposed with the ProviderScope
  });
}

class _FakeStorage implements TripStorage {
  final Map<String, TripModel> _m = {};

  @override
  Iterable<TripModel> get values => _m.values;

  @override
  Future<void> put(String id, TripModel trip) async {
    _m[id] = trip;
  }

  @override
  Future<void> remove(String id) async {
    _m.remove(id);
  }
}
