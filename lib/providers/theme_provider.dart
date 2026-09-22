import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppAccent {
  purple(Color(0xFF9A8CFF), 'Purple'),
  cyan(Color(0xFF00CEC9), 'Cyan'),
  lime(Color(0xFF00B894), 'Lime'),
  pink(Color(0xFFFD79A8), 'Pink'),
  orange(Color(0xFFE17055), 'Orange'),
  blue(Color(0xFF74B9FF), 'Blue');

  const AppAccent(this.color, this.label);
  final Color color;
  final String label;
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;
  AppAccent _accent = AppAccent.purple;
  bool _animationsEnabled = true;

  ThemeMode get mode => _mode;
  AppAccent get accent => _accent;
  bool get animationsEnabled => _animationsEnabled;
  bool get isDark => _mode == ThemeMode.dark;

  static const _kMode = 'theme_mode';
  static const _kAccent = 'theme_accent';
  static const _kAnim = 'theme_anim';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final m = p.getString(_kMode);
    if (m == 'light') _mode = ThemeMode.light;
    if (m == 'dark') _mode = ThemeMode.dark;
    if (m == 'system') _mode = ThemeMode.system;
    final a = p.getString(_kAccent);
    if (a != null) {
      for (final v in AppAccent.values) {
        if (v.name == a) _accent = v;
      }
    }
    _animationsEnabled = p.getBool(_kAnim) ?? true;
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kMode, _mode.name);
    await p.setString(_kAccent, _accent.name);
    await p.setBool(_kAnim, _animationsEnabled);
  }

  void setMode(ThemeMode m) {
    _mode = m;
    _save();
    notifyListeners();
  }

  void toggleDarkLight() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _save();
    notifyListeners();
  }

  void setAccent(AppAccent a) {
    _accent = a;
    _save();
    notifyListeners();
  }

  void setAnimations(bool v) {
    _animationsEnabled = v;
    _save();
    notifyListeners();
  }

  Duration get animDuration => _animationsEnabled ? const Duration(milliseconds: 220) : Duration.zero;
  Curve get animCurve => _animationsEnabled ? Curves.easeOutCubic : Curves.linear;
}
