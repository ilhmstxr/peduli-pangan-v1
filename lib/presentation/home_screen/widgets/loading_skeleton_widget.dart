import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  const LoadingSkeletonWidget({super.key});

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image skeleton
                  Container(
                    width: double.infinity,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: _animation.value * 0.3),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant name skeleton
                        Container(
                          width: 60.w,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Cuisine type skeleton
                        Container(
                          width: 40.w,
                          height: 1.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Rating and delivery info skeleton
                        Row(
                          children: [
                            Container(
                              width: 15.w,
                              height: 1.5.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: _animation.value * 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 20.w,
                              height: 1.5.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: _animation.value * 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
