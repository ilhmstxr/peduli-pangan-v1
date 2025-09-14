import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'account.dart';
import 'login.dart';

/// Register screen using Supabase Auth UI.
/// Catatan: `SupaEmailAuth` menampilkan form Sign In/Sign Up dalam widget yang sama.
/// Halaman ini difokuskan untuk pendaftaran, dengan field metadata tambahan.
class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
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
                  SupaEmailAuth(
                    redirectTo: kIsWeb ? null : 'io.pedulipangan.app://auth-callback',
                    // Tambahkan metadata untuk dibuatkan profil nanti / tersimpan di user metadata
                    metadataFields: [
                      MetaDataField(
                        prefixIcon: const Icon(Icons.person),
                        label: 'Nama tampilan',
                        key: 'display_name',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Wajib diisi';
                          }
                          return null;
                        },
                      ),
                      MetaDataField(
                        prefixIcon: const Icon(Icons.link),
                        label: 'Website (opsional)',
                        key: 'website',
                      ),
                    ],
                    onSignUpComplete: (response) async {
                      final sb = Supabase.instance.client;
                      final user = response.user ?? sb.auth.currentUser;
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pendaftaran berhasil. Periksa email verifikasi.'),
                          ),
                        );
                        return;
                      }
                      // Upsert profil minimal ke tabel 'profiles' (quickstart pattern).
                      final metadata = response.user?.userMetadata ?? {};
                      final displayName = (metadata['display_name'] ?? '') as String;
                      final website = (metadata['website'] ?? '') as String?;

                      try {
                        await sb.from('profiles').upsert({
                          'id': user.id,
                          'username': displayName.isEmpty ? user.email?.split('@').first : displayName,
                          'website': website,
                          'updated_at': DateTime.now().toIso8601String(),
                        });
                      } catch (_) {
                        // tidak fatal; bisa diperbaiki dari AccountPage.
                      }

                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AccountPage()),
                          (route) => false,
                        );
                      }
                    },
                    onSignInComplete: (response) async {
                      // Jika user menekan toggle "Masuk" dari halaman ini.
                      if (response.session != null) {
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AccountPage()),
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: const Text('Masuk'),
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
