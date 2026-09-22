import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single accent (color dot)
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

/// Ready-made presets — each has a name + gradient + accent
class AppPreset {
  const AppPreset(this.id, this.nameRu, this.nameEn, this.accent, this.gradient);
  final String id;
  final String nameRu;
  final String nameEn;
  final AppAccent accent;
  final List<Color> gradient; // for preview card
  String label(String lang) => lang == 'ru' ? nameRu : nameEn;

  static const presets = [
    AppPreset('midnight', 'Полночь', 'Midnight', AppAccent.purple, [Color(0xFF0B0D14), Color(0xFF1A1C2E)]),
    AppPreset('ocean', 'Океан', 'Ocean', AppAccent.cyan, [Color(0xFF0A1628), Color(0xFF0E3A4A)]),
    AppPreset('forest', 'Лес', 'Forest', AppAccent.lime, [Color(0xFF0D1B12), Color(0xFF1E3A2E)]),
    AppPreset('sunset', 'Закат', 'Sunset', AppAccent.orange, [Color(0xFF1A0F0A), Color(0xFF4A2010)]),
    AppPreset('berry', 'Ягода', 'Berry', AppAccent.pink, [Color(0xFF1A0E1A), Color(0xFF3A1A3A)]),
    AppPreset('arctic', 'Арктика', 'Arctic', AppAccent.blue, [Color(0xFF0F1729), Color(0xFF1E3A5F)]),
    AppPreset('light', 'Светлая', 'Light', AppAccent.purple, [Color(0xFFF5F6FA), Color(0xFFE8ECF5)]),
    AppPreset('sand', 'Песок', 'Sand', AppAccent.orange, [Color(0xFFFAF6F0), Color(0xFFE8DCC8)]),
  ];

  static AppPreset byId(String id) =>
      presets.firstWhere((p) => p.id == id, orElse: () => presets.first);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;
  AppAccent _accent = AppAccent.purple;
  AppPreset _preset = AppPreset.presets[0];
  bool _animationsEnabled = true;

  ThemeMode get mode => _mode;
  AppAccent get accent => _accent;
  AppPreset get preset => _preset;
  bool get animationsEnabled => _animationsEnabled;
  bool get isDark => _mode == ThemeMode.dark;

  static const _kMode = 'theme_mode';
  static const _kAccent = 'theme_accent';
  static const _kPreset = 'theme_preset';
  static const _kAnim = 'theme_anim';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final m = p.getString(_kMode);
    if (m == 'light') _mode = ThemeMode.light;
    if (m == 'dark') _mode = ThemeMode.dark;
    if (m == 'system') _mode = ThemeMode.system;
    final a = p.getString(_kAccent);
    if (a != null) {
      for (final v in AppAccent.values) if (v.name == a) _accent = v;
    }
    final pr = p.getString(_kPreset);
    if (pr != null) _preset = AppPreset.byId(pr);
    _animationsEnabled = p.getBool(_kAnim) ?? true;
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kMode, _mode.name);
    await p.setString(_kAccent, _accent.name);
    await p.setString(_kPreset, _preset.id);
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

  void setPreset(AppPreset pr) {
    _preset = pr;
    _accent = pr.accent;
    // auto switch light/dark based on preset
    if (pr.id == 'light' || pr.id == 'sand') {
      _mode = ThemeMode.light;
    } else {
      _mode = ThemeMode.dark;
    }
    _save();
    notifyListeners();
  }

  void setAnimations(bool v) {
    _animationsEnabled = v;
    _save();
    notifyListeners();
  }

  Duration get animDuration =>
      _animationsEnabled ? const Duration(milliseconds: 280) : Duration.zero;
  Curve get animCurve =>
      _animationsEnabled ? Curves.easeOutCubic : Curves.linear;
}
