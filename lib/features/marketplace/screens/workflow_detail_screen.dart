import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../providers/workflow_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/price_tag.dart';
import '../widgets/category_chip.dart';
import '../widgets/integration_badge.dart';
import '../widgets/platform_badge.dart';
import '../widgets/star_rating_widget.dart';

class WorkflowDetailScreen extends ConsumerStatefulWidget {
  const WorkflowDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<WorkflowDetailScreen> createState() =>
      _WorkflowDetailScreenState();
}

class _WorkflowDetailScreenState extends ConsumerState<WorkflowDetailScreen> {
  int _selectedTab = 0;
  final PageController _imagePageController = PageController();
  int _currentImagePage = 0;

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncWorkflow = ref.watch(workflowDetailProvider(widget.slug));

    return Scaffold(
      body: asyncWorkflow.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(workflowDetailProvider(widget.slug)),
        ),
        data: (workflow) => _buildContent(context, workflow),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Workflow workflow) {
    final price = workflow.oneTimePrice ?? workflow.monthlyPrice ?? 0;
    final isMonthly =
        workflow.monthlyPrice != null && workflow.oneTimePrice == null;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, workflow),
              _buildInfoSection(context, workflow),
              _buildTabBar(context),
              if (_selectedTab == 0)
                _buildOverviewTab(context, workflow)
              else
                _buildReviewsTab(context, workflow),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
        _buildStickyBottomBar(context, workflow, price, isMonthly),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SliverAppBar with image PageView
  // ---------------------------------------------------------------------------
  SliverAppBar _buildSliverAppBar(BuildContext context, Workflow workflow) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      title: Text(
        workflow.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {
            Share.share('Check out ${workflow.title} on FlowMarket');
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          onPressed: () {
            // TODO: bookmark
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildImageCarousel(workflow),
      ),
    );
  }

  Widget _buildImageCarousel(Workflow workflow) {
    if (workflow.previewImages.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _imagePageController,
          itemCount: workflow.previewImages.length,
          onPageChanged: (index) {
            setState(() => _currentImagePage = index);
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: workflow.previewImages[index],
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: Icon(Icons.broken_image_outlined,
                      size: 48, color: AppColors.textTertiary),
                ),
              ),
            );
          },
        ),
        if (workflow.previewImages.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                workflow.previewImages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _currentImagePage == index ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: _currentImagePage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: AppRadius.full,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Info Section
  // ---------------------------------------------------------------------------
  SliverToBoxAdapter _buildInfoSection(
      BuildContext context, Workflow workflow) {
    final categoryColor = CategoryChip.colorFor(workflow.category);
    final categoryLabel = CategoryChip.labelFor(workflow.category);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Platform + category
            Row(
              children: [
                PlatformBadge(platform: workflow.platform),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    borderRadius: AppRadius.full,
                  ),
                  child: Text(
                    categoryLabel,
                    style: AppTypography.labelSmall
                        .copyWith(color: categoryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(workflow.title, style: AppTypography.h2),
            const SizedBox(height: AppSpacing.sm),

            // Rating + reviews link
            Row(
              children: [
                StarRatingWidget(
                  rating: workflow.avgRating,
                  reviewCount: workflow.reviewCount,
                ),
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: Text(
                    '(${workflow.reviewCount} reviews)',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Required integrations
            if (workflow.requiredIntegrations.isNotEmpty) ...[
              Text(
                'Required Integrations',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: workflow.requiredIntegrations
                    .map((name) => IntegrationBadge(name: name))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Seller info
            Row(
              children: [
                AvatarWidget(
                  name: workflow.sellerName ?? 'Seller',
                  imageUrl: workflow.sellerAvatarUrl,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflow.sellerName ?? 'Seller',
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      '${workflow.purchaseCount} workflows sold',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Tags
            if (workflow.tags.isNotEmpty)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: workflow.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          tag,
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab Bar
  // ---------------------------------------------------------------------------
  SliverToBoxAdapter _buildTabBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            _buildTabItem('Overview', 0),
            _buildTabItem('Reviews', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Overview Tab
  // ---------------------------------------------------------------------------
  SliverToBoxAdapter _buildOverviewTab(
      BuildContext context, Workflow workflow) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            if (workflow.fullDescription != null &&
                workflow.fullDescription!.isNotEmpty)
              MarkdownBody(data: workflow.fullDescription!)
            else
              Text(workflow.shortDescription, style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.xxl),

            // Steps
            if (workflow.steps.isNotEmpty) ...[
              Text('What This Workflow Does', style: AppTypography.h4),
              const SizedBox(height: AppSpacing.sm),
              ...List.generate(workflow.steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          '${index + 1}',
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            workflow.steps[index],
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // Stats row
            Row(
              children: [
                _buildStatCard(
                  Formatters.compactNumber(workflow.purchaseCount),
                  'purchased',
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatCard(
                  Formatters.compactNumber(workflow.reviewCount),
                  'reviews',
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatCard(
                  '~${workflow.setupTime ?? '5 min'}',
                  'setup',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.sm,
        ),
        child: Column(
          children: [
            Text(value, style: AppTypography.h3),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reviews Tab
  // ---------------------------------------------------------------------------
  SliverToBoxAdapter _buildReviewsTab(
      BuildContext context, Workflow workflow) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reviews', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.md),
            if (workflow.reviewCount == 0)
              Text(
                'No reviews yet',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              )
            else
              Text(
                '${workflow.reviewCount} reviews available',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Write a Review',
              variant: AppButtonVariant.outlined,
              onPressed: () {
                // TODO: navigate to write review
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sticky Bottom Bar
  // ---------------------------------------------------------------------------
  Widget _buildStickyBottomBar(
    BuildContext context,
    Workflow workflow,
    double price,
    bool isMonthly,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceTag(
                      price: price,
                      isMonthly: isMonthly,
                    ),
                    if (price > 0)
                      Text(
                        isMonthly ? '/month' : 'one-time',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: AppButton(
                    label: 'Buy Now — \$${price.toStringAsFixed(0)}',
                    onPressed: () {
                      context.push('/checkout/${workflow.slug}');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 12,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Secure payment by Stripe',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}
