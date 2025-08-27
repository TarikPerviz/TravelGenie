import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text('TravelGenie',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, color: TGColors.primary)),
              const SizedBox(height: 24),

              Text('Sign up now',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Please fill the details and create an account',
                  textAlign: TextAlign.center, style: TextStyle(color: TGColors.subtext)),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(hintText: 'Tarik Perviz'),
                    validator: (v) => (v != null && v.trim().isNotEmpty)
                        ? null : 'Enter your name',
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'tarik@gmail.com'),
                    validator: (v) =>
                        (v != null && v.contains('@')) ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: '**********',
                      helperText: 'Password must be 8 characters',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v != null && v.length >= 8)
                        ? null : 'Password must be at least 8 characters',
                  ),
                ]),
              ),
              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) context.go('/home');
                },
                child: const Text('Sign Up'),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account '),
                  GestureDetector(
                    onTap: () => context.go('/signin'),
                    child: const Text('Sign in',
                        style: TextStyle(
                            color: TGColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Google Sign-In (prototype)')),
                ),
                icon: const Icon(Icons.g_translate),
                label: const Text('Continue with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

