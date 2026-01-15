# Smart Ride Booking

A small cross-platform Flutter app that simulates a ride-booking flow with live status simulation, driver ETA, local persistence (Hive), Riverpod state, and a simple dashboard.

## What I implemented
- Trip CRUD (add, delete, edit)
- Live ride status simulation (Requested → Driver Assigned → Ride Started → Completed)
- Mock driver tracking with ETA (StreamProvider.family)
- Budget controller for per-ride-type monthly limits and dashboard color-coding
- Local storage abstraction (`TripStorage`) with Hive-backed runtime implementation
- Riverpod for state management with StateNotifier controllers
- Unit & widget tests covering core flows
- Structured logging via `logger` package

## How to run
1. Ensure Flutter 3.x+ is installed and a device/emulator is available.
2. From the project root:

```powershell
flutter pub get
flutter analyze
flutter test --reporter expanded
```

3. To run on an Android emulator or connected device:

```powershell
flutter run
```

If you get a device connection issue, run `flutter devices` and pick a target device.

## Project structure
- `lib/` - application code
	- `core/features/trips` - trip model, controllers, UI
	- `core/features/dashbaord` - dashboard UI
	- `core/features/budget` - budget controller + settings UI
	- `core/utils` - fare calculator, logger
	- `provider.dart` - central Riverpod providers and overrides for tests
- `test/` - unit & widget tests

