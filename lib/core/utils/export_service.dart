import 'dart:io';
import 'package:smart_ride_booking/core/features/trips/data/trip_model.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  static Future<String> exportTripsToCSV(List<TripModel> trips) async {
    final csv = StringBuffer();
    
    csv.writeln('ID,Pickup,Drop,Ride Type,Status,Fare,Date Time');
    
    for (final trip in trips) {
      csv.writeln(
        '${trip.id},'
        '${trip.pickup},'
        '${trip.drop},'
        '${trip.rideType.name},'
        '${trip.status.name},'
        '${trip.fare},'
        '${trip.dateTime.toIso8601String()}',
      );
    }
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/trips_export_$timestamp.csv');
    
    await file.writeAsString(csv.toString());
    
    return file.path;
  }

  static Future<String> exportBudgetReport(
    Map<String, double> budgetLimits,
    Map<String, double> budgetSpent,
  ) async {
    final csv = StringBuffer();
    
    csv.writeln('Ride Type,Monthly Limit,Amount Spent,Remaining,Status');
    
    for (final entry in budgetLimits.entries) {
      final rideType = entry.key;
      final limit = entry.value;
      final spent = budgetSpent[rideType] ?? 0.0;
      final remaining = limit - spent;
      final status = spent > limit ? 'OVER_LIMIT' : spent >= limit * 0.8 ? 'NEAR_LIMIT' : 'OK';
      
      csv.writeln('$rideType,$limit,$spent,$remaining,$status');
    }
    
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/budget_report_$timestamp.csv');
    
    await file.writeAsString(csv.toString());
    
    return file.path;
  }
}
