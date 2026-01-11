import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/features/trips/state/driver_simulator.dart';

class DriverTrackingScreen extends ConsumerWidget {
  final String tripId;

  const DriverTrackingScreen({required this.tripId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locAsync = ref.watch(driverSimulatorProvider(tripId));

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Tracking')),
      body: Center(
        child: locAsync.when(
          data: (loc) {
            final t = ((loc.lat % 1) + (loc.lng % 1)) / 2;
            final offset = (t * MediaQuery.of(context).size.width * 0.6) - 0.3 * MediaQuery.of(context).size.width;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ETA: ${loc.etaSeconds}s', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 800),
                        left: offset.clamp(0.0, MediaQuery.of(context).size.width * 0.8 - 24),
                        top: 28,
                        child: Container(width: 24, height: 24, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => const Icon(Icons.error_outline),
        ),
      ),
    );
  }
}
