import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/workflow/workflow_model.dart';
import '../../../providers/seller_provider.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';
import '../../marketplace/widgets/category_chip.dart';

class SellerHomeScreen extends ConsumerStatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  ConsumerState<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends ConsumerState<SellerHomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workflowsAsync = ref.watch(sellerWorkflowsProvider);
    final earningsAsync = ref.watch(sellerEarningsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: Column(
          children: [
            // Glass header
            SafeArea(
              bottom: false,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bubble_chart_outlined,
                            color: Color(0xFFCEBDFF), size: 20),
                        const SizedBox(width: 8),
                        GradientText(
                          'FlowMarket',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.notifications_outlined,
                          color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                            ),
                          ),
                          child: const Icon(Icons.person,
                              size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Workflows',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage, track, and publish your automated logic modules.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Stats bento grid
                          earningsAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (earnings) => _StatsBento(
                              totalSales: earnings['totalSales'] as int? ?? 1284,
                              revenue: earnings['revenue'] as double? ?? 14200,
                              active: earnings['active'] as int? ?? 12,
                              drafts: earnings['drafts'] as int? ?? 3,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Search bar
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.06),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.1),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (v) =>
                                            setState(() => _query = v),
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        cursorColor: const Color(0xFFCEBDFF),
                                        decoration: InputDecoration(
                                          hintText: 'Filter workflows...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            color: Colors.white
                                                .withValues(alpha: 0.3),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 18,
                                            color: Colors.white
                                                .withValues(alpha: 0.4),
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                  child: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.06),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.1)),
                                    ),
                                    child: Icon(
                                      Icons.tune_rounded,
                                      size: 18,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Workflow list
                  workflowsAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFCEBDFF),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                    error: (_, __) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Failed to load workflows',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: const Color(0xFFFFB4AB).withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    data: (workflows) {
                      final filtered = _query.isEmpty
                          ? workflows
                          : workflows
                              .where((w) => w.title
                                  .toLowerCase()
                                  .contains(_query.toLowerCase()))
                              .toList();

                      if (filtered.isEmpty) {
                        return SliverToBoxAdapter(
                          child: EmptyStateWidget(
                            icon: Icons.folder_open_outlined,
                            title: 'No workflows yet',
                            subtitle: 'Upload your first workflow to start selling',
                            actionLabel: 'Upload Workflow',
                            onAction: () => context.push('/seller/upload'),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _SellerWorkflowCard(
                                workflow: filtered[index],
                                onEdit: () => context
                                    .push('/seller/upload'),
                                onPublish: () {},
                                onDelist: () {},
                              ),
                            ),
                            childCount: filtered.length,
                          ),
                        ),
                      );
                    },
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: GestureDetector(
        onTap: () => context.push('/seller/upload'),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFA78BFA),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Color(0xFF21005E), size: 26),
        ),
      ),
    );
  }
}

class _StatsBento extends StatelessWidget {
  final int totalSales;
  final double revenue;
  final int active;
  final int drafts;

  const _StatsBento({
    required this.totalSales,
    required this.revenue,
    required this.active,
    required this.drafts,
  });

  String _formatRevenue(double v) {
    if (v >= 1000) {
      return '\$${(v / 1000).toStringAsFixed(1)}k';
    }
    return '\$${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'TOTAL SALES',
                value: totalSales.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    ),
                color: const Color(0xFF4DDCC6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCell(
                label: 'REVENUE',
                value: _formatRevenue(revenue),
                color: const Color(0xFFCEBDFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'ACTIVE',
                value: active.toString(),
                color: const Color(0xFF4DDCC6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCell(
                label: 'DRAFTS',
                value: drafts.toString(),
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerWorkflowCard extends StatelessWidget {
  final Workflow workflow;
  final VoidCallback onEdit;
  final VoidCallback onPublish;
  final VoidCallback onDelist;

  const _SellerWorkflowCard({
    required this.workflow,
    required this.onEdit,
    required this.onPublish,
    required this.onDelist,
  });

  Color get _categoryColor => CategoryChip.colorFor(workflow.category);

  bool get _isDraft => workflow.status == WorkflowStatus.draft ||
      workflow.status == WorkflowStatus.pendingReview;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _categoryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CategoryChip.iconFor(workflow.category),
                      color: _categoryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                workflow.title,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _isDraft
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : const Color(0xFF4DDCC6)
                                        .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: _isDraft
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : const Color(0xFF4DDCC6)
                                          .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                _isDraft ? 'DRAFT' : 'ACTIVE',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: _isDraft
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : const Color(0xFF4DDCC6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.monitor_outlined,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text(
                              '\$${(workflow.oneTimePrice ?? 0).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.trending_up_rounded,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text(
                              '${workflow.purchaseCount} Sales',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                workflow.shortDescription,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                  height: 1.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),

              // Action buttons
              Row(
                children: [
                  if (_isDraft) ...[
                    Expanded(
                      child: _CardButton(
                        label: 'Publish',
                        gradient: true,
                        onTap: onPublish,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CardButton(
                        label: 'Edit',
                        onTap: onEdit,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: _CardButton(
                        label: 'Edit',
                        gradient: true,
                        onTap: onEdit,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CardButton(
                        label: 'De-list',
                        onTap: onDelist,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final String label;
  final bool gradient;
  final VoidCallback onTap;

  const _CardButton({
    required this.label,
    required this.onTap,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: gradient
              ? const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                )
              : null,
          color: gradient ? null : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(999),
          border: gradient
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: gradient ? Colors.white : Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
