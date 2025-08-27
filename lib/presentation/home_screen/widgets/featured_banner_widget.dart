import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedBannerWidget extends StatefulWidget {
  const FeaturedBannerWidget({super.key});

  @override
  State<FeaturedBannerWidget> createState() => _FeaturedBannerWidgetState();
}

class _FeaturedBannerWidgetState extends State<FeaturedBannerWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _bannerData = [
    {
      "id": 1,
      "title": "Free Delivery on First Order",
      "subtitle": "Use code WELCOME20",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "backgroundColor": "#4CAF50",
    },
    {
      "id": 2,
      "title": "Pizza Paradise Special",
      "subtitle": "Buy 1 Get 1 Free on all pizzas",
      "image":
          "https://images.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg",
      "backgroundColor": "#FF5722",
    },
    {
      "id": 3,
      "title": "Healthy Bowl Week",
      "subtitle": "20% off on all healthy bowls",
      "image":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "backgroundColor": "#8BC34A",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        final nextIndex = (_currentIndex + 1) % _bannerData.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _bannerData.length,
              itemBuilder: (context, index) {
                final banner = _bannerData[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Color(int.parse(
                            banner["backgroundColor"].replaceAll('#', '0xFF'))),
                        Color(int.parse(banner["backgroundColor"]
                                .replaceAll('#', '0xFF')))
                            .withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10.w,
                          top: -5.h,
                          child: CustomImageWidget(
                            imageUrl: banner["image"] as String,
                            width: 40.w,
                            height: 25.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 4.w,
                          top: 3.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50.w,
                                child: Text(
                                  banner["title"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              SizedBox(
                                width: 45.w,
                                child: Text(
                                  banner["subtitle"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color(int.parse(
                                      banner["backgroundColor"]
                                          .replaceAll('#', '0xFF'))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Order Now',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
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
              },
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _bannerData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                width: _currentIndex == index ? 6.w : 2.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
