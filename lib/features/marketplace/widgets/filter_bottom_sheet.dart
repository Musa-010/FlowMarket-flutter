import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../shared/widgets/app_button.dart';
import 'category_chip.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    this.currentFilter,
    required this.onApply,
  });

  final WorkflowFilter? currentFilter;
  final ValueChanged<WorkflowFilter> onApply;

  static Future<void> show({
    required BuildContext context,
    WorkflowFilter? currentFilter,
    required ValueChanged<WorkflowFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterBottomSheet(
        currentFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  WorkflowPlatform? _platform;
  WorkflowCategory? _category;
  RangeValues _priceRange = const RangeValues(0, 200);
  double _minRating = 0;
  String _sort = 'popular';

  static const _sortOptions = [
    ('popular', 'Popular'),
    ('newest', 'Newest'),
    ('rating', 'Rating'),
    ('price_asc', 'Price \u2191'),
    ('price_desc', 'Price \u2193'),
  ];

  @override
  void initState() {
    super.initState();
    final f = widget.currentFilter;
    if (f != null) {
      _platform = f.platform;
      _category = f.category;
      _priceRange = RangeValues(
        f.minPrice ?? 0,
        f.maxPrice ?? 200,
      );
      _minRating = f.minRating ?? 0;
      _sort = f.sort ?? 'popular';
    }
  }

  void _clearAll() {
    setState(() {
      _platform = null;
      _category = null;
      _priceRange = const RangeValues(0, 200);
      _minRating = 0;
      _sort = 'popular';
    });
  }

  void _apply() {
    final filter = WorkflowFilter(
      platform: _platform,
      category: _category,
      minPrice: _priceRange.start > 0 ? _priceRange.start : null,
      maxPrice: _priceRange.end < 200 ? _priceRange.end : null,
      minRating: _minRating > 0 ? _minRating : null,
      sort: _sort != 'popular' ? _sort : null,
    );
    widget.onApply(filter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: AppRadius.full,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text('Filters', style: AppTypography.h3),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Platform
              Text('Platform', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _platformChip('n8n', WorkflowPlatform.n8n),
                  const SizedBox(width: AppSpacing.sm),
                  _platformChip('Make', WorkflowPlatform.make),
                  const SizedBox(width: AppSpacing.sm),
                  _platformChip('Both', WorkflowPlatform.both),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category
              Text('Category', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: WorkflowCategory.values.map((cat) {
                  return CategoryChip(
                    category: cat,
                    isSelected: _category == cat,
                    onTap: () {
                      setState(() {
                        _category = _category == cat ? null : cat;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Price Range
              Text('Price Range', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${_priceRange.start.toInt()}',
                    style: AppTypography.bodyMedium,
                  ),
                  Text(
                    '\$${_priceRange.end.toInt()}',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200,
                divisions: 20,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                labels: RangeLabels(
                  '\$${_priceRange.start.toInt()}',
                  '\$${_priceRange.end.toInt()}',
                ),
                onChanged: (values) {
                  setState(() => _priceRange = values);
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Minimum Rating
              Text('Minimum Rating', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: List.generate(5, (i) {
                  final starIndex = i + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _minRating =
                            _minRating == starIndex.toDouble() ? 0 : starIndex.toDouble();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        starIndex <= _minRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 32,
                        color: starIndex <= _minRating
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Sort By
              Text('Sort By', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              RadioGroup<String>(
                groupValue: _sort,
                onChanged: (value) {
                  if (value != null) setState(() => _sort = value);
                },
                child: Column(
                  children: _sortOptions.map((option) {
                    return RadioListTile<String>(
                      value: option.$1,
                      title: Text(option.$2, style: AppTypography.bodyMedium),
                      activeColor: AppColors.primary,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Actions
              Row(
                children: [
                  TextButton(
                    onPressed: _clearAll,
                    child: Text(
                      'Clear All',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: 'Apply Filters',
                      onPressed: _apply,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        );
      },
    );
  }

  Widget _platformChip(String label, WorkflowPlatform platform) {
    final selected = _platform == platform;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primary,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: selected ? Colors.white : AppColors.textPrimary,
      ),
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.border,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      onSelected: (val) {
        setState(() {
          _platform = val ? platform : null;
        });
      },
    );
  }
}
