
// lib/features/users/presentation/user_profile_screen.dart
//
// My Profile screen similar to the provided reference.
// Uses Supabase 'profiles' table keyed by auth.user.id (UUID).

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_avatar.dart';
import 'user_form_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _sb = Supabase.instance.client;
  bool _loading = true;

  String? _username;
  String? _email;
  String? _avatarUrl;

  Future<void> _load() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final profile = await _sb.from('profiles').select().eq('id', user.id).maybeSingle();
      setState(() {
        _email = user.email;
        _username = (profile?['username'] ?? '') as String?;
        _avatarUrl = (profile?['avatar_url'] ?? '') as String?;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _logout() async {
    await _sb.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
    );
  }

  Widget _menuTile({required IconData leading, required String title, VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(leading, color: const Color(0xFF388E3C)),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            UserAvatar(size: 48, imageUrl: _avatarUrl),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _username?.isNotEmpty == true ? _username! : '-',
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserFormScreen()));
                                          if (mounted) _load();
                                        },
                                        icon: const Icon(Icons.edit, size: 18),
                                        tooltip: 'Edit',
                                      ),
                                    ],
                                  ),
                                  Text(_email ?? '-', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _sectionHeader('Accessibility'),
                    _menuTile(leading: Icons.receipt_long, title: 'History', onTap: () {}),
                    _menuTile(leading: Icons.location_on, title: 'Location', onTap: () {}),
                    _menuTile(leading: Icons.language, title: 'Language', onTap: () {}),

                    _sectionHeader('Other'),
                    _menuTile(leading: Icons.privacy_tip, title: 'Privacy Policy', onTap: () {}),
                    _menuTile(leading: Icons.article, title: 'Terms Of Service', onTap: () {}),
                    _menuTile(leading: Icons.help_outline, title: 'Help Center', onTap: () {}),

                    const SizedBox(height: 12),
                    Center(
                      child: TextButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
