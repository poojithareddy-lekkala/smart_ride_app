import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_ride_booking/app.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TripModelAdapter());
  Hive.registerAdapter(RideTypeAdapter());
  Hive.registerAdapter(RideStatusAdapter());
  final box = await Hive.openBox<TripModel>('trips');

  runApp(
    ProviderScope(
      overrides: [tripBoxProvider.overrideWithValue(box)],
      child: const MyApp(),
    ),
  );
}

