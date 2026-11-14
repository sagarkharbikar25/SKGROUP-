import 'package:flutter/material.dart';

class SortOption {
  final String label;
  final String sortBy;
  final String order;

  const SortOption({required this.label, required this.sortBy, required this.order});
}

class SortBottomSheet extends StatelessWidget {
  final String currentSortBy;
  final String currentOrder;
  final ValueChanged<SortOption> onSelect;

  static const List<SortOption> options = [
    SortOption(label: 'Featured / Default', sortBy: 'id', order: 'asc'),
    SortOption(label: 'Price: Low to High', sortBy: 'price', order: 'asc'),
    SortOption(label: 'Price: High to Low', sortBy: 'price', order: 'desc'),
    SortOption(label: 'Highest Rating', sortBy: 'rating', order: 'desc'),
    SortOption(label: 'Title: A to Z', sortBy: 'title', order: 'asc'),
  ];

  const SortBottomSheet({
    super.key,
    required this.currentSortBy,
    required this.currentOrder,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((option) {
              final isSelected =
                  currentSortBy == option.sortBy && currentOrder == option.order;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
                title: Text(
                  option.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
