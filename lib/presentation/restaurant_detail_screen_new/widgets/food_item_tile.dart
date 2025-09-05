import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class FoodItemTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const FoodItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Menentukan ikon berdasarkan tipe makanan dari data
    final IconData typeIconData =
        item['type'] == 'dine-in' ? Icons.storefront : Icons.eco;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          children: [
            // Gambar Makanan dengan ikon overlay
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Stack(
                children: [
                  // Gambar utama
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(item['image']!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Ikon overlay di pojok kanan bawah
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        typeIconData,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 4.w),

            // Detail Item
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['name']!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.grey[600], size: 16),
                      SizedBox(width: 1.w),
                      Text(item['distance']!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600])),
                      SizedBox(width: 4.w),
                      Icon(Icons.shopping_cart,
                          color: Colors.grey[600], size: 16),
                      SizedBox(width: 1.w),
                      Text(item['price']!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),

            // Tombol "View"
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006A4E), // Warna hijau tua
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.w),
              ),
              child: const Text('View'),
            ),
          ],
        ),
      ),
    );
  }
}

