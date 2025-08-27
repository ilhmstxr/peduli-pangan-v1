import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsSection({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildReviewCard(context, theme, review);
      },
    );
  }

  Widget _buildReviewCard(
      BuildContext context, ThemeData theme, Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info and Rating
            Row(
              children: [
                // User Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review["userAvatar"] as String),
                  backgroundColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                ),

                SizedBox(width: 3.w),

                // User Name and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review["userName"] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        review["date"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        review["rating"].toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Review Text
            Text(
              review["comment"] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),

            // Review Images (if any)
            if (review["images"] != null &&
                (review["images"] as List).isNotEmpty) ...[
              SizedBox(height: 2.h),
              SizedBox(
                height: 15.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (review["images"] as List).length,
                  itemBuilder: (context, imageIndex) {
                    final imageUrl =
                        (review["images"] as List)[imageIndex] as String;
                    return Container(
                      margin: EdgeInsets.only(right: 2.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: imageUrl,
                          width: 15.h,
                          height: 15.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // Helpful Actions
            Row(
              children: [
                // Helpful Button
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle helpful action
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'thumb_up_outlined',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Helpful (${review["helpfulCount"]})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Not Helpful Button
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle not helpful action
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'thumb_down_outlined',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Not Helpful',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
