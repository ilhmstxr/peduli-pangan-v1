
// lib/features/users/presentation/user_form_screen.dart
//
// Edit Profile form similar to the provided reference.
// Fields: Name, Email, Username, Password (+ big editable avatar).
// Name will be stored into 'username' by default for compatibility; adjust if you have 'full_name' column.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_avatar.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final _sb = Supabase.instance.client;

  bool _loading = true;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final profile = await _sb.from('profiles').select().eq('id', user.id).maybeSingle();
      _emailCtrl.text = user.email ?? '';
      _usernameCtrl.text = (profile?['username'] ?? '') as String;
      // We map Name to username as a default. Change to 'full_name' if your schema has it.
      _nameCtrl.text = _usernameCtrl.text;
      _avatarUrl = (profile?['avatar_url'] ?? '') as String?;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat: $e')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = _sb.auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      // Update email if changed
      if ((_emailCtrl.text.trim()).isNotEmpty && _emailCtrl.text.trim() != (user.email ?? '')) {
        await _sb.auth.updateUser(UserAttributes(email: _emailCtrl.text.trim()));
      }
      // Update password if provided
      if (_passwordCtrl.text.trim().isNotEmpty) {
        await _sb.auth.updateUser(UserAttributes(password: _passwordCtrl.text.trim()));
      }
      // Update profile
      await _sb.from('profiles').upsert({
        'id': user.id,
        'username': _usernameCtrl.text.trim().isEmpty ? _nameCtrl.text.trim() : _usernameCtrl.text.trim(),
        'avatar_url': _avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil disimpan')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        UserAvatar(
                          size: 100,
                          imageUrl: _avatarUrl,
                          isEditable: true,
                          onChanged: (url) => _avatarUrl = url,
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(labelText: 'Name'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _emailCtrl,
                                decoration: const InputDecoration(labelText: 'E mail address'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                                  if (!v.contains('@')) return 'Email tidak valid';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _usernameCtrl,
                                decoration: const InputDecoration(labelText: 'Username'),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordCtrl,
                                decoration: const InputDecoration(labelText: 'Password'),
                                obscureText: true,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: _save,
                                  child: const Text('Save'),
                                ),
                              ),
                            ],
                          ),
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
