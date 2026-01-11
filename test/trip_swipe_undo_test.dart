import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_controller.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_storage.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/features/trips/ui/trip_screen.dart';
import 'package:smart_ride_booking/provider.dart';
import 'package:smart_ride_booking/core/features/trips/state/driver_simulator.dart';

class FakeTripStorage implements TripStorage {
  final Map<String, TripModel> _map = {};

  FakeTripStorage([Iterable<TripModel>? initial]) {
    if (initial != null) {
      for (var t in initial) {
        _map[t.id] = t;
      }
    }
  }

  @override
  Iterable<TripModel> get values => _map.values;

  @override
  Future<void> put(String id, TripModel trip) async {
    _map[id] = trip;
  }

  @override
  Future<void> remove(String id) async {
    _map.remove(id);
  }
}

void main() {
  testWidgets('swipe to delete then undo restores trip', (tester) async {
    final initial = TripModel(
      id: 't1',
      pickup: 'Office',
      drop: 'Home',
      rideType: RideType.mini,
      status: RideStatus.completed, // completed so no timers
      fare: 100,
      dateTime: DateTime.now(),
    );

    final storage = FakeTripStorage([initial]);
    final controller = TripController(storage, tickDuration: const Duration(days: 1));

    // override driver simulator for this trip id with a single ready value to avoid timers
    final driverOverride = AsyncValue.data(DriverLocation(lat: 0, lng: 0, etaSeconds: 0));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripControllerOverrideProvider.overrideWithValue(controller),
          driverSimulatorProvider(initial.id).overrideWithValue(driverOverride),
        ],
        child: const MaterialApp(home: TripScreen()),
      ),
    );

    // initial trip is visible
    expect(find.text('Office → Home'), findsOneWidget);

    // swipe to dismiss
    final dismissible = find.byType(Dismissible).first;
    await tester.drag(dismissible, const Offset(-400, 0));
    await tester.pumpAndSettle();

    // should be removed from the list
    expect(find.text('Office → Home'), findsNothing);

    // snackbar with UNDO should be visible
    expect(find.text('UNDO'), findsOneWidget);

    // tap UNDO
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    // trip should reappear
    expect(find.text('Office → Home'), findsOneWidget);
  });
}
