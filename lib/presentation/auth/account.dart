import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Controllers untuk form edit
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();

  // Data profil
  String? _avatarUrl;
  String _displayName = 'User';

  bool _loading = true;
  int _selectedIndex = 3; // bottom nav: Me

  SupabaseClient get _sb => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  Future<void> _getProfile() async {
    setState(() => _loading = true);
    try {
      final user = _sb.auth.currentUser;
      if (user == null) {
        if (!mounted) return;
        // Tidak ada sesi — kembali ke login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }

      // Ambil profil
      final data =
          await _sb.from('profiles').select().eq('id', user.id).maybeSingle();

      final username = (data?['username'] ?? '') as String;
      final website = (data?['website'] ?? '') as String;
      final avatar = (data?['avatar_url'] ?? '') as String;

      _usernameController.text = username;
      _websiteController.text = website;
      _avatarUrl = avatar.isEmpty ? null : avatar;

      // Nama yang ditampilkan
      _displayName = username.isNotEmpty ? username : (user.email ?? 'User');
    } on PostgrestException catch (e) {
      if (mounted) _showSnackBar(e.message, isError: true);
    } catch (_) {
      if (mounted) _showSnackBar('Unexpected error occurred', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _loading = true);
    try {
      final user = _sb.auth.currentUser;
      if (user == null) {
        if (mounted) _showSnackBar('Not authenticated', isError: true);
        return;
      }

      final updates = {
        'id': user.id,
        'username': _usernameController.text.trim(),
        'website': _websiteController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _sb.from('profiles').upsert(updates);
      if (mounted) {
        _showSnackBar('Successfully updated profile!');
        // refresh tampilan nama
        _displayName = _usernameController.text.trim().isNotEmpty
            ? _usernameController.text.trim()
            : (user.email ?? 'User');
        setState(() {});
      }
    } on PostgrestException catch (e) {
      if (mounted) _showSnackBar(e.message, isError: true);
    } catch (_) {
      if (mounted) _showSnackBar('Unexpected error occurred', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    try {
      await _sb.auth.signOut();
    } on AuthException catch (e) {
      if (mounted) _showSnackBar(e.message, isError: true);
    } catch (_) {
      if (mounted) _showSnackBar('Unexpected error occurred', isError: true);
    } finally {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    // TODO: hubungkan ke rute sebenarnya (Home/Explore/Order/Me)
    // if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  Future<void> _openEditSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : () async {
                  Navigator.of(ctx).pop();
                  await _updateProfile();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF008060);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            children: [
              // Bagian Profil Atas (desainmu)
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarUrl != null
                        ? NetworkImage(_avatarUrl!)
                        : const NetworkImage(
                            'https://api.dicebear.com/7.x/initials/png?seed=PP'),
                    onBackgroundImageError: (_, __) {},
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _openEditSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1, indent: 20, endIndent: 20),

              // Daftar Menu (desainmu)
              _buildProfileMenuItem(
                icon: Icons.history,
                title: 'History',
                color: primaryColor,
                onTap: () {
                  // TODO: Arahkan ke halaman riwayat
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Location',
                color: primaryColor,
                onTap: () {
                  // TODO: Arahkan ke pengaturan lokasi
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.language,
                title: 'Language',
                color: primaryColor,
                onTap: () {
                  // TODO: Arahkan ke pengaturan bahasa
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                color: primaryColor,
                onTap: () {
                  // TODO: Arahkan ke help center
                },
              ),
              _buildProfileMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                color: primaryColor,
                onTap: _loading ? null : _signOut,
              ),
              const SizedBox(height: 12),
            ],
          ),

          // Overlay loading
          if (_loading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Helper item menu
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
