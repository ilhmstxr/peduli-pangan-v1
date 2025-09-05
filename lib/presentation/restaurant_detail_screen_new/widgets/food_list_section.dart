import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'food_item_tile.dart';

class FoodListSection extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems;

  const FoodListSection({
    super.key,
    required this.foodItems,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Header "Food Available" dan "See All"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Food Available',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.green),
                    ),
                    Icon(Icons.chevron_right, color: Colors.green, size: 20),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Daftar makanan
          ListView.builder(
            itemCount: foodItems.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FoodItemTile(
                item: foodItems[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
