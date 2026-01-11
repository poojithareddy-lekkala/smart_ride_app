import 'package:hive/hive.dart';
import '../data/trip_model.dart';

abstract class TripStorage {
  Iterable<TripModel> get values;

  Future<void> put(String id, TripModel trip);
  Future<void> remove(String id);
}

class HiveTripStorage implements TripStorage {
  HiveTripStorage(this.box);

  final Box<TripModel> box;
  
  static const int simulatedLatency = 300;

  @override
  Iterable<TripModel> get values => box.values;

  @override
  Future<void> put(String id, TripModel trip) async {
    await Future.delayed(const Duration(milliseconds: simulatedLatency));
    await box.put(id, trip);
  }

  @override
  Future<void> remove(String id) async {
    await Future.delayed(const Duration(milliseconds: simulatedLatency));
    await box.delete(id);
  }
}
