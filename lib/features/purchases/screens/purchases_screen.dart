import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/purchase/purchase_model.dart';
import '../../../providers/purchase_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/purchase_tile.dart';

class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({super.key});

  @override
  ConsumerState<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen> {
  String _sortBy = 'recent';
  int _reviewRating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: Column(
        children: [
          // Sort Toggle Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Recent'),
                  selected: _sortBy == 'recent',
                  onSelected: (selected) {
                    if (selected) setState(() => _sortBy = 'recent');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Alphabetical'),
                  selected: _sortBy == 'alphabetical',
                  onSelected: (selected) {
                    if (selected) setState(() => _sortBy = 'alphabetical');
                  },
                ),
              ],
            ),
          ),

          // Purchases List
          Expanded(
            child: purchasesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => AppErrorWidget(
                onRetry: () =>
                    ref.read(purchasesProvider.notifier).refresh(),
              ),
              data: (purchases) {
                if (purchases.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.shopping_bag_outlined,
                    title: 'No purchases yet',
                    subtitle:
                        'Browse the marketplace to find your first workflow',
                    actionLabel: 'Browse Marketplace',
                    onAction: () => context.go('/marketplace'),
                  );
                }

                final sorted = List<Purchase>.from(purchases);
                if (_sortBy == 'recent') {
                  sorted.sort((a, b) => (b.createdAt ?? DateTime(0))
                      .compareTo(a.createdAt ?? DateTime(0)));
                } else {
                  sorted.sort((a, b) =>
                      (a.workflow?.title ?? '')
                          .compareTo(b.workflow?.title ?? ''));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final purchase = sorted[index];
                    return PurchaseTile(
                      purchase: purchase,
                      onDeploy: () => context.push('/deployments'),
                      onDownload: () {},
                      onReview: () => _showReviewSheet(context, purchase),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context, Purchase purchase) {
    _reviewRating = 0;
    _reviewController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (builderContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(builderContext).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Write a Review', style: AppTypography.h3),
                  const SizedBox(height: 16),

                  // Star rating row
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() => _reviewRating = index + 1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            index < _reviewRating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 32,
                            color: index < _reviewRating
                                ? AppColors.warning
                                : AppColors.textSecondary,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Comment field
                  TextField(
                    controller: _reviewController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.sm,
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.sm,
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  AppButton(
                    label: 'Submit Review',
                    variant: AppButtonVariant.primary,
                    onPressed: () {
                      Navigator.of(builderContext).pop();
                    },
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
