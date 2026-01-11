import 'package:hive/hive.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';


part 'trip_model.g.dart';

@HiveType(typeId: 1)
class TripModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String pickup;

  @HiveField(2)
  String drop;

  @HiveField(3)
  RideType rideType;

  @HiveField(4)
  RideStatus status;

  @HiveField(5)
  double fare;

  @HiveField(6)
  DateTime dateTime;

  TripModel({
    required this.id,
    required this.pickup,
    required this.drop,
    required this.rideType,
    required this.status,
    required this.fare,
    required this.dateTime,
  });
}
