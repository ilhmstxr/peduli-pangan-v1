import 'package:flutter/material.dart';
import 'widgets/alamat_tile.dart';
import 'alamat_form_screen.dart';

class AlamatListScreen extends StatelessWidget {
  static const green = Color(0xFF0C7A4B);

  const AlamatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 20),
                  // Card
                  const AlamatTile(
                    label: 'Home',
                    fullAlamat: 'Gunung Anyar Tambak Utara, Surabaya, Indonesia',
                  ),
                  const Spacer(),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AlamatFormScreen(),
                              ),
                            );
                          },
                          child: const Text('New Alamat',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Circular back button (kiri atas) sesuai referensi
            Positioned(
              left: 16,
              top: 12,
              child: _BackCircleButton(
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _BackCircleButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlamatListScreen.green,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }
}
