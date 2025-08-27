import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String currentAddress;
  final int cartItemCount;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;

  const LocationHeaderWidget({
    super.key,
    required this.currentAddress,
    this.cartItemCount = 0,
    this.onLocationTap,
    this.onNotificationTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onLocationTap?.call();
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver to',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentAddress,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'keyboard_arrow_down',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onNotificationTap?.call();
              },
              child: Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'notifications_outlined',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onCartTap?.call();
              },
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'shopping_bag_outlined',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 5.w,
                          minHeight: 5.w,
                        ),
                        child: Text(
                          cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onError,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
