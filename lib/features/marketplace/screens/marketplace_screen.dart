import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../providers/workflow_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/workflow_card.dart';
import '../widgets/workflow_card_shimmer.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  WorkflowCategory? _selectedCategory;
  WorkflowFilter? _currentFilter;
  late final PageController _featuredController;
  late final ScrollController _scrollController;
  int _featuredPage = 0;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.85);
    _featuredController.addListener(_onFeaturedPageChanged);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _featuredController.removeListener(_onFeaturedPageChanged);
    _featuredController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onFeaturedPageChanged() {
    final page = _featuredController.page?.round() ?? 0;
    if (page != _featuredPage) {
      setState(() => _featuredPage = page);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final notifier = ref.read(workflowsProvider.notifier);
      if (notifier.hasMore) {
        notifier.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, color: AppColors.primary),
            const SizedBox(width: 6),
            Text('FlowMarket', style: AppTypography.h3),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/profile/notifications'),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildFloatingSearchBar(),
          _buildAIAssistantBanner(),
          _buildCategories(),
          _buildFeaturedWorkflows(),
          _buildAllWorkflowsHeader(),
          _buildAllWorkflowsGrid(),
          _buildLoadMore(),
        ],
      ),
    );
  }

  // 1. Floating Search Bar
  Widget _buildFloatingSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppRadius.full,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Describe your problem or search workflows...',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 2. AI Assistant Banner
  Widget _buildAIAssistantBanner() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: GestureDetector(
          onTap: () => context.go('/ai-chat'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: AppRadius.md,
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Not sure what you need?',
                        style: AppTypography.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Let AI find your workflow',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    'Ask AI',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. Categories Horizontal Scroll
  Widget _buildCategories() {
    final categories = WorkflowCategory.values;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg, top: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BROWSE BY CATEGORY',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "All" chip
                    final isSelected = _selectedCategory == null;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = null);
                          ref.read(workflowsProvider.notifier).fetchWorkflows(
                                filter: WorkflowFilter(category: null),
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: AppRadius.full,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.apps_rounded,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'All',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final category = categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: CategoryChip(
                      category: category,
                      isSelected: _selectedCategory == category,
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        ref.read(workflowsProvider.notifier).fetchWorkflows(
                              filter: WorkflowFilter(category: category),
                            );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Featured Workflows
  Widget _buildFeaturedWorkflows() {
    final featured = ref.watch(featuredWorkflowsProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(
                  '\u26A1 FEATURED',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 260,
              child: featured.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
                data: (workflows) {
                  if (workflows.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _featuredController,
                          itemCount: workflows.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: WorkflowCard(
                                workflow: workflows[index],
                                isLarge: true,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          workflows.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _featuredPage == index ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _featuredPage == index
                                  ? AppColors.primary
                                  : AppColors.border,
                              borderRadius: AppRadius.full,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. All Workflows Header
  Widget _buildAllWorkflowsHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Text('All Workflows', style: AppTypography.h4),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.tune_rounded),
              onPressed: () {
                FilterBottomSheet.show(
                  context: context,
                  currentFilter: _currentFilter,
                  onApply: (filter) {
                    setState(() => _currentFilter = filter);
                    ref
                        .read(workflowsProvider.notifier)
                        .fetchWorkflows(filter: filter);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 6. All Workflows Grid
  Widget _buildAllWorkflowsGrid() {
    final workflowsState = ref.watch(workflowsProvider);

    return workflowsState.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        sliver: SliverGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.62,
          children: List.generate(
            6,
            (_) => const WorkflowCardShimmer(),
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Something went wrong',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () =>
                    ref.read(workflowsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (workflows) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        sliver: SliverGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.62,
          children:
              workflows.map((w) => WorkflowCard(workflow: w)).toList(),
        ),
      ),
    );
  }

  // 7. Load More
  Widget _buildLoadMore() {
    final workflowsState = ref.watch(workflowsProvider);
    final hasMore = ref.read(workflowsProvider.notifier).hasMore;

    if (workflowsState is AsyncData && hasMore) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox(height: 16));
  }
}
