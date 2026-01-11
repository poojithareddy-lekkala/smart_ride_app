import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/features/trips/state/driver_simulator.dart';
import 'package:smart_ride_booking/core/features/trips/ui/driver_tracking_screen.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/provider.dart';
import 'package:smart_ride_booking/core/features/trips/ui/animated_trip_tile.dart';

import 'package:smart_ride_booking/core/features/trips/ui/add_trip_form.dart';
import 'package:smart_ride_booking/core/features/trips/ui/edit_trip_form.dart';
class TripScreen extends ConsumerWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripProvider);

    ref.listen<List<TripModel>>(tripProvider, (prev, next) {
      ref.read(budgetProvider.notifier).recalculate(next);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Book Ride")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddTripForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh by re-fetching state
          await Future.delayed(const Duration(milliseconds: 500));
          ref.refresh(tripProvider);
        },
        child: ListView(
          children: trips
              .map((t) => Dismissible(
                  key: Key(t.id),
                  background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (_) {
                    final removed = t;
                    final tripNotifier = ref.read(tripProvider.notifier);
                    tripNotifier.removeTrip(t.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleted trip ${t.id}'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            // re-add the removed trip
                            tripNotifier.addTrip(removed);
                          },
                        ),
                      ),
                    );
                  },
                  child: Consumer(
                    builder: (context, ref2, child) {
                      final driverAsync = ref2.watch(driverSimulatorProvider(t.id));
                      final etaWidget = driverAsync.when(
                        data: (loc) => Text('ETA ${loc.etaSeconds}s'),
                        loading: () => const SizedBox(width: 48, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                        error: (e, st) => const Icon(Icons.error_outline),
                      );
                      
                      return AnimatedTripTile(
                        trip: t,
                        onDelete: () {
                          final tripNotifier = ref.read(tripProvider.notifier);
                          tripNotifier.removeTrip(t.id);
                        },
                        onEdit: () {
                          showDialog(context: context, builder: (_) => EditTripForm(trip: t));
                        },
                        onTrack: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => DriverTrackingScreen(tripId: t.id)));
                        },
                        etaWidget: etaWidget,
                      );
                    },
                  ),
                ))
              .toList(),
        ),
      ),
    );
  }
}
