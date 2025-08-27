import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MenuCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final ScrollController scrollController;

  const MenuCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category);
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
            ),
          );
        },
      ),
    );
  }
}
