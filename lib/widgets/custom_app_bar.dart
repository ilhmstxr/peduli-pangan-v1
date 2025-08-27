import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for food delivery application
/// Implements clean, minimalist design with contextual actions
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar variant types
  enum AppBarVariant {
    /// Standard app bar with title and optional actions
    standard,
    /// Search app bar with search field
    search,
    /// Profile app bar with user avatar
    profile,
    /// Cart app bar with cart count badge
    cart,
  }

  /// The variant of the app bar
  final AppBarVariant variant;
  
  /// The title text to display
  final String? title;
  
  /// Whether to show the back button
  final bool showBackButton;
  
  /// Whether to show the search action
  final bool showSearchAction;
  
  /// Whether to show the cart action with badge
  final bool showCartAction;
  
  /// Cart item count for badge display
  final int cartItemCount;
  
  /// Whether to show the profile action
  final bool showProfileAction;
  
  /// Custom actions to display
  final List<Widget>? actions;
  
  /// Search controller for search variant
  final TextEditingController? searchController;
  
  /// Search hint text
  final String searchHint;
  
  /// Callback when search text changes
  final ValueChanged<String>? onSearchChanged;
  
  /// Callback when search is submitted
  final ValueChanged<String>? onSearchSubmitted;
  
  /// Profile image URL for profile variant
  final String? profileImageUrl;
  
  /// Background color override
  final Color? backgroundColor;
  
  /// Elevation override
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.variant = AppBarVariant.standard,
    this.title,
    this.showBackButton = true,
    this.showSearchAction = false,
    this.showCartAction = false,
    this.cartItemCount = 0,
    this.showProfileAction = false,
    this.actions,
    this.searchController,
    this.searchHint = 'Search restaurants, dishes...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.profileImageUrl,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: theme.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
      centerTitle: variant == AppBarVariant.search ? false : true,
      titleSpacing: variant == AppBarVariant.search ? 0 : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) return null;
    
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      tooltip: 'Back',
    );
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case AppBarVariant.search:
        return Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: searchController?.text.isNotEmpty == true
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        searchController?.clear();
                        onSearchChanged?.call('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: theme.textTheme.bodyMedium,
          ),
        );
      
      case AppBarVariant.profile:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profileImageUrl != null)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(profileImageUrl!),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            const SizedBox(width: 12),
            if (title != null)
              Text(
                title!,
                style: theme.appBarTheme.titleTextStyle,
              ),
          ],
        );
      
      default:
        return title != null
            ? Text(
                title!,
                style: theme.appBarTheme.titleTextStyle,
              )
            : null;
    }
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> actionWidgets = [];

    // Add search action
    if (showSearchAction && variant != AppBarVariant.search) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Navigate to search or show search
            Navigator.pushNamed(context, '/home-screen');
          },
          tooltip: 'Search',
        ),
      );
    }

    // Add cart action with badge
    if (showCartAction) {
      actionWidgets.add(
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                // Show cart bottom sheet or navigate to cart
                _showCartBottomSheet(context);
              },
              tooltip: 'Cart',
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Add profile action
    if (showProfileAction && variant != AppBarVariant.profile) {
      actionWidgets.add(
        IconButton(
          icon: profileImageUrl != null
              ? CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(profileImageUrl!),
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                )
              : const Icon(Icons.person_outline_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Navigate to profile or show profile menu
          },
          tooltip: 'Profile',
        ),
      );
    }

    // Add custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Your Cart',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text(
                    '$cartItemCount items',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}