// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// no direct material imports required for this test
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_ride_booking/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/provider.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_controller.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_storage.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  // Provide a fake TripController so providers relying on Hive don't throw.
  final storage = _TestFakeStorage();
  final controller = TripController(storage, tickDuration: const Duration(seconds: 3600));
  await tester.pumpWidget(ProviderScope(overrides: [tripControllerOverrideProvider.overrideWithValue(controller)], child: const MyApp()));

  // Verify main navigation items exist
  expect(find.text('Trips'), findsOneWidget);
  expect(find.text('Dashboard'), findsOneWidget);
  });
}

class _TestFakeStorage implements TripStorage {
  final Map<String, dynamic> _m = {};

  @override
  Iterable<TripModel> get values => _m.values.cast<TripModel>();

  @override
  Future<void> put(String id, TripModel trip) async {
    _m[id] = trip;
  }

  @override
  Future<void> remove(String id) async {
    _m.remove(id);
  }
}
