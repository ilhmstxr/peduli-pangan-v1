import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onExpandSearch;

  const EmptyStateWidget({
    super.key,
    this.onExpandSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'restaurant_outlined',
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.6),
                  size: 80,
                ),
                SizedBox(height: 2.h),
                CustomIconWidget(
                  iconName: 'search_off',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                  size: 40,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No restaurants nearby',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'We couldn\'t find any restaurants in your area. Try expanding your search radius or check your location settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onExpandSearch,
              icon: CustomIconWidget(
                iconName: 'my_location',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Expand Search Radius',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton.icon(
            onPressed: () {
              // Refresh location
            },
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.primaryColor,
              size: 18,
            ),
            label: Text(
              'Refresh Location',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
