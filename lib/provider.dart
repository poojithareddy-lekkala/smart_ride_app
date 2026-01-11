import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:smart_ride_booking/core/features/budget/state/budget_controller.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_controller.dart';
import 'package:smart_ride_booking/core/features/trips/state/trip_storage.dart';
import 'package:smart_ride_booking/core/features/theme/state/theme_controller.dart';

final tripBoxProvider =
    Provider<Box<TripModel>>((ref) => throw UnimplementedError());

final tripControllerOverrideProvider = Provider<TripController?>((ref) => null);

final tripProvider =
    StateNotifierProvider<TripController, List<TripModel>>(
  (ref) {
    final override = ref.read(tripControllerOverrideProvider);
    if (override != null) return override;

    final box = ref.read(tripBoxProvider);
    final storage = HiveTripStorage(box);
    final controller = TripController(storage);
    controller.startSimulationForExisting();
    return controller;
  },
);
final budgetProvider =
    StateNotifierProvider<BudgetController, Map>(
  (ref) => BudgetController(),
);

final themeProvider = StateNotifierProvider<ThemeController, bool>(
  (ref) => ThemeController(),
);

