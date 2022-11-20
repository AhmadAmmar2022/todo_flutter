import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(color: Color.fromARGB(248, 141, 121, 250)),
    primaryColor: Color.fromARGB(248, 141, 121, 250),
    colorScheme: ColorScheme.dark(primary: Color.fromARGB(188, 213, 130, 252)),
    iconTheme:
        IconThemeData(color: Color.fromARGB(255, 255, 255, 255), opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(color: Color.fromARGB(255, 223, 74, 37)),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color.fromARGB(255, 223, 74, 37),
    colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 223, 74, 37)),
    iconTheme:
        IconThemeData(color: Color.fromARGB(255, 233, 228, 226), opacity: 0.8),
  );
}
