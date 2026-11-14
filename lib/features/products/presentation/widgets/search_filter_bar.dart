import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onSortTap;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input and Sort Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.sort_rounded, color: theme.colorScheme.primary),
                  tooltip: 'Sort Products',
                  onPressed: onSortTap,
                ),
              ),
            ],
          ),
        ),

        // Horizontal Category Chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = selectedCategory == null;
                return ChoiceChip(
                  label: const Text('All'),
                  selected: isSelected,
                  onSelected: (_) {
                    onCategorySelected(null);
                  },
                );
              }

              final category = categories[index - 1];
              final isSelected = selectedCategory == category;
              return ChoiceChip(
                label: Text(
                  category[0].toUpperCase() + category.substring(1),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  onCategorySelected(selected ? category : null);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
