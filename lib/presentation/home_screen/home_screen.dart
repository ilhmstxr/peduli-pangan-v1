import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/featured_banner_widget.dart';
import './widgets/food_category_chips_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/restaurant_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  bool _isLoading = false;
  bool _hasError = false;
  String _currentAddress = "123 Main Street, Downtown";
  int _cartItemCount = 3;
  int _currentTabIndex = 0;

  final List<Map<String, dynamic>> _restaurantData = [
    {
      "id": 1,
      "name": "Pizza Palace",
      "cuisine": "Italian • Pizza",
      "rating": 4.5,
      "deliveryTime": 25,
      "deliveryFee": 0,
      "distance": 1.2,
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
    },
    {
      "id": 2,
      "name": "Burger Junction",
      "cuisine": "American • Burgers",
      "rating": 4.3,
      "deliveryTime": 20,
      "deliveryFee": 2.99,
      "distance": 0.8,
      "image":
          "https://images.pixabay.com/photo/2020/10/05/19/55/hamburger-5630646_1280.jpg",
      "isFavorite": true,
    },
    {
      "id": 3,
      "name": "Sushi Zen",
      "cuisine": "Japanese • Sushi",
      "rating": 4.7,
      "deliveryTime": 35,
      "deliveryFee": 0,
      "distance": 2.1,
      "image":
          "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isFavorite": false,
    },
    {
      "id": 4,
      "name": "Taco Fiesta",
      "cuisine": "Mexican • Tacos",
      "rating": 4.2,
      "deliveryTime": 30,
      "deliveryFee": 1.99,
      "distance": 1.5,
      "image":
          "https://images.pexels.com/photos/4958792/pexels-photo-4958792.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
    },
    {
      "id": 5,
      "name": "Green Bowl",
      "cuisine": "Healthy • Salads",
      "rating": 4.6,
      "deliveryTime": 15,
      "deliveryFee": 0,
      "distance": 0.5,
      "image":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      "isFavorite": true,
    },
    {
      "id": 6,
      "name": "Pasta Corner",
      "cuisine": "Italian • Pasta",
      "rating": 4.4,
      "deliveryTime": 28,
      "deliveryFee": 2.49,
      "distance": 1.8,
      "image":
          "https://images.pixabay.com/photo/2017/02/15/10/39/salad-2068220_1280.jpg",
      "isFavorite": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
    _loadRestaurants();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurants() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await _loadRestaurants();
  }

  void _onRestaurantTap(Map<String, dynamic> restaurant) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/restaurant-detail-screen');
  }

  void _onFavoriteToggle(Map<String, dynamic> restaurant) {
    HapticFeedback.lightImpact();
    // Handle favorite toggle logic
  }

  void _onLocationTap() {
    HapticFeedback.lightImpact();
    _showLocationBottomSheet();
  }

  void _onNotificationTap() {
    HapticFeedback.lightImpact();
    // Handle notification tap
  }

  void _onCartTap() {
    HapticFeedback.lightImpact();
    _showCartBottomSheet();
  }

  void _onQRScanTap() {
    HapticFeedback.mediumImpact();
    _showQRScannerBottomSheet();
  }

  void _onExpandSearch() {
    HapticFeedback.lightImpact();
    // Handle expand search radius
    _loadRestaurants();
  }

  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Delivery Location',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Use Current Location',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Enable location services for accurate delivery',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              child: Row(
                children: [
                  Text(
                    'Your Cart',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text(
                    '$_cartItemCount items',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Cart items will be displayed here'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRScannerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              child: Text(
                'Scan QR Code',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'qr_code_scanner',
                        color: Colors.white,
                        size: 80,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Point camera at QR code',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          LocationHeaderWidget(
            currentAddress: _currentAddress,
            cartItemCount: _cartItemCount,
            onLocationTap: _onLocationTap,
            onNotificationTap: _onNotificationTap,
            onCartTap: _onCartTap,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppTheme.lightTheme.primaryColor,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const FeaturedBannerWidget(),
                        const FoodCategoryChipsWidget(),
                        SizedBox(height: 1.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              Text(
                                'Restaurants near you',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'See all',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isLoading
                      ? const SliverToBoxAdapter(
                          child: LoadingSkeletonWidget(),
                        )
                      : _hasError || _restaurantData.isEmpty
                          ? SliverToBoxAdapter(
                              child: EmptyStateWidget(
                                onExpandSearch: _onExpandSearch,
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final restaurant = _restaurantData[index];
                                  return RestaurantCardWidget(
                                    restaurant: restaurant,
                                    onTap: () => _onRestaurantTap(restaurant),
                                    onFavoriteToggle: () =>
                                        _onFavoriteToggle(restaurant),
                                  );
                                },
                                childCount: _restaurantData.length,
                              ),
                            ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 10.h),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onQRScanTap,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'qr_code_scanner',
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: CustomIconWidget(
                  iconName: _currentTabIndex == 0 ? 'home' : 'home_outlined',
                  color: _currentTabIndex == 0
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Home',
              ),
              Tab(
                icon: CustomIconWidget(
                  iconName:
                      _currentTabIndex == 1 ? 'search' : 'search_outlined',
                  color: _currentTabIndex == 1
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Search',
              ),
              Tab(
                icon: CustomIconWidget(
                  iconName: _currentTabIndex == 2
                      ? 'receipt_long'
                      : 'receipt_long_outlined',
                  color: _currentTabIndex == 2
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Orders',
              ),
              Tab(
                icon: CustomIconWidget(
                  iconName: _currentTabIndex == 3 ? 'person' : 'person_outline',
                  color: _currentTabIndex == 3
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                text: 'Profile',
              ),
            ],
            labelColor: AppTheme.lightTheme.primaryColor,
            unselectedLabelColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            indicatorColor: AppTheme.lightTheme.primaryColor,
            onTap: (index) {
              HapticFeedback.lightImpact();
              if (index != 0) {
                Navigator.pushNamed(context, '/home-screen');
              }
            },
          ),
        ),
      ),
    );
  }
}
