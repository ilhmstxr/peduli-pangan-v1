import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom bottom navigation bar for food delivery application
/// Implements clean, minimalist design with haptic feedback
class CustomBottomBar extends StatelessWidget {
  /// Bottom bar variant types
  enum BottomBarVariant {
    /// Standard bottom navigation with icons and labels
    standard,
    /// Floating bottom bar with elevated appearance
    floating,
    /// Minimal bottom bar with icons only
    minimal,
  }

  /// Navigation item data class
  static class NavigationItem {
    final IconData icon;
    final IconData? activeIcon;
    final String label;
    final String route;
    final int? badgeCount;

    const NavigationItem({
      required this.icon,
      this.activeIcon,
      required this.label,
      required this.route,
      this.badgeCount,
    });
  }

  /// The variant of the bottom bar
  final BottomBarVariant variant;
  
  /// Currently selected index
  final int currentIndex;
  
  /// Callback when item is tapped
  final ValueChanged<int>? onTap;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Selected item color override
  final Color? selectedItemColor;
  
  /// Unselected item color override
  final Color? unselectedItemColor;
  
  /// Elevation override
  final double? elevation;
  
  /// Whether to show labels
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    this.variant = BottomBarVariant.standard,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
  });

  /// Predefined navigation items for food delivery app
  static List<NavigationItem> get navigationItems => [
    const NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      route: '/home-screen',
    ),
    const NavigationItem(
      icon: Icons.restaurant_outlined,
      activeIcon: Icons.restaurant_rounded,
      label: 'Restaurants',
      route: '/restaurant-detail-screen',
    ),
    const NavigationItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search_rounded,
      label: 'Search',
      route: '/home-screen',
    ),
    const NavigationItem(
      icon: Icons.favorite_outline_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Favorites',
      route: '/home-screen',
    ),
    const NavigationItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      route: '/home-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme);
      case BottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme);
      default:
        return _buildStandardBottomBar(context, theme);
    }
  }

  Widget _buildStandardBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return _buildNavigationItem(
                context,
                theme,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: navigationItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;
                  
                  return _buildNavigationItem(
                    context,
                    theme,
                    item,
                    isSelected,
                    index,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return _buildMinimalNavigationItem(
                context,
                theme,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    ThemeData theme,
    NavigationItem item,
    bool isSelected,
    int index,
  ) {
    final selectedColor = selectedItemColor ?? 
        theme.bottomNavigationBarTheme.selectedItemColor ?? 
        theme.colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? 
        theme.bottomNavigationBarTheme.unselectedItemColor ?? 
        theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 24,
                    ),
                  ),
                  if (item.badgeCount != null && item.badgeCount! > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          item.badgeCount! > 9 ? '9+' : item.badgeCount.toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: (isSelected 
                      ? theme.bottomNavigationBarTheme.selectedLabelStyle 
                      : theme.bottomNavigationBarTheme.unselectedLabelStyle) ?? 
                      theme.textTheme.labelSmall!.copyWith(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalNavigationItem(
    BuildContext context,
    ThemeData theme,
    NavigationItem item,
    bool isSelected,
    int index,
  ) {
    final selectedColor = selectedItemColor ?? 
        theme.bottomNavigationBarTheme.selectedItemColor ?? 
        theme.colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? 
        theme.bottomNavigationBarTheme.unselectedItemColor ?? 
        theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => _handleTap(context, index, item.route),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 24,
                ),
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      child: Text(
                        item.badgeCount! > 9 ? '9+' : item.badgeCount.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onError,
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    HapticFeedback.lightImpact();
    
    // Call the onTap callback if provided
    onTap?.call(index);
    
    // Navigate to the route if different from current
    if (index != currentIndex) {
      Navigator.pushNamed(context, route);
    }
  }
}