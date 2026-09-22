import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/app_strings.dart';
import '../theme/trade_theme.dart';

enum AccountSection { exchanges, subscription, settings, help }

class AccountSectionScreen extends StatelessWidget {
  const AccountSectionScreen(
      {super.key, required this.section, this.onOpenSettings, this.locale});

  final AccountSection section;
  final VoidCallback? onOpenSettings;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(locale ?? const Locale('ru'));
    final content = switch (section) {
      AccountSection.exchanges => _exchanges(context, strings),
      AccountSection.subscription => _subscription(context, strings),
      AccountSection.settings => null,
      AccountSection.help => _help(context, strings),
    };

    if (section == AccountSection.settings) {
      return const _SettingsRedirectPlaceholder();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: content)),
    );
  }

  Widget _exchanges(BuildContext context, AppStrings strings) => _page(
          context,
          Icons.account_balance_outlined,
          strings.get('exchanges'),
          strings.get('exchange_subtitle'), [
        _emptyPanel(strings.get('exchanges_empty'),
            strings.get('exchanges_empty_text')),
        const SizedBox(height: 14),
        FilledButton.icon(
            onPressed: onOpenSettings,
            icon: const Icon(Icons.add),
            label: Text(strings.get('configure_exchange'))),
      ]);

  Widget _subscription(BuildContext context, AppStrings strings) => _page(
          context,
          Icons.credit_card_outlined,
          strings.get('subscription'),
          strings.get('subscription_subtitle'), [
        _statusPanel(context, strings.get('subscription_inactive'),
            strings.get('subscription_empty_text')),
        const SizedBox(height: 14),
        FilledButton.icon(
            onPressed: () => _openTelegram(context),
            icon: const Icon(Icons.bolt_outlined),
            label: Text(strings.get('choose_subscription'))),
      ]);

  Future<void> _openTelegram(BuildContext context) async {
    final uri = Uri.parse('https://t.me/officialnexora_bot');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings(locale ?? const Locale('ru')).get('open_telegram_failed'))));
    }
  }

  Widget _help(BuildContext context, AppStrings strings) => _page(
          context,
          Icons.help_outline_rounded,
          strings.get('help'),
          strings.get('support_subtitle'), [
        _panel(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(strings.get('support_service'),
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(strings.get('support_text'),
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 14),
                      _contactButton(
                          context,
                          Icons.support_agent_outlined,
                          strings.get('support_chat'),
                          strings.get('support_handle'),
                          'https://t.me/nexorasupportq'),
                      const SizedBox(height: 10),
                      _contactButton(
                          context,
                          Icons.person_outline,
                          strings.get('founder'),
                          strings.get('founder_handle'),
                          'https://t.me/aid66633'),
                      const SizedBox(height: 10),
                      _contactButton(
                          context,
                          Icons.mail_outline,
                          strings.get('official_email'),
                          strings.get('email_address'),
                          'mailto:support@nexora.date'),
                    ]))),
        const SizedBox(height: 16),
        _legalPanel(context, strings.get('user_agreement'),
            strings.get('legal_text'), strings.get('open_full_text')),
        const SizedBox(height: 16),
        _legalPanel(context, strings.get('privacy'),
            strings.get('privacy_text'), strings.get('open_full_text')),
        const SizedBox(height: 14),
        OutlinedButton.icon(
            onPressed: () => _openUri(context, 'mailto:support@nexora.date'),
            icon: const Icon(Icons.mail_outline),
            label: Text(strings.get('create_ticket'))),
      ]);

  Widget _contactButton(BuildContext context, IconData icon, String title,
          String value, String url) =>
      InkWell(
        onTap: () => _openUri(context, url),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: TradeColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: TradeColors.border)),
          child: Row(children: [
            Icon(icon, color: TradeColors.primaryPurple),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(color: TradeColors.primaryPurple)),
                ])),
            const Icon(Icons.open_in_new, size: 18),
          ]),
        ),
      );

  Widget _legalPanel(
          BuildContext context, String title, String text, String action) =>
      _panel(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(text, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            FilledButton(onPressed: () {}, child: Text(action)),
          ]),
        ),
      );

  Future<void> _openUri(BuildContext context, String value) async {
    final opened =
        await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings(locale ?? const Locale('ru')).get('open_link_failed'))));
    }
  }

  Widget _page(BuildContext context, IconData icon, String title,
          String subtitle, List<Widget> children) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: TradeColors.primaryPurple),
          const SizedBox(width: 10),
          Text(title, style: Theme.of(context).textTheme.headlineMedium)
        ]),
        const SizedBox(height: 7),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 22),
        ...children,
      ]);

  Widget _emptyPanel(String title, String subtitle) => _panel(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 7),
            Text(subtitle,
                style: const TextStyle(color: TradeColors.secondaryText))
          ])));

  Widget _statusPanel(BuildContext context, String title, String subtitle) =>
      _panel(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                        color: TradeColors.tertiaryText,
                        shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 7),
                      Text(subtitle,
                          style: Theme.of(context).textTheme.bodySmall)
                    ]))
              ])));

  Widget _panel({required Widget child}) => Container(
      decoration: BoxDecoration(
          color: TradeColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: TradeColors.border)),
      child: child);
}

class _SettingsRedirectPlaceholder extends StatelessWidget {
  const _SettingsRedirectPlaceholder();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
