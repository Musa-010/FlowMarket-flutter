import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/formatters.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../providers/workflow_provider.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/avatar_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';
import '../widgets/category_chip.dart';
import '../widgets/star_rating_widget.dart';

class WorkflowDetailScreen extends ConsumerStatefulWidget {
  const WorkflowDetailScreen({super.key, required this.slug});
  final String slug;

  @override
  ConsumerState<WorkflowDetailScreen> createState() =>
      _WorkflowDetailScreenState();
}

class _WorkflowDetailScreenState
    extends ConsumerState<WorkflowDetailScreen> {
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
    final asyncWorkflow =
        ref.watch(workflowDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: asyncWorkflow.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFCEBDFF),
            strokeWidth: 2,
          ),
        ),
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
    final categoryColor = CategoryChip.colorFor(workflow.category);
    final categoryLabel = CategoryChip.labelFor(workflow.category);

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Image carousel sliver
              SliverToBoxAdapter(
                child: _buildImageCarousel(workflow, categoryColor,
                    categoryLabel),
              ),

              // Info section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        workflow.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Description
                      Text(
                        workflow.shortDescription,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: const Color(0xFFCAC4D4)
                              .withValues(alpha: 0.7),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRICE',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            price > 0
                                ? '\$${price.toStringAsFixed(2)}'
                                : 'Free',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4DDCC6),
                              letterSpacing: -0.3,
                            ),
                          ),
                          if (isMonthly)
                            Text(
                              '/month',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Deploy Now button
                      GestureDetector(
                        onTap: () =>
                            context.push('/checkout/${workflow.slug}'),
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFCEBDFF),
                                Color(0xFFA78BFA)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFCEBDFF)
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.rocket_launch_outlined,
                                  size: 18, color: Color(0xFF21005E)),
                              const SizedBox(width: 8),
                              Text(
                                price > 0
                                    ? 'Deploy Now — \$${price.toStringAsFixed(0)}'
                                    : 'Deploy Now — Free',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF21005E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Wishlist + Share row
                      Row(
                        children: [
                          Expanded(
                            child: _GlassActionBtn(
                              icon: Icons.favorite_border,
                              label: 'Wishlist',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          _GlassActionBtn(
                            icon: Icons.share_outlined,
                            label: '',
                            onTap: () => Share.share(
                                'Check out ${workflow.title} on FlowMarket'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Key Features
              if (workflow.steps.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: _KeyFeaturesCard(steps: workflow.steps),
                  ),
                ),

              // Publisher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _PublisherCard(workflow: workflow),
                ),
              ),

              // Tab bar
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Reviews',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: const Text(
                          'VIEW ALL',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Color(0xFFCEBDFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Reviews placeholder
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: workflow.reviewCount == 0
                      ? Text(
                          'No reviews yet.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        )
                      : _ReviewsPreview(
                          count: workflow.reviewCount,
                          rating: workflow.avgRating,
                        ),
                ),
              ),

              // Stats row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      _StatCell(
                        value: Formatters.compactNumber(
                            workflow.purchaseCount),
                        label: 'purchased',
                      ),
                      const SizedBox(width: 10),
                      _StatCell(
                        value: Formatters.compactNumber(
                            workflow.reviewCount),
                        label: 'reviews',
                      ),
                      const SizedBox(width: 10),
                      _StatCell(
                        value: '~${workflow.setupTime ?? '5 min'}',
                        label: 'setup',
                      ),
                    ],
                  ),
                ),
              ),

              // Full description
              if (workflow.fullDescription != null &&
                  workflow.fullDescription!.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: MarkdownBody(data: workflow.fullDescription!),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),

        // Stripe secure footer
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline,
                    size: 11,
                    color: Colors.white.withValues(alpha: 0.3)),
                const SizedBox(width: 4),
                Text(
                  'Secure payment by Stripe',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(
      Workflow workflow, Color categoryColor, String categoryLabel) {
    return Stack(
      children: [
        // Image
        SizedBox(
          height: 300,
          width: double.infinity,
          child: workflow.previewImages.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF3C1989).withValues(alpha: 0.6),
                        const Color(0xFF1D2022),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome_mosaic_outlined,
                        size: 64, color: Color(0xFFA78BFA)),
                  ),
                )
              : PageView.builder(
                  controller: _imagePageController,
                  itemCount: workflow.previewImages.length,
                  onPageChanged: (i) =>
                      setState(() => _currentImagePage = i),
                  itemBuilder: (context, index) => CachedNetworkImage(
                    imageUrl: workflow.previewImages[index],
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: const Color(0xFF1D2022),
                      child: const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFCEBDFF), strokeWidth: 2)),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: const Color(0xFF1D2022),
                      child: const Center(
                          child: Icon(Icons.broken_image_outlined,
                              size: 48, color: Color(0xFFA78BFA))),
                    ),
                  ),
                ),
        ),

        // Gradient overlay bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF101415),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Back + share buttons overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      _OverlayIconBtn(
                        icon: Icons.arrow_back,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      _OverlayIconBtn(
                        icon: Icons.share_outlined,
                        onTap: () => Share.share(
                            'Check out ${workflow.title} on FlowMarket'),
                      ),
                      const SizedBox(width: 8),
                      _OverlayIconBtn(
                        icon: Icons.bookmark_border_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Category + rating badges at bottom of image
        Positioned(
          bottom: 16,
          left: 20,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: categoryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  categoryLabel.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: categoryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4DDCC6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF4DDCC6).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 12, color: Color(0xFF4DDCC6)),
                    const SizedBox(width: 4),
                    Text(
                      workflow.avgRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4DDCC6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Dot indicators
        if (workflow.previewImages.length > 1)
          Positioned(
            bottom: 16,
            right: 20,
            child: Row(
              children: List.generate(
                workflow.previewImages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: _currentImagePage == index ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentImagePage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OverlayIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _OverlayIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _GlassActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GlassActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: const Color(0xFFCAC4D4)),
                if (label.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCAC4D4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyFeaturesCard extends StatelessWidget {
  final List<String> steps;

  static const _featureIcons = [
    Icons.bolt_outlined,
    Icons.lock_outline,
    Icons.sync_outlined,
    Icons.analytics_outlined,
    Icons.speed_outlined,
    Icons.cloud_done_outlined,
  ];

  const _KeyFeaturesCard({required this.steps});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 16, color: Color(0xFF4DDCC6)),
                  const SizedBox(width: 8),
                  const Text(
                    'Key Features',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...List.generate(
                steps.length.clamp(0, 6),
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FeatureRow(
                    icon: _featureIcons[index % _featureIcons.length],
                    text: steps[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4DDCC6)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PublisherCard extends StatelessWidget {
  final Workflow workflow;

  const _PublisherCard({required this.workflow});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PUBLISHER',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: AvatarWidget(
                      name: workflow.sellerName ?? 'Seller',
                      imageUrl: workflow.sellerAvatarUrl,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workflow.sellerName ?? 'Seller',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Top Verified Publisher',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: const Color(0xFF4DDCC6)
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'View Profile',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCAC4D4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewsPreview extends StatelessWidget {
  final int count;
  final double rating;

  const _ReviewsPreview({required this.count, required this.rating});

  @override
  Widget build(BuildContext context) {
    final fakeReviews = [
      ('Alex Chen', '2d ago',
          '"This workflow transformed our backend efficiency. The setup was incredibly smooth and the glassmorphic dashboard is a joy to use."'),
      ('Sarah Miller', '1w ago',
          '"Impressive speed. The neural sync logic actually handles complex edge cases without manual intervention. Worth every penny."'),
    ];

    return Column(
      children: fakeReviews
          .take(count.clamp(0, 2))
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8B5CF6),
                                    Color(0xFF4DDCC6)
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  r.$1[0],
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                r.$1,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              r.$2,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: i < rating.round()
                                  ? const Color(0xFF4DDCC6)
                                  : Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          r.$3,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color:
                                const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;

  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
