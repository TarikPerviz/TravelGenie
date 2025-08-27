import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
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
              // Logo / wordmark
              Text('TravelGenie',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.w600, color: TGColors.primary
                  )),
              const SizedBox(height: 24),

              Text('Sign in now',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Please sign in to continue',
                  textAlign: TextAlign.center, style: TextStyle(color: TGColors.subtext)),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(children: [
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
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v != null && v.length >= 8)
                        ? null
                        : 'Password must be at least 8 characters',
                  ),
                ]),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Forgot Password (coming soon)')),
                  ),
                  child: const Text('Forgot Password?'),
                ),
              ),

              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    GoRouter.of(context).go('/home');
                  }
                },
                child: const Text('Sign In'),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: const Text('Sign up',
                        style: TextStyle(
                          color: TGColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),

              SignInButton(
                Buttons.Google,
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),
    );
  }
}
