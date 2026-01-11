import 'package:hive/hive.dart';

part 'ride_status.g.dart';

@HiveType(typeId: 2)
enum RideStatus {
  @HiveField(0)
  requested,

  @HiveField(1)
  driverAssigned,

  @HiveField(2)
  rideStarted,

  @HiveField(3)
  completed,

  @HiveField(4)
  cancelled,
}

extension RideStatusX on RideStatus {
  String get displayName {
    switch (this) {
      case RideStatus.requested:
        return 'Requested';
      case RideStatus.driverAssigned:
        return 'Driver Assigned';
      case RideStatus.rideStarted:
        return 'Ride Started';
      case RideStatus.completed:
        return 'Completed';
      case RideStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isFinal => this == RideStatus.completed || this == RideStatus.cancelled;

  RideStatus? next() {
    switch (this) {
      case RideStatus.requested:
        return RideStatus.driverAssigned;
      case RideStatus.driverAssigned:
        return RideStatus.rideStarted;
      case RideStatus.rideStarted:
        return RideStatus.completed;
      case RideStatus.completed:
      case RideStatus.cancelled:
        return null;
    }
  }

  String toShortString() => toString().split('.').last;
}
