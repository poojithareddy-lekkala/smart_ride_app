import 'package:flutter/material.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';

/// Animated trip list tile with status and fare updates
class AnimatedTripTile extends StatefulWidget {
  final TripModel trip;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onTrack;
  final Widget etaWidget;

  const AnimatedTripTile({
    super.key,
    required this.trip,
    required this.onDelete,
    required this.onEdit,
    required this.onTrack,
    required this.etaWidget,
  });

  @override
  State<AnimatedTripTile> createState() => _AnimatedTripTileState();
}

class _AnimatedTripTileState extends State<AnimatedTripTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedTripTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate if status changed
    if (oldWidget.trip.status != widget.trip.status) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text("${widget.trip.pickup} → ${widget.trip.drop}"),
            subtitle: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.trip.status.displayName),
                      Text(
                        '₹${widget.trip.fare.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.etaWidget,
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.directions_car),
                  onPressed: widget.onTrack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
