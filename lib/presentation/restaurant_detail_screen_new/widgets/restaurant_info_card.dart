import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RestaurantInfoCard extends StatelessWidget {
  final String name;
  final String address;
  final double rating;

  const RestaurantInfoCard({
    super.key,
    required this.name,
    required this.address,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // Margin atas untuk memberi ruang bagi logo yang "mengambang"
      margin: EdgeInsets.only(top: 6.h, left: 4.w, right: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Restoran
          Text(
            name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),

          // Alamat dan Rating
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 20),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.star, color: Colors.orange, size: 20),
              SizedBox(width: 1.w),
              Text(
                rating.toString(),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Placeholder Peta
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://i.ibb.co/L8yC4yW/map-placeholder.png', // URL placeholder peta
              width: double.infinity,
              height: 15.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
