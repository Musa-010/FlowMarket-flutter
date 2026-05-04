import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/purchase/purchase_model.dart';
import '../../../providers/purchase_provider.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';
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
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: Column(
          children: [
            // Glass header
            SafeArea(
              bottom: false,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientText(
                        'FlowMarket',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Icon(
                        Icons.notifications_outlined,
                        color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab toggle
                    GlassCard(
                      borderRadius: BorderRadius.circular(999),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          _TabChip(
                            label: 'Active',
                            active: _sortBy == 'recent',
                            onTap: () =>
                                setState(() => _sortBy = 'recent'),
                          ),
                          _TabChip(
                            label: 'Archived',
                            active: _sortBy == 'alphabetical',
                            onTap: () =>
                                setState(() => _sortBy = 'alphabetical'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Workflows',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFCEBDFF),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: const Color(0xFFCAC4D4)
                                  .withValues(alpha: 0.6),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sort by Date',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: const Color(0xFFCAC4D4)
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Content
                    purchasesAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: Color(0xFFCEBDFF),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
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
                          sorted.sort((a, b) =>
                              (b.createdAt ?? DateTime(0))
                                  .compareTo(a.createdAt ?? DateTime(0)));
                        } else {
                          sorted.sort((a, b) =>
                              (a.workflow?.title ?? '')
                                  .compareTo(b.workflow?.title ?? ''));
                        }

                        return Column(
                          children: [
                            for (int i = 0; i < sorted.length; i++) ...[
                              PurchaseTile(
                                purchase: sorted[i],
                                onDeploy: () =>
                                    context.push('/deployments'),
                                onDownload: () {},
                                onReview: () =>
                                    _showReviewSheet(context, sorted[i]),
                              ),
                              if (i < sorted.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewSheet(BuildContext context, Purchase purchase) {
    _reviewRating = 0;
    _reviewController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D2022).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom:
                  MediaQuery.of(sheetContext).viewInsets.bottom + 24,
            ),
            child: StatefulBuilder(
              builder: (_, setSheetState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Write a Review',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setSheetState(
                              () => _reviewRating = i + 1),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              i < _reviewRating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 32,
                              color: i < _reviewRating
                                  ? const Color(0xFFFFAFD3)
                                  : const Color(0xFF948E9D),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reviewController,
                      maxLines: 4,
                      style: const TextStyle(
                        color: Color(0xFFE0E3E5),
                        fontFamily: 'Inter',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Share your experience...',
                        hintStyle: const TextStyle(
                            color: Color(0xFF948E9D)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                              color: Color(0xFFCEBDFF), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassButton(
                      label: 'Submit Review',
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: active
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.2))
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active
                  ? const Color(0xFFCEBDFF)
                  : const Color(0xFFCAC4D4).withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
