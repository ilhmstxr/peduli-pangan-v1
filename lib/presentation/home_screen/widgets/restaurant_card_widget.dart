import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RestaurantCardWidget extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const RestaurantCardWidget({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  State<RestaurantCardWidget> createState() => _RestaurantCardWidgetState();
}

class _RestaurantCardWidgetState extends State<RestaurantCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _isFavorite = widget.restaurant["isFavorite"] as bool? ?? false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  void _showQuickActions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      widget.restaurant["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: 'restaurant_menu',
                            label: 'View Menu',
                            onTap: () {
                              Navigator.pop(context);
                              widget.onTap?.call();
                            },
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: 'directions',
                            label: 'Directions',
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: 'share',
                            label: 'Share',
                            onTap: () {
                              Navigator.pop(context);
                            },
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
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: _showQuickActions,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: CustomImageWidget(
                          imageUrl: widget.restaurant["image"] as String,
                          width: double.infinity,
                          height: 20.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 2.h,
                        right: 3.w,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            widget.onFavoriteToggle?.call();
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomIconWidget(
                              iconName:
                                  _isFavorite ? 'favorite' : 'favorite_border',
                              color: _isFavorite
                                  ? Colors.red
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      if (widget.restaurant["deliveryTime"] != null)
                        Positioned(
                          top: 2.h,
                          left: 3.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${widget.restaurant["deliveryTime"]} min",
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.restaurant["name"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.restaurant["rating"] != null) ...[
                              CustomIconWidget(
                                iconName: 'star',
                                color: Colors.amber,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                widget.restaurant["rating"].toString(),
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        if (widget.restaurant["cuisine"] != null)
                          Text(
                            widget.restaurant["cuisine"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            if (widget.restaurant["deliveryFee"] != null) ...[
                              CustomIconWidget(
                                iconName: 'delivery_dining',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                widget.restaurant["deliveryFee"] == 0
                                    ? "Free delivery"
                                    : "\$${widget.restaurant["deliveryFee"]}",
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: widget.restaurant["deliveryFee"] == 0
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight:
                                      widget.restaurant["deliveryFee"] == 0
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                ),
                              ),
                            ],
                            const Spacer(),
                            if (widget.restaurant["distance"] != null) ...[
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                "${widget.restaurant["distance"]} km",
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
