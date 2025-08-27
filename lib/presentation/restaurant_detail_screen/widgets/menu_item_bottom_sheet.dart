import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MenuItemBottomSheet extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final VoidCallback onAddToCart;

  const MenuItemBottomSheet({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
  });

  @override
  State<MenuItemBottomSheet> createState() => _MenuItemBottomSheetState();
}

class _MenuItemBottomSheetState extends State<MenuItemBottomSheet> {
  int quantity = 1;
  String selectedSize = 'Regular';
  List<String> selectedAddons = [];

  final List<String> sizes = ['Regular', 'Large', 'Extra Large'];
  final List<Map<String, dynamic>> addons = [
    {'name': 'Extra Cheese', 'price': '\$2.00'},
    {'name': 'Extra Sauce', 'price': '\$1.50'},
    {'name': 'Extra Spicy', 'price': '\$0.50'},
    {'name': 'Extra Vegetables', 'price': '\$3.00'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: widget.menuItem["image"] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Item Name and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.menuItem["name"] as String,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        widget.menuItem["price"] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    widget.menuItem["description"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Size Selection
                  _buildSizeSelection(theme),

                  SizedBox(height: 3.h),

                  // Add-ons
                  _buildAddonsSection(theme),

                  SizedBox(height: 3.h),

                  // Quantity Selector
                  _buildQuantitySelector(theme),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Add to Cart Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    widget.onAddToCart();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add $quantity to Cart',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 2.w,
          children: sizes.map((size) {
            final isSelected = size == selectedSize;
            return ChoiceChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedSize = size;
                  });
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddonsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add-ons',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        ...addons.map((addon) {
          final isSelected = selectedAddons.contains(addon['name']);
          return CheckboxListTile(
            title: Text(
              addon['name'] as String,
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              addon['price'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  selectedAddons.add(addon['name'] as String);
                } else {
                  selectedAddons.remove(addon['name']);
                }
              });
            },
            activeColor: AppTheme.lightTheme.primaryColor,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuantitySelector(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
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
                    if (quantity > 1) {
                      quantity--;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'remove',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),

              // Quantity
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  quantity.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
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
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
