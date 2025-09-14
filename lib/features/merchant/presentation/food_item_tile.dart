import 'package:flutter/material.dart';

// Pastikan path import ini sesuai dengan struktur proyek Anda
import '../../produk/data/product_model.dart';

/// Widget untuk menampilkan satu item produk/makanan dengan desain baru.
///
/// Desain ini didasarkan pada referensi UI yang diberikan dan diimplementasikan
/// untuk bekerja langsung dengan model data `Product` yang telah diperbarui.
class FoodItemTile extends StatelessWidget {
  const FoodItemTile({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  // --- Helper Formatting Methods ---

  String _two(int n) => n.toString().padLeft(2, '0');

  String _formatPickupTime(String? fromStr, String? toStr) {
    // Default text jika data waktu tidak tersedia
    if (fromStr == null || toStr == null)
      return 'Pick up today 18:00 - 20:00 WIB';
    try {
      final df = DateTime.parse(fromStr);
      final dt = DateTime.parse(toStr);
      return 'Pick up today ${_two(df.hour)}:${_two(df.minute)} - ${_two(dt.hour)}:${_two(dt.minute)} WIB';
    } catch (e) {
      // Fallback jika format tanggal/waktu tidak valid
      return 'Pick up today 18:00 - 20:00 WIB';
    }
  }

  String _formatDistance(num? distanceInMeters) {
    // Default value jika data jarak tidak tersedia
    final d = distanceInMeters?.toDouble() ?? 800.0;
    if (d >= 1000) {
      return '${(d / 1000).toStringAsFixed(1)}km';
    }
    return '${d.toStringAsFixed(0)}m';
  }

  String _formatIdr(double v) {
    final s = v.toInt().toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write('.');
    }
    // Menggunakan 'Rp' sebagai prefix, bukan 'Rp ' agar sesuai UI
    return 'Rp ${b.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- PERUBAHAN UTAMA: Menggunakan properti `nama` dan `harga` ---
    final title = product.name;
    final imageUrl = product.name ?? ''; //IMPROVE image url nya masih salah
    final price = product.price;
    final stockLeft = product.stock;

    // Mengekstrak data tambahan dari `attributes` dengan aman
    final attributes = product.attributes ?? {};
    final isVeggie =
        attributes['is_veggie'] as bool? ?? true; // default true untuk demo
    final pickupFrom = attributes['pickup_from'] as String?;
    final pickupTo = attributes['pickup_to'] as String?;
    final distanceM = attributes['distance_m'] as num?;

    final pickupText = _formatPickupTime(pickupFrom, pickupTo);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk (diubah menjadi CircleAvatar)
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.fastfood, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),

            // Informasi Detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Judul dan Stok
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (stockLeft > 0) ...[
                        const SizedBox(width: 8),
                        _StockPill(stockLeft),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Waktu Pick up
                  Text(
                    pickupText,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),

                  // Baris Badge Informasi
                  Row(
                    children: [
                      if (isVeggie) ...[
                        const _InfoBadge(
                          icon: Icons.eco_rounded,
                          color: Color(0xFF3BB273),
                        ),
                        const SizedBox(width: 12),
                      ],
                      _InfoBadge(
                        icon: Icons.location_on_outlined,
                        text: _formatDistance(distanceM),
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 12),
                      _InfoBadge(
                        icon: Icons.payments_outlined,
                        text: _formatIdr(price),
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets untuk Desain Baru ---

/// Badge kecil untuk menampilkan sisa stok.
class _StockPill extends StatelessWidget {
  const _StockPill(this.left);
  final int left;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE7BA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$left left',
        style: const TextStyle(
          color: Color(0xFF8A4600),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Badge untuk menampilkan ikon beserta teks (misal: jarak, harga).
class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.icon, this.text, required this.color});
  final IconData icon;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        if (text != null) ...[
          const SizedBox(width: 4),
          Text(
            text!,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
