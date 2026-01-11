import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ThemeController extends StateNotifier<bool> {
  ThemeController() : super(false);

  void toggleTheme() {
    state = !state;
  }

  void setDarkMode(bool isDark) {
    state = isDark;
  }

  bool get isDarkMode => state;
}
