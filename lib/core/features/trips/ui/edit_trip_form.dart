import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/provider.dart';

class EditTripForm extends ConsumerStatefulWidget {
  final TripModel trip;
  const EditTripForm({super.key, required this.trip});

  @override
  ConsumerState<EditTripForm> createState() => _EditTripFormState();
}

class _EditTripFormState extends ConsumerState<EditTripForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pickup;
  late final TextEditingController _drop;
  late RideType _selected;

  @override
  void initState() {
    super.initState();
    _pickup = TextEditingController(text: widget.trip.pickup);
    _drop = TextEditingController(text: widget.trip.drop);
    _selected = widget.trip.rideType;
  }

  @override
  void dispose() {
    _pickup.dispose();
    _drop.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final updated = TripModel(
      id: widget.trip.id,
      pickup: _pickup.text.trim(),
      drop: _drop.text.trim(),
      rideType: _selected,
      status: widget.trip.status,
      fare: widget.trip.fare,
      dateTime: widget.trip.dateTime,
    );

    ref.read(tripProvider.notifier).updateTrip(updated);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip updated')));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Trip'),
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
        ElevatedButton(onPressed: _submit, child: const Text('SAVE')),
      ],
    );
  }
}
