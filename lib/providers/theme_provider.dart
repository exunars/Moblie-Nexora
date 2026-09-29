import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/trade_theme.dart';

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

/// Ready-made presets — each has dark + light palettes + accent
class AppPreset {
  const AppPreset(this.id, this.nameRu, this.nameEn, this.accent, this.darkPalette, this.lightPalette, this.gradient);
  final String id;
  final String nameRu;
  final String nameEn;
  final AppAccent accent;
  final AppPalette darkPalette;
  final AppPalette lightPalette;
  final List<Color> gradient;
  String label(String lang) => lang == 'ru' ? nameRu : nameEn;
  AppPalette paletteFor(Brightness b) => b == Brightness.dark ? darkPalette : lightPalette;
  // backward compat
  AppPalette get palette => darkPalette;

  static const presets = [
    AppPreset('midnight', 'Полночь', 'Midnight', AppAccent.purple,
        AppPalette(background: Color(0xFF0A0C14), surface: Color(0xFF12141F), card: Color(0xFF1C1E2E), border: Color(0xFF2E3350), primaryText: Color(0xFFFFFFFF), secondaryText: Color(0xFFB8BFDB), tertiaryText: Color(0xFF6E7696)),
        AppPalette(background: Color(0xFFF0F1F8), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFDDD9F0), primaryText: Color(0xFF1A1C2E), secondaryText: Color(0xFF6B6E8A), tertiaryText: Color(0xFF9A9CBB)),
        [Color(0xFF1B1E35), Color(0xFF3B2F6B)]),
    AppPreset('ocean', 'Океан', 'Ocean', AppAccent.cyan,
        AppPalette(background: Color(0xFF07121E), surface: Color(0xFF0E1E32), card: Color(0xFF152A45), border: Color(0xFF1E3F62), primaryText: Color(0xFFE6F2FF), secondaryText: Color(0xFF8FB4D6), tertiaryText: Color(0xFF5C84AA)),
        AppPalette(background: Color(0xFFEEF6FA), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFC8DDE8), primaryText: Color(0xFF0E1E32), secondaryText: Color(0xFF5A7A8E), tertiaryText: Color(0xFF8AB4C8)),
        [Color(0xFF0B2E4A), Color(0xFF1AB2C0)]),
    AppPreset('forest', 'Лес', 'Forest', AppAccent.lime,
        AppPalette(background: Color(0xFF09140E), surface: Color(0xFF132619), card: Color(0xFF1B3624), border: Color(0xFF28543A), primaryText: Color(0xFFE6F5EA), secondaryText: Color(0xFF8EC0A0), tertiaryText: Color(0xFF5E9A78)),
        AppPalette(background: Color(0xFFEEF6F0), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFC8DDD0), primaryText: Color(0xFF132619), secondaryText: Color(0xFF5A7A64), tertiaryText: Color(0xFF8EC0A0)),
        [Color(0xFF143D22), Color(0xFF2EB872)]),
    AppPreset('sunset', 'Закат', 'Sunset', AppAccent.orange,
        AppPalette(background: Color(0xFF1A120E), surface: Color(0xFF2A1E16), card: Color(0xFF3D2A1C), border: Color(0xFF5A3D2A), primaryText: Color(0xFFFFF1E6), secondaryText: Color(0xFFD4B49A), tertiaryText: Color(0xFF9A7A62)),
        AppPalette(background: Color(0xFFFFF4EE), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFE8D5C8), primaryText: Color(0xFF2A1E16), secondaryText: Color(0xFF8A6E5A), tertiaryText: Color(0xFFBFA090)),
        [Color(0xFF4E2310), Color(0xFFFF7A45)]),
    AppPreset('berry', 'Ягода', 'Berry', AppAccent.pink,
        AppPalette(background: Color(0xFF160E1A), surface: Color(0xFF241530), card: Color(0xFF341E42), border: Color(0xFF5A2E6B), primaryText: Color(0xFFFBE8FF), secondaryText: Color(0xFFD4A6DF), tertiaryText: Color(0xFF9A6EAF)),
        AppPalette(background: Color(0xFFFBF0FF), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFE4C8F0), primaryText: Color(0xFF241530), secondaryText: Color(0xFF8A6E8A), tertiaryText: Color(0xFFB894C8)),
        [Color(0xFF402050), Color(0xFFD65DB1)]),
    AppPreset('arctic', 'Арктика', 'Arctic', AppAccent.blue,
        AppPalette(background: Color(0xFF0C1326), surface: Color(0xFF151F3A), card: Color(0xFF1E2D52), border: Color(0xFF2D4273), primaryText: Color(0xFFE8EEFF), secondaryText: Color(0xFF94AAD6), tertiaryText: Color(0xFF627AAF)),
        AppPalette(background: Color(0xFFEEF2FF), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFC8D4F0), primaryText: Color(0xFF151F3A), secondaryText: Color(0xFF5A6E9A), tertiaryText: Color(0xFF94AAD6)),
        [Color(0xFF1A2F5C), Color(0xFF5B8DEF)]),
    AppPreset('light', 'Светлая', 'Light', AppAccent.purple,
        AppPalette(background: Color(0xFF141422), surface: Color(0xFF1E1E32), card: Color(0xFF2A2A44), border: Color(0xFF3A3A5A), primaryText: Color(0xFFFFFFFF), secondaryText: Color(0xFFC8C8E8), tertiaryText: Color(0xFF8A8AC0)),
        AppPalette(background: Color(0xFFF2F4FA), surface: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF), border: Color(0xFFDFE4F0), primaryText: Color(0xFF15182A), secondaryText: Color(0xFF6B7280), tertiaryText: Color(0xFF9CA3AF)),
        [Color(0xFFE8ECF8), Color(0xFF9A8CFF)]),
    AppPreset('sand', 'Песок', 'Sand', AppAccent.orange,
        AppPalette(background: Color(0xFF1A150E), surface: Color(0xFF2A2418), card: Color(0xFF3A3224), border: Color(0xFF4E4430), primaryText: Color(0xFFFFF8EE), secondaryText: Color(0xFFD4C4A8), tertiaryText: Color(0xFF9A8A6E)),
        AppPalette(background: Color(0xFFFAF7F2), surface: Color(0xFFF5EDE2), card: Color(0xFFFFFFFF), border: Color(0xFFE6DDD0), primaryText: Color(0xFF2B1E12), secondaryText: Color(0xFF8A7A68), tertiaryText: Color(0xFFAB9A88)),
        [Color(0xFFE8DDC6), Color(0xFFD4A574)]),
  ];

  static AppPreset byId(String id) => presets.firstWhere((p) => p.id == id, orElse: () => presets.first);
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
      for (final v in AppAccent.values) {
        if (v.name == a) _accent = v;
      }
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
    _save();
    notifyListeners();
  }

  void setAnimations(bool v) {
    _animationsEnabled = v;
    _save();
    notifyListeners();
  }

  Duration get animDuration => _animationsEnabled ? const Duration(milliseconds: 280) : Duration.zero;
  Curve get animCurve => _animationsEnabled ? Curves.easeOutCubic : Curves.linear;
}
