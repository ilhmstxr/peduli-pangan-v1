import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MenuItemCard extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu Item Details
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      widget.menuItem["name"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Description
                    Text(
                      widget.menuItem["description"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.5.h),

                    // Price and Add Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          widget.menuItem["price"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Add Button or Quantity Stepper
                        quantity == 0
                            ? _buildAddButton(theme)
                            : _buildQuantityStepper(theme),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.w),

              // Menu Item Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: widget.menuItem["image"] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        setState(() {
          quantity = 1;
        });
        widget.onAddToCart();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: Text(
        'ADD',
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuantityStepper(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Button
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                if (quantity > 0) {
                  quantity--;
                }
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'remove',
                color: AppTheme.lightTheme.primaryColor,
                size: 18,
              ),
            ),
          ),

          // Quantity
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              quantity.toString(),
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Increase Button
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                quantity++;
              });
              widget.onAddToCart();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.primaryColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
