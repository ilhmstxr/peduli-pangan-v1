import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FloatingCartSummary extends StatefulWidget {
  final int itemCount;
  final String totalPrice;
  final VoidCallback onViewCart;

  const FloatingCartSummary({
    super.key,
    required this.itemCount,
    required this.totalPrice,
    required this.onViewCart,
  });

  @override
  State<FloatingCartSummary> createState() => _FloatingCartSummaryState();
}

class _FloatingCartSummaryState extends State<FloatingCartSummary>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Animate in when cart has items
    if (widget.itemCount > 0) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(FloatingCartSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount > 0 && oldWidget.itemCount == 0) {
      _animationController.forward();
    } else if (widget.itemCount == 0 && oldWidget.itemCount > 0) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return widget.itemCount > 0
        ? SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    widget.onViewCart();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: Row(
                      children: [
                        // Cart Icon with Badge
                        Stack(
                          children: [
                            CustomIconWidget(
                              iconName: 'shopping_bag',
                              color: Colors.white,
                              size: 24,
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  widget.itemCount > 99
                                      ? '99+'
                                      : widget.itemCount.toString(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 3.w),

                        // Item Count and Total
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.itemCount} ${widget.itemCount == 1 ? 'item' : 'items'}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Text(
                                widget.totalPrice,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // View Cart Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Cart',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'arrow_forward_ios',
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
