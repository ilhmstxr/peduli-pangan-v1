import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

/// Halaman Akun/Profil (quickstart-style) menggunakan tabel 'profiles' (id=auth.user.id).
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _sb = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSub;

  bool _loading = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _authSub = _sb.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      }
    });
    _loadProfile();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final data =
          await _sb.from('profiles').select().eq('id', user.id).maybeSingle();

      final username = (data?['username'] ?? '') as String;
      final website = (data?['website'] ?? '') as String;
      final avatar = (data?['avatar_url'] ?? '') as String;

      _usernameController.text = username;
      _websiteController.text = website;
      _avatarUrl = avatar.isEmpty ? null : avatar;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = _sb.auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      await _sb.from('profiles').upsert({
        'id': user.id,
        'username': _usernameController.text.trim(),
        'website': _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        'avatar_url': _avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil disimpan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    await _sb.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = _sb.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: _avatarUrl != null
                                  ? NetworkImage(_avatarUrl!)
                                  : null,
                              child: _avatarUrl == null
                                  ? const Icon(Icons.person, size: 32)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user?.email ?? '-',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text('User ID: ${user?.id ?? '-'}',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama tampilan',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _websiteController,
                                decoration: const InputDecoration(
                                  labelText: 'Website (opsional)',
                                  prefixIcon: Icon(Icons.link),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: _saveProfile,
                                icon: const Icon(Icons.save),
                                label: const Text('Simpan'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text('Keamanan',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.lock_reset),
                          title: const Text('Reset Password'),
                          subtitle: const Text('Kirim email reset password'),
                          onTap: () async {
                            if (user?.email == null) return;
                            try {
                              await _sb.auth.resetPasswordForEmail(
                                user!.email!,
                                redirectTo:
                                    'io.pedulipangan.app://reset-callback/',
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Email reset password dikirim')),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Gagal mengirim email: $e')),
                                );
                              }
                            }
                          },
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
