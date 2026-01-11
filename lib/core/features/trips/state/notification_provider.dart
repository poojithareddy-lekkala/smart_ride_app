import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/provider.dart';

final tripNotificationProvider = Provider<Stream<String>>((ref) {
  final controller = StreamController<String>.broadcast();

  ref.listen<List<TripModel>>(tripProvider, (previous, next) {
    final prev = previous ?? <TripModel>[];
    final prevMap = {for (var t in prev) t.id: t.status};

    for (var t in next) {
      final pStatus = prevMap[t.id];
      if (pStatus != null && pStatus != t.status) {
  controller.add('Trip ${t.id} — ${t.status.toShortString()}');
      }
    }
  });

  ref.onDispose(() => controller.close());
  return controller.stream;
});
