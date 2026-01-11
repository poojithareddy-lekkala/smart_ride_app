import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/provider.dart';

class AddTripForm extends ConsumerStatefulWidget {
  const AddTripForm({super.key});

  @override
  ConsumerState<AddTripForm> createState() => _AddTripFormState();
}

class _AddTripFormState extends ConsumerState<AddTripForm> {
  final _formKey = GlobalKey<FormState>();
  final _pickup = TextEditingController();
  final _drop = TextEditingController();
  
  RideType _selected = RideType.mini;

  @override
  void dispose() {
    _pickup.dispose();
    _drop.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final trip = TripModel(
        id: const Uuid().v4(),
        pickup: _pickup.text.trim(),
        drop: _drop.text.trim(),
        rideType: _selected,
        status: RideStatus.requested,
        fare: 0,
        dateTime: DateTime.now(),
      );

      ref.read(tripProvider.notifier).addTrip(trip);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip requested')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(8.0),
      title: const Text('Request a ride'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _pickup,
              decoration: const InputDecoration(labelText: 'Pickup location'),
              validator: (v) => (v ?? '').trim().isEmpty ? 'Enter pickup' : null,
            ),
            TextFormField(
              controller: _drop,
              decoration: const InputDecoration(labelText: 'Drop location'),
              validator: (v) {
                final text = (v ?? '').trim();
                if (text.isEmpty) return 'Enter drop location';
                if (text == _pickup.text.trim()) return 'Pickup and drop must differ';
                return null;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<RideType>(
              initialValue: _selected,
              items: RideType.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selected = v);
              },
              decoration: const InputDecoration(labelText: 'Ride type'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CANCEL')),
        ElevatedButton(onPressed: _submit, child: const Text('REQUEST')),
      ],
    );
  }
}
