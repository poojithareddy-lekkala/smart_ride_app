import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import '../../trips/data/trip_model.dart';

class BudgetState {
  final double limit;
  final double spent;

  BudgetState({required this.limit, required this.spent});

  bool get isOverLimit => spent > limit;
  bool get isNearLimit => spent >= limit * 0.8;
}

class BudgetController
    extends StateNotifier<Map<RideType, BudgetState>> {
  BudgetController() : super({});

  void setLimit(RideType type, double limit) {
    state = {
      ...state,
      type: BudgetState(limit: limit, spent: 0),
    };
  }

  void recalculate(List<TripModel> trips) {
    final spent = <RideType, double>{};

    for (final t in trips) {
      if (t.status == RideStatus.completed) {
        spent[t.rideType] =
            (spent[t.rideType] ?? 0) + t.fare;
      }
    }

    final newState = <RideType, BudgetState>{};

    for (final e in state.entries) {
      newState[e.key] =
          BudgetState(limit: e.value.limit, spent: spent[e.key] ?? 0);
    }

    state = newState;
  }
}
