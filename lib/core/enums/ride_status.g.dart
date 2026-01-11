// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RideStatusAdapter extends TypeAdapter<RideStatus> {
  @override
  final int typeId = 2;

  @override
  RideStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RideStatus.requested;
      case 1:
        return RideStatus.driverAssigned;
      case 2:
        return RideStatus.rideStarted;
      case 3:
        return RideStatus.completed;
      case 4:
        return RideStatus.cancelled;
      default:
        return RideStatus.requested;
    }
  }

  @override
  void write(BinaryWriter writer, RideStatus obj) {
    switch (obj) {
      case RideStatus.requested:
        writer.writeByte(0);
        break;
      case RideStatus.driverAssigned:
        writer.writeByte(1);
        break;
      case RideStatus.rideStarted:
        writer.writeByte(2);
        break;
      case RideStatus.completed:
        writer.writeByte(3);
        break;
      case RideStatus.cancelled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
