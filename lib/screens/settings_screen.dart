import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/app_strings.dart';
import '../services/notification_service.dart';
import '../theme/trade_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key, required this.locale, required this.onLocaleChanged});

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _paperTradingEnabled = true;
  bool _botEnabled = true;
  String _strategy = 'Balanced';
  double _riskLevel = 35;
  bool _twoFactorEnabled = false;
  final List<String> _connectedExchanges = [];

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(widget.locale);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _profileCard(context),
        const SizedBox(height: 24),
        _sectionLabel(strings.get('account')),
        _panel(children: [
          _item(Icons.person_outline_rounded, strings.get('profile'),
              'user@example.com'),
          _divider(),
          _item(
              Icons.shield_outlined,
              strings.get('security'),
              _twoFactorEnabled
                  ? strings.get('two_fa_enabled')
                  : strings.get('password_2fa'),
              onTap: _showTwoFactorDialog),
        ]),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('trading')),
        _panel(children: [
          _switchItem(
              Icons.science_outlined,
              strings.get('paper_trading_label'),
              strings.get('no_real_funds'),
              _paperTradingEnabled,
              (value) => setState(() => _paperTradingEnabled = value)),
          _divider(),
          _item(
              Icons.key_rounded,
              strings.get('exchange_api'),
              _connectedExchanges.isEmpty
                  ? strings.get('not_configured')
                  : '${_connectedExchanges.length} ${strings.get('connected')}',
              onTap: _showExchangeDialog),
        ]),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('bots_section')),
        _botPanel(context),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('application')),
        _panel(children: [
          _switchItem(
              Icons.notifications_none_rounded,
              strings.get('app_notifications'),
              strings.get('push_signals'),
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value)),
          _divider(),
          _switchItem(
              Icons.fingerprint_rounded,
              strings.get('biometrics'),
              strings.get('quick_login'),
              _biometricsEnabled,
              (value) => setState(() => _biometricsEnabled = value)),
          _divider(),
          _item(Icons.language_rounded, strings.get('language'), _languageName,
              onTap: _showLanguageDialog),
          _divider(),
          _item(Icons.info_outline_rounded, strings.get('about'), 'Nexora 0.9'),
        ]),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('appearance')),
        _appearancePanel(context, strings),
        const SizedBox(height: 20),
        _sectionLabel(strings.get('debug')),
        _panel(children: [
          _item(Icons.notifications_active_outlined, strings.get('test_push'),
              strings.get('test_push_desc'),
              onTap: _sendTestPush),
        ]),
      ],
    );
  }

  String get _languageName => switch (widget.locale.languageCode) {
        'en' => 'English',
        'uk' => 'Українська',
        _ => 'Русский',
      };

  AppStrings get _strings => AppStrings(widget.locale);

  Widget _profileCard(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: accent,
          child: Text('TB',
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Trade Bot', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 3),
          Text(_strings.get('demo_account'),
              style: Theme.of(context).textTheme.bodyMedium),
        ])),
        Icon(Icons.chevron_right_rounded, color: Theme.of(context).textTheme.bodyMedium?.color),
      ]),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(label,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
      );

  Widget _panel({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(18)),
        child: Column(children: children),
      );

  Widget _divider() =>
      Divider(height: 1, indent: 62, endIndent: 16, color: Theme.of(context).dividerColor.withValues(alpha: 0.12));

  Widget _item(IconData icon, String title, String subtitle,
          {VoidCallback? onTap}) =>
      Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right_rounded,
              color: Theme.of(context).textTheme.bodySmall?.color),
          onTap: onTap ?? () {},
        ),
      );

  Widget _switchItem(IconData icon, String title, String subtitle, bool value,
          ValueChanged<bool> onChanged) =>
      Material(
        color: Colors.transparent,
        child: SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle),
          value: value,
          
          onChanged: onChanged,
        ),
      );

  Widget _botPanel(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Material(
            color: Colors.transparent,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary:
                  const Icon(Icons.smart_toy_outlined, color: TradeColors.accentLime),
              title: const Text('Momentum Bot'),
              subtitle: Text(_botEnabled
                  ? 'Работает по стратегии $_strategy'
                  : 'Приостановлен'),
              value: _botEnabled,
              activeThumbColor: TradeColors.accentLime,
              onChanged: (value) => setState(() => _botEnabled = value),
            ),
          ),
          const SizedBox(height: 8),
          Text(_strings.get('strategy'),
              style: Theme.of(context).textTheme.bodySmall),
          DropdownButtonFormField<String>(
            initialValue: _strategy,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.insights_outlined)),
            items: const [
              DropdownMenuItem(value: 'Balanced', child: Text('Balanced')),
              DropdownMenuItem(value: 'Momentum', child: Text('Momentum')),
              DropdownMenuItem(value: 'Grid', child: Text('Grid')),
            ],
            onChanged: (value) =>
                setState(() => _strategy = value ?? _strategy),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_strings.get('risk_per_trade'),
                style: Theme.of(context).textTheme.bodySmall),
            Text('${_riskLevel.round()}%',
                style: const TextStyle(
                    color: TradeColors.accentLime,
                    fontWeight: FontWeight.w700)),
          ]),
          Slider(
            value: _riskLevel,
            min: 5,
            max: 100,
            divisions: 19,
            onChanged: (value) => setState(() => _riskLevel = value),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
            label: Text(_strings.get('advanced')),
          ),
        ]),
      );

  Future<void> _showExchangeDialog() async {
    final exchangeController = TextEditingController(text: 'Binance');
    final keyController = TextEditingController();
    final secretController = TextEditingController();
    var testnet = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_strings.get('exchange_api_dialog')),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: exchangeController,
                  decoration: InputDecoration(
                      labelText: _strings.get('exchange'),
                      prefixIcon: const Icon(Icons.currency_exchange_rounded))),
              TextField(
                  controller: keyController,
                  decoration: InputDecoration(
                      labelText: _strings.get('api_key'),
                      prefixIcon: const Icon(Icons.key_rounded))),
              TextField(
                  controller: secretController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: _strings.get('api_secret'),
                      prefixIcon: const Icon(Icons.lock_outline_rounded))),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_strings.get('testnet')),
                value: testnet,
                onChanged: (value) => setDialogState(() => testnet = value),
              ),
              Text(
                  _strings.get('secret_key_notice'),
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(_strings.get('cancel'))),
            FilledButton(
              onPressed: keyController.text.trim().isEmpty ||
                      secretController.text.trim().isEmpty
                  ? null
                  : () {
                      setState(() => _connectedExchanges
                          .add(exchangeController.text.trim()));
                      Navigator.pop(dialogContext);
                    },
              child: Text(_strings.get('save')),
            ),
          ],
        ),
      ),
    );
    exchangeController.dispose();
    keyController.dispose();
    secretController.dispose();
  }

  Future<void> _showTwoFactorDialog() async {
    if (_twoFactorEnabled) {
      // Already enabled — offer to disable
      final disable = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(_strings.get('disable_2fa')),
          content: Text(_strings.get('two_fa_hint')),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(_strings.get('cancel'))),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(_strings.get('disable_2fa'))),
          ],
        ),
      );
      if (disable == true) {
        setState(() => _twoFactorEnabled = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_strings.get('two_fa_disabled'))));
      }
      return;
    }

    // Enable flow — Google Authenticator setup
    const demoSecret = 'JBSWY3DPEHPK3PXP';
    final codeController = TextEditingController();
    String? codeError;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_strings.get('setup_2fa')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step 1
                Text(_strings.get('step_install_app'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(_strings.get('google_authenticator'),
                    style: const TextStyle(color: TradeColors.secondaryText)),
                const SizedBox(height: 16),

                // Step 2 — QR placeholder
                Text(_strings.get('step_scan_qr'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TradeColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2_rounded,
                            size: 100, color: Colors.grey.shade800),
                        const SizedBox(height: 6),
                        Text('NEXORA',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_strings.get('scan_qr_hint'),
                    style: const TextStyle(
                        color: TradeColors.secondaryText, fontSize: 12)),
                const SizedBox(height: 8),

                // Secret key row
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: TradeColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TradeColors.border),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_strings.get('secret_key'),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: TradeColors.secondaryText)),
                          const SizedBox(height: 2),
                          const SelectableText(demoSecret,
                              style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      tooltip: _strings.get('copy'),
                      onPressed: () {
                        Clipboard.setData(
                            const ClipboardData(text: demoSecret));
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(
                                content: Text(_strings.get('copied')),
                                duration: const Duration(seconds: 1)));
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Step 3 — verification code
                Text(_strings.get('step_enter_code'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: _strings.get('verification_code'),
                    errorText: codeError,
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) =>
                      setDialogState(() => codeError = null),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(_strings.get('cancel'))),
            FilledButton(
              onPressed: () {
                final code = codeController.text.trim();
                if (code.length == 6) {
                  Navigator.pop(dialogContext, true);
                } else {
                  setDialogState(
                      () => codeError = _strings.get('code_invalid'));
                }
              },
              child: Text(_strings.get('confirm')),
            ),
          ],
        ),
      ),
    );
    codeController.dispose();

    if (confirmed == true) {
      setState(() => _twoFactorEnabled = true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_strings.get('code_verified'))));
    }
  }

  Future<void> _showLanguageDialog() async {
    final language = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(_strings.get('language_dialog')),
        children: [
          for (final option in ['Русский', 'English', 'Українська'])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, option),
              child: Row(children: [
                Icon(_languageName == option ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: _languageName == option ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color, size: 20),
                const SizedBox(width: 12),
                Text(option),
              ]),
            ),
        ],
      ),
    );
    if (language != null) {
      final locale = switch (language) {
        'English' => const Locale('en'),
        'Українська' => const Locale('uk'),
        _ => const Locale('ru'),
      };
      widget.onLocaleChanged(locale);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_strings.get('language_changed')}: $language')));
    }
  }

  Widget _appearancePanel(BuildContext context, AppStrings strings) {
    final tp = context.watch<ThemeProvider>();
    final lang = widget.locale.languageCode;
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // — header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Row(children: [
            Icon(Icons.palette_outlined, color: tp.accent.color),
            const SizedBox(width: 10),
            Expanded(child: Text(strings.get('ready_themes'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14))),
            IconButton(
              tooltip: tp.isDark ? strings.get('switch_to_light') : strings.get('switch_to_dark'),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (ch, a) => RotationTransition(
                  turns: Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: a, curve: Curves.easeOutBack)),
                  child: FadeTransition(opacity: a, child: ScaleTransition(scale: a, child: ch)),
                ),
                child: Icon(tp.isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded, key: ValueKey(tp.isDark), color: tp.accent.color),
              ),
              onPressed: () => tp.toggleDarkLight(),
            ),
          ]),
        ),
        // — preset cards (horizontal scroll)
        SizedBox(
          height: 82,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: AppPreset.presets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final pr = AppPreset.presets[i];
              final selected = tp.preset.id == pr.id;
              return GestureDetector(
                onTap: () => tp.setPreset(pr),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  width: 92,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: pr.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? pr.accent.color : Colors.transparent, width: 2.5),
                    boxShadow: selected ? [BoxShadow(color: pr.accent.color.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))] : [],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    AnimatedScale(scale: selected ? 1.15 : 1.0, duration: const Duration(milliseconds: 250), child: CircleAvatar(radius: 14, backgroundColor: pr.accent.color, child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null)),
                    const SizedBox(height: 6),
                    Text(pr.label(lang), style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: pr.gradient[0].computeLuminance() > 0.4 ? const Color(0xFF1A1E2E) : Colors.white)),
                  ]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // — accent dots
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Text(strings.get('accent_color'), style: Theme.of(context).textTheme.bodySmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Wrap(spacing: 10, runSpacing: 10, children: [
            for (final a in AppAccent.values)
              GestureDetector(
                onTap: () => tp.setAccent(a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: a.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: tp.accent == a ? Theme.of(context).textTheme.titleLarge!.color! : Colors.transparent, width: 2.5),
                    boxShadow: tp.accent == a ? [BoxShadow(color: a.color.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: 1)] : [],
                  ),
                  child: AnimatedScale(scale: tp.accent == a ? 1.0 : 0.0, duration: const Duration(milliseconds: 200), child: const Icon(Icons.check, color: Colors.white, size: 16)),
                ),
              ),
          ]),
        ),
        Divider(height: 1, indent: 16, endIndent: 16, color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
        // — animations toggle
        SwitchListTile(
          title: Text(strings.get('animations')),
          subtitle: Text(strings.get('animations_desc')),
          secondary: AnimatedRotation(turns: tp.animationsEnabled ? 0.0 : -0.1, duration: const Duration(milliseconds: 300), child: Icon(Icons.animation_rounded, color: tp.accent.color)),
          value: tp.animationsEnabled,
          onChanged: (v) => tp.setAnimations(v),
        ),
        // — dark/light toggle
        SwitchListTile(
          title: Text(strings.get('dark_mode')),
          subtitle: Text(tp.isDark ? strings.get('dark_mode_on') : strings.get('light_mode_on')),
          secondary: Icon(tp.isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded, color: tp.accent.color),
          value: tp.isDark,
          onChanged: (_) => tp.toggleDarkLight(),
        ),
        const SizedBox(height: 6),
      ]),
    );
  }

  Future<void> _sendTestPush() async {
    final ok = await NotificationService.instance.showTest();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? _strings.get('test_push_sent') : _strings.get('test_push_fail')),
      backgroundColor: ok ? null : Theme.of(context).colorScheme.error,
    ));
  }
}
