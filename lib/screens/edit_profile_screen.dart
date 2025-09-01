import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.scaffoldBackgroundColor;

    // Status bar kontrast prema temi
    final overlay = theme.brightness == Brightness.dark
        ? SystemUiOverlayStyle.light.copyWith(statusBarColor: bg)
        : SystemUiOverlayStyle.dark.copyWith(statusBarColor: bg);

    // MOCK vrijednosti – u MVP-ju dolaze iz storage/backenda
    const firstName = 'Tarik';
    const lastName = 'Perviz';
    const location = 'Sarajevo, Bosnia and Herzegovina';
    const dialCode = '+387';
    const phone = '061-111-222';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),
              const _TopBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Avatar sekcija – centrirana kao na profilu
                      const _AvatarSection(name: 'Tarik'),
                      const SizedBox(height: 22),

                      // Forma – lijevo poravnanje
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _FieldLabel('First Name'),
                            _FilledField(value: firstName),
                            SizedBox(height: 14),

                            _FieldLabel('Last Name'),
                            _FilledField(value: lastName),
                            SizedBox(height: 14),

                            _FieldLabel('Location'),
                            _FilledField(value: location),
                            SizedBox(height: 14),

                            _FieldLabel('Mobile Number'),
                            _PhoneField(dialCode: dialCode, number: phone),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Top bar kao na Profile ekranu: back — centriran naslov — (balans desno)
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          Text(
            'Edit Profile',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // “Done” poravnat kao ikonica (36px širine) da naslov ostane točno u sredini
          SizedBox(
            width: 36,
            height: 36,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.of(context).maybePop(),
              child: Center(
                child: Text(
                  'Done',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip =
        theme.brightness == Brightness.dark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: chip,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String name;
  const _AvatarSection({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFFFE3EC),
            child: Icon(Icons.person, size: 52, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Change Profile Picture',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// Read-only kapsula: svijetla u light, tamna u dark.
class _FilledField extends StatelessWidget {
  final String value;
  const _FilledField({required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pillColor =
        theme.brightness == Brightness.dark ? const Color(0xFF1B1F27) : const Color(0xFFF5F7FA);

    return Container(
      width: double.infinity,
      height: 52,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final String dialCode;
  final String number;
  const _PhoneField({required this.dialCode, required this.number});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pillColor =
        theme.brightness == Brightness.dark ? const Color(0xFF1B1F27) : const Color(0xFFF5F7FA);

    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            dialCode,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.expand_more, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: .6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              number,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
