import '../enums/ride_type.dart';

class FareCalculator {
  static double calculate(RideType type) {
    final base = {
      RideType.mini: 50,
      RideType.sedan: 80,
      RideType.auto: 30,
      RideType.bike: 20,
    }[type]!;

    final surge = 1 + (DateTime.now().second % 3) * 0.2;
    return base * surge;
  }
}
