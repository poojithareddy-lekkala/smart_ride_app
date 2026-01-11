import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_controller.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_storage.dart';


// Lightweight fake storage so tests don't depend on Hive
class FakeTripStorage implements TripStorage {
  final Map<String, TripModel> _map = {};

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
  group('TripController simulation', () {
    test('progresses from requested -> completed over time', () async {
      final storage = FakeTripStorage();
      final controller = TripController(storage, tickDuration: const Duration(milliseconds: 10));

      final trip = TripModel(
        id: 't1',
        pickup: 'A',
        drop: 'B',
        rideType: RideType.mini,
        status: RideStatus.requested,
        fare: 10.0,
        dateTime: DateTime.now(),
      );

      controller.addTrip(trip);

      // wait some time for the fast ticks to run
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.state.any((t) => t.id == 't1' && t.status == RideStatus.completed), isTrue);
    });
  });
}
