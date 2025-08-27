import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RestaurantInfoSection extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantInfoSection({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hours Section
          _buildHoursSection(theme),

          SizedBox(height: 4.h),

          // Location Section
          _buildLocationSection(theme),

          SizedBox(height: 4.h),

          // Contact Section
          _buildContactSection(theme),

          SizedBox(height: 4.h),

          // Delivery Policies Section
          _buildDeliveryPoliciesSection(theme),
        ],
      ),
    );
  }

  Widget _buildHoursSection(ThemeData theme) {
    final hours = restaurant["hours"] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hours',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: hours.entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        entry.value as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Map Placeholder
              Container(
                height: 25.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    // Map background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                    ),
                    // Map icon
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 40,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'View on Map',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Address Info
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant["address"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'directions',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Get Directions',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Phone
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle phone call
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'phone',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          restaurant["phone"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),

                // Email
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle email
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'email',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          restaurant["email"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryPoliciesSection(ThemeData theme) {
    final policies = restaurant["deliveryPolicies"] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Policies',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: policies.map((policy) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 1.h),
                        width: 1.w,
                        height: 1.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          policy,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
