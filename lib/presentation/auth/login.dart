import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'register.dart';
import 'account.dart';

/// Login screen using Supabase Auth UI (email/password + optional socials).
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Email & Password (built-in toggle for forgot password)
                  SupaEmailAuth(
                    // TODO: ganti dengan scheme deep link milikmu jika perlu verifikasi/magic link.
                    redirectTo: kIsWeb ? null : 'io.pedulipangan.app://auth-callback',
                    onSignInComplete: (response) async {
                      if (response.session != null) {
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AccountPage()),
                            (route) => false,
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login gagal. Coba lagi.')),
                        );
                      }
                    },
                    onSignUpComplete: (response) async {
                      // Jika user menekan "Daftar" dari widget ini.
                      if (response.session == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pendaftaran berhasil. Periksa email untuk verifikasi.'),
                          ),
                        );
                      } else {
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AccountPage()),
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // (Opsional) login via Google/Apple
                  SupaSocialsAuth(
                    socialProviders: const [
                      OAuthProvider.google,
                      // OAuthProvider.apple,
                    ],
                    redirectUrl: kIsWeb ? null : 'io.pedulipangan.app://auth-callback',
                    onSuccess: (Session response) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const AccountPage()),
                        (route) => false,
                      );
                    },
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Social login error: $error')),
                      );
                    },
                    colored: true,
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                        },
                        child: const Text('Daftar'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
