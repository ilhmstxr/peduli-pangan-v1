import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('assets/images/no-image.jpg'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Fulan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/edit-profile');
                                  },
                                  child: const Icon(Icons.edit, size: 18, color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'fulan@gmail.com',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Accessibility', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            _ProfileMenuItem(
              icon: Icons.history,
              title: 'History',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.location_on,
              title: 'Location',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.language,
              title: 'Language',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Other', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            _ProfileMenuItem(
              icon: Icons.privacy_tip,
              title: 'Privacy Police',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.description,
              title: 'Terms Of Service',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.green[800],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home-screen');
              break;
            case 1:
              // TODO: Implement Explore navigation
              break;
            case 2:
              Navigator.pushNamed(context, '/order-screen');
              break;
            case 3:
              // Sudah di halaman Profile
              break;
          }
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.green[800]),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: onTap,
        ),
      ),
    );
  }
}
