import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RestaurantHeroSection extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantHeroSection({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 35.h,
      child: Stack(
        children: [
          // Hero Image
          CustomImageWidget(
            imageUrl: restaurant["image"] as String,
            width: double.infinity,
            height: 35.h,
            fit: BoxFit.cover,
          ),

          // Gradient Overlay
          Container(
            height: 35.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Restaurant Info Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant["name"] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Cuisine Type
                  Text(
                    restaurant["cuisine"] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Rating and Delivery Info Row
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              restaurant["rating"].toString(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Delivery Time
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            restaurant["deliveryTime"] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 3.w),

                      // Delivery Fee
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'delivery_dining',
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            restaurant["deliveryFee"] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
