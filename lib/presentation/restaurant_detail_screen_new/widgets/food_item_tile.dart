import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FoodItemTile extends StatelessWidget {
  // Mendefinisikan parameter yang dibutuhkan sesuai desain baru
  final String imageUrl;
  final String name;
  final String pickupTime;
  final String distance;
  final String price;
  final int itemsLeft;

  const FoodItemTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.pickupTime,
    required this.distance,
    required this.price,
    required this.itemsLeft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            // Gambar Makanan
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                width: 20.w,
                height: 20.w,
                fit: BoxFit.cover,
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
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Pick up today $pickupTime',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.eco,
                            size: 16, color: Colors.green),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.location_on,
                          color: Colors.grey[600], size: 16),
                      SizedBox(width: 1.w),
                      Text(distance,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600])),
                      SizedBox(width: 2.w),
                      Icon(Icons.receipt_long, // Ikon diganti menjadi receipt/money
                          color: Colors.grey[600], size: 16),
                      SizedBox(width: 1.w),
                      Text(price,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),

            // Badge Sisa Item
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$itemsLeft left',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}