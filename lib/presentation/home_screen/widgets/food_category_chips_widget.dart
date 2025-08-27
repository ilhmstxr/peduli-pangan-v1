import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FoodCategoryChipsWidget extends StatefulWidget {
  const FoodCategoryChipsWidget({super.key});

  @override
  State<FoodCategoryChipsWidget> createState() =>
      _FoodCategoryChipsWidgetState();
}

class _FoodCategoryChipsWidgetState extends State<FoodCategoryChipsWidget> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      "id": 1,
      "name": "All",
      "icon": "restaurant",
    },
    {
      "id": 2,
      "name": "Pizza",
      "icon": "local_pizza",
    },
    {
      "id": 3,
      "name": "Burgers",
      "icon": "lunch_dining",
    },
    {
      "id": 4,
      "name": "Asian",
      "icon": "ramen_dining",
    },
    {
      "id": 5,
      "name": "Italian",
      "icon": "restaurant",
    },
    {
      "id": 6,
      "name": "Mexican",
      "icon": "local_dining",
    },
    {
      "id": 7,
      "name": "Desserts",
      "icon": "cake",
    },
    {
      "id": 8,
      "name": "Healthy",
      "icon": "eco",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: category["icon"] as String,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    category["name"] as String,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
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
