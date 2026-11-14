import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_tokens.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final currentIndex = navigationShell.currentIndex;

    final navItems = const [
      (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
      (icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'Catalog'),
      (icon: Icons.favorite_outline, activeIcon: Icons.favorite_rounded, label: 'Saved'),
      (icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Profile'),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: cs.surface.withOpacity(0.96),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: cs.outline, width: 1.2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == currentIndex,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    curve: AppMotion.curve,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16.0 : 10.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 22,
                          color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
