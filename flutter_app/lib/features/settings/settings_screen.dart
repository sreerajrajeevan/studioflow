import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/state.dart';
import '../../branding/brand_logo.dart';
import '../../branding/studio_branding.dart';

/// Local studio configuration with explicit persistence on Apply.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _tagline;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _gstin;
  late final TextEditingController _upiId;
  late final TextEditingController _upiPayee;
  late final TextEditingController _prefix;
  late final TextEditingController _footer;

  @override
  void initState() {
    super.initState();
    final b = ref.read(brandingProvider);
    _name = TextEditingController(text: b.businessName);
    _tagline = TextEditingController(text: b.tagline ?? '');
    _address = TextEditingController(text: b.address);
    _phone = TextEditingController(text: b.phone);
    _gstin = TextEditingController(text: b.gstin ?? '');
    _upiId = TextEditingController(text: b.upiId ?? '');
    _upiPayee = TextEditingController(text: b.upiPayeeName ?? '');
    _prefix = TextEditingController(text: b.invoicePrefix);
    _footer = TextEditingController(text: b.invoiceFooter ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _name, _tagline, _address, _phone, _gstin,
      _upiId, _upiPayee, _prefix, _footer,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _saving = false;
  String? _pendingLogo;
  bool _logoChanged = false;

  Future<void> _pickLogo() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 768,
        maxHeight: 768,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      if (await picked.length() > 512 * 1024) {
        throw const FormatException('Choose an image smaller than 512 KB.');
      }
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pendingLogo = 'custom:${base64Encode(bytes)}';
        _logoChanged = true;
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to load logo. Choose a smaller image.')),
        );
      }
    }
  }

  Future<void> _apply() async {
    if (_saving) return;
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a studio name.')),
      );
      return;
    }
    setState(() => _saving = true);
    final current = ref.read(brandingProvider);
    final updated = StudioBranding(
      primaryColor: current.primaryColor,
      secondaryColor: current.secondaryColor,
      dark: current.dark,
      email: current.email,
      currencyCode: current.currencyCode,
      logoAssetPath: _logoChanged ? _pendingLogo :
          (current.logoAssetPath == poiseLogoAssetKey &&
              _name.text.trim() != 'D POISE' ? null : current.logoAssetPath),
      businessName: _name.text.trim().isEmpty
          ? current.businessName
          : _name.text.trim(),
      tagline: _tagline.text.trim().isEmpty ? null : _tagline.text.trim(),
      address: _address.text.trim(),
      phone: _phone.text.trim(),
      gstin: _gstin.text.trim().isEmpty ? null : _gstin.text.trim(),
      upiId: _upiId.text.trim().isEmpty ? null : _upiId.text.trim(),
      upiPayeeName:
          _upiPayee.text.trim().isEmpty ? null : _upiPayee.text.trim(),
      invoicePrefix:
          _prefix.text.trim().isEmpty ? 'INV' : _prefix.text.trim(),
      invoiceFooter:
          _footer.text.trim().isEmpty ? null : _footer.text.trim(),
    );
    try {
      await ref.read(studioConfigRepositoryProvider).save(updated);
      if (!mounted) return;
      ref.read(brandingProvider.notifier).state = updated;
      setState(() { _logoChanged = false; _pendingLogo = null; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved on this device.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save settings. Please retry.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _applyPreset(BrandingPreset preset) {
    final current = ref.read(brandingProvider);
    var next = current.copyWith(
      primaryColor: preset.primary,
      secondaryColor: preset.secondary,
      // Only the demo preset may set the business name; colour presets
      // never rename a studio (rule carried over from Task 1.5).
      businessName: preset.isDemo ? preset.businessName : null,
      tagline: preset.isDemo ? preset.tagline : null,
      dark: preset.dark,
      logoAssetPath: preset.logoAssetPath,
    );
    // Switching AWAY from the D POISE demo must drop the embedded D
    // POISE logo — it belongs to that brand only (copyWith cannot null
    // a field, so rebuild in that one case).
    if (!preset.isDemo && next.logoAssetPath == poiseLogoAssetKey) {
      next = StudioBranding(
        businessName: next.businessName,
        tagline: next.tagline,
        primaryColor: next.primaryColor,
        secondaryColor: next.secondaryColor,
        address: next.address,
        phone: next.phone,
        email: next.email,
        gstin: next.gstin,
        upiId: next.upiId,
        upiPayeeName: next.upiPayeeName,
        currencyCode: next.currencyCode,
        invoicePrefix: next.invoicePrefix,
        invoiceFooter: next.invoiceFooter,
        dark: next.dark,
      );
    }
    ref.read(brandingProvider.notifier).state = next;
    if (preset.isDemo) {
      _name.text = preset.businessName ?? _name.text;
      _tagline.text = preset.tagline ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = ref.watch(brandingProvider);
    final role = ref.watch(roleProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Text('Settings', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          'Studio profile, branding and configuration. Save your studio profile on this device.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 18),
        _Section(
          title: 'Studio profile',
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandLogo(
                    branding: _logoChanged
                        ? StudioBranding(
                            businessName: branding.businessName,
                            primaryColor: branding.primaryColor,
                            secondaryColor: branding.secondaryColor,
                            logoAssetPath: _pendingLogo,
                          )
                        : branding,
                    size: 54,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Studio name',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _tagline,
                          decoration: const InputDecoration(
                            labelText: 'Tagline (optional)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: _saving ? null : _pickLogo,
                    child: const Text('Upload logo'),
                  ),
                  TextButton(
                    onPressed: _saving ? null : () => setState(() {
                      _pendingLogo = null;
                      _logoChanged = true;
                    }),
                    child: const Text('Remove logo'),
                  ),
                ],
              ),
              TextField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phone,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _gstin,
                      decoration: const InputDecoration(
                        labelText: 'GSTIN (optional)',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _Section(
          title: 'Branding',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Presets re-theme the whole app instantly.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final preset in brandingPresets)
                    _PresetSwatch(
                      preset: preset,
                      selected: branding.primaryColor == preset.primary,
                      onTap: () => _applyPreset(preset),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: branding.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Preview — ${branding.businessName}',
                        style: TextStyle(
                          color: _onColor(branding.primaryColor),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: branding.secondaryColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Accent',
                        style: TextStyle(
                          color: _onColor(branding.secondaryColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _Section(
          title: 'Services',
          child: Text(
            'Manage categories, services and prices from the Services screen.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        _Section(
          title: 'Payment configuration',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _upiId,
                      decoration: const InputDecoration(
                        labelText: 'Studio UPI ID',
                        hintText: 'yourstudio@okbank',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _upiPayee,
                      decoration: const InputDecoration(
                        labelText: 'UPI payee name',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Payments always go to the studio\'s own merchant account. '
                'The QR stays a demo placeholder until the studio\'s '
                'soundbox/UPI provider is verified — never guess a merchant setup.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _Section(
          title: 'Invoice configuration',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: TextField(
                      controller: _prefix,
                      decoration: const InputDecoration(
                        labelText: 'Invoice prefix',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _footer,
                      decoration: const InputDecoration(
                        labelText: 'Invoice footer message',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Official invoice numbers are assigned by the backend, never '
                'generated on this device. Issued invoices keep a frozen '
                'snapshot of studio details.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _Section(
          title: 'Role preview',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preview what staff see. UI preview only — not authentication; '
                'the backend enforces real authorization later.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              SegmentedButton<AppRole>(
                segments: const [
                  ButtonSegment(value: AppRole.owner, label: Text('Owner')),
                  ButtonSegment(value: AppRole.staff, label: Text('Staff')),
                ],
                selected: {role},
                onSelectionChanged: (s) {
                  ref.read(roleProvider.notifier).state = s.first;
                  if (s.first == AppRole.staff) {
                    // Settings itself is hidden for staff — leave the screen.
                    context.go('/billing');
                  }
                },
              ),
            ],
          ),
        ),
        _Section(
          title: 'Data management',
          child: Text(
            'Backup, restore and multi-device sync arrive with the backend '
            'task. Business records are stored locally on this device.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 6),
        FilledButton(
          key: const ValueKey('apply_settings_button'),
          onPressed: _saving ? null : _apply,
          child: const Text('Apply changes'),
        ),
      ],
    );
  }

  Color _onColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.42 ? const Color(0xFF1C1C1C) : const Color(0xFFFBF9F4);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _PresetSwatch extends StatelessWidget {
  const _PresetSwatch({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final BrandingPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: preset.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outline,
                width: selected ? 3 : 1,
              ),
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: preset.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 84,
            child: Text(
              preset.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
