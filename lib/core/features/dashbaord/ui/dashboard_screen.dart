import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/enums/ride_status.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/provider.dart';
import 'package:smart_ride_booking/core/features/budget/ui/budget_settings_screen.dart';
import 'package:smart_ride_booking/core/utils/export_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';



class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripProvider);
    void _openBudget() {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BudgetSettingsScreen()));
    }

    Future<void> _exportTripsData() async {
      try {
        final filePath = await ExportService.exportTripsToCSV(trips);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Trip history exported'),
            action: SnackBarAction(
              label: 'SHARE',
              onPressed: () {
                Share.shareFiles([filePath]);
              },
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    final completedTrips =
        trips.where((t) => t.status == RideStatus.completed).toList();

    final totalSpent = completedTrips.fold<double>(
      0,
      (sum, t) => sum + t.fare,
    );

    final tripCountByType = {
      for (var type in RideType.values)
        type: completedTrips.where((t) => t.rideType == type).length
    };

    final budgets = ref.watch(budgetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(onPressed: () => _exportTripsData(), icon: const Icon(Icons.download)),
          IconButton(onPressed: _openBudget, icon: const Icon(Icons.settings)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh by re-fetching state
          await Future.delayed(const Duration(milliseconds: 500));
          ref.refresh(tripProvider);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard("Completed Trips", completedTrips.length.toString()),
                    _statCard(
                        "Total Spent", "₹${totalSpent.toStringAsFixed(1)}"),
                  ],
                ),

            const SizedBox(height: 20),

            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: tripCountByType.entries.map((entry) {
                    final budget = budgets[entry.key];
                    final color = budget == null
                        ? Colors.blue
                        : (budget.isOverLimit
                            ? Colors.red
                            : (budget.isNearLimit ? Colors.orange : Colors.green));
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      color: color,
                      title: entry.value == 0
                          ? ''
                          : '${entry.key.name}\n${entry.value}',
                      radius: 70,
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Trips",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: completedTrips.take(5).length,
                itemBuilder: (_, index) {
                  final trip = completedTrips.reversed.toList()[index];
                  return ListTile(
                    title: Text("${trip.pickup} → ${trip.drop}"),
                    subtitle: Text(
                      "${trip.rideType.name} | ₹${trip.fare.toStringAsFixed(1)}",
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Legend', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  for (var type in RideType.values)
                    Row(
                      children: [
                        Container(width: 12, height: 12, margin: const EdgeInsets.only(right: 8), color: budgets[type] == null
                            ? Colors.blue
                            : (budgets[type]!.isOverLimit ? Colors.red : (budgets[type]!.isNearLimit ? Colors.orange : Colors.green))),
                        Text(type.name),
                        const SizedBox(width: 8),
                        if (budgets[type] != null)
                          Text('(${budgets[type]!.spent.toStringAsFixed(1)} / ${budgets[type]!.limit.toStringAsFixed(1)})')
                      ],
                    ),
                ],
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
