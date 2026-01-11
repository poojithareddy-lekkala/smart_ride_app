import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_ride_booking/core/enums/ride_type.dart';
import 'package:smart_ride_booking/provider.dart';
import 'package:smart_ride_booking/core/utils/export_service.dart';
import 'package:share_plus/share_plus.dart';

class BudgetSettingsScreen extends ConsumerStatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  ConsumerState<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends ConsumerState<BudgetSettingsScreen> {
  final _controllers = <RideType, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    final budgets = ref.read(budgetProvider);
    for (var r in RideType.values) {
      final initial = budgets[r]?.limit ?? 0.0;
      _controllers[r] = TextEditingController(text: initial > 0 ? initial.toStringAsFixed(0) : '');
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) c.dispose();
    super.dispose();
  }

  void _save() {
    for (var r in RideType.values) {
      final text = _controllers[r]!.text.trim();
      if (text.isEmpty) continue;
      final value = double.tryParse(text);
      if (value == null) continue;
      ref.read(budgetProvider.notifier).setLimit(r, value);
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budgets updated')));
  }

  Future<void> _exportBudgetReport() async {
    try {
      final budgets = ref.read(budgetProvider);
      final budgetLimits = <String, double>{};
      final budgetSpent = <String, double>{};

      for (var r in RideType.values) {
        final budget = budgets[r];
        budgetLimits[r.name] = budget?.limit ?? 0.0;
        budgetSpent[r.name] = budget?.spent ?? 0.0;
      }

      final filePath = await ExportService.exportBudgetReport(
        budgetLimits,
        budgetSpent,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Budget report exported'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var r in RideType.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(r.name)),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _controllers[r],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(suffixText: '₹'),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('SAVE'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _exportBudgetReport,
                  icon: const Icon(Icons.download),
                  label: const Text('EXPORT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
