import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:smart_ride_booking/core/features/dashbaord/ui/dashboard_screen.dart';
import 'package:smart_ride_booking/core/features/trips/ui/trip_screen.dart';
import 'package:smart_ride_booking/core/features/trips/state/notification_provider.dart';
import 'package:smart_ride_booking/provider.dart';


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  int _currentIndex = 0;

  final _screens = [
    TripScreen(),
    const DashboardScreen(),
  ];

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<String>? _notifSub;

  @override
  Widget build(BuildContext context) {
    _notifSub ??= ref.read(tripNotificationProvider).listen((msg) {
      _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text(msg)));
    });

    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Smart Ride Booking',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Ride Booking'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifSub?.cancel();
    super.dispose();
  }
}
