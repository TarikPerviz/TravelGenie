import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tamne ikone na bijelom status baru (iOS look)
    final overlay =
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white);

    // MOCK vrijednosti – u MVP-ju dolaze iz storage/backenda
    const firstName = 'Tarik';
    const lastName = 'Perviz';
    const location = 'Sarajevo, Bosnia and Herzegovina';
    const dialCode = '+387';
    const phone = '061-111-222';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: Colors.white, // ⬅️ bijela pozadina kao u Figmi
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),
              _TopBar(
                onBack: () => Navigator.of(context).maybePop(),
                onDone: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ➜ AVATAR SEKCIJA BEZ HORIZONTALNOG PADDINGA, CENTRIRANA
                      const _AvatarBlock(name: 'Tarik'),
                      const SizedBox(height: 22),

                      // ➜ OSTATAK FORME SA LIJEVIM PORAVNANJEM I PADDINGOM
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _FieldLabel('First Name'),
                            _FilledField(value: 'Tarik'),
                            SizedBox(height: 14),

                            _FieldLabel('Last Name'),
                            _FilledField(value: 'Perviz'),
                            SizedBox(height: 14),

                            _FieldLabel('Location'),
                            _FilledField(value: 'Sarajevo, Bosnia and Herzegovina'),
                            SizedBox(height: 14),

                            _FieldLabel('Mobile Number'),
                            _PhoneField(dialCode: '+387', number: '061-111-222'),
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

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onDone;
  const _TopBar({required this.onBack, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const Spacer(),
          const Text('Edit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          GestureDetector(
            onTap: onDone,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFF1061FF),
                  fontWeight: FontWeight.w700,
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
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F5F8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  final String name;
  const _AvatarBlock({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,                // ⬅️ zauzmi punu širinu
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // ⬅️ centriraj unutra
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFFFE3EC),
            child: Icon(Icons.person, size: 52, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Text(name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text(
            'Change Profile Picture',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF1061FF), fontWeight: FontWeight.w700),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}

/// Read-only kapsula: svijetlosiva (#F1F3F6), zaobljena 14, bez checkmarka.
class _FilledField extends StatelessWidget {
  final String value;
  const _FilledField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ⬅️ cijela širina
      height: 52,             // ⬅️ visina konzistentna
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // svijetlosiva iz Figme
        borderRadius: BorderRadius.circular(12), // blaži radius
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
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
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            dialCode,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.expand_more, size: 18, color: Colors.black45),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

