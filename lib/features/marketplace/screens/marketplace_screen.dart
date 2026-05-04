import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/workflow/workflow_model.dart';
import '../../../providers/workflow_provider.dart';
import '../../../shared/widgets/glass_widgets.dart';
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
    _featuredController = PageController(viewportFraction: 0.92);
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
    if (page != _featuredPage) setState(() => _featuredPage = page);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final notifier = ref.read(workflowsProvider.notifier);
      if (notifier.hasMore) notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu,
                          color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 12),
                        GradientText(
                          'FlowMarket',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                          ),
                          onPressed: () => context.push('/search'),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                          ),
                          onPressed: () =>
                              context.push('/profile/notifications'),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSearchBar(),
                  _buildFeaturedWorkflows(),
                  _buildCategories(),
                  _buildAIAssistantBanner(),
                  _buildAllWorkflowsHeader(),
                  _buildAllWorkflowsList(),
                  _buildLoadMore(),
                  _buildCustomWorkflowCard(),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: GestureDetector(
          onTap: () => context.push('/search'),
          child: GlassCard(
            borderRadius: BorderRadius.circular(999),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            opacity: 0.05,
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                const SizedBox(width: 10),
                Text(
                  'Describe your problem or search workflows...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedWorkflows() {
    final featured = ref.watch(featuredWorkflowsProvider);

    return SliverToBoxAdapter(
      child: featured.when(
        loading: () => const SizedBox(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFCEBDFF),
              strokeWidth: 2,
            ),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (workflows) {
          if (workflows.isEmpty) return const SizedBox.shrink();
          return Column(
            children: [
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _featuredController,
                  itemCount: workflows.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: WorkflowCard(
                      workflow: workflows[index],
                      isLarge: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                          ? const Color(0xFFCEBDFF)
                          : const Color(0xFFCEBDFF).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    final categories = WorkflowCategory.values;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                'Explore Categories',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
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
                    final isSelected = _selectedCategory == null;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = null);
                          ref.read(workflowsProvider.notifier).fetchWorkflows(
                                filter: WorkflowFilter(category: null),
                              );
                        },
                        child: _CategoryPill(
                          label: 'All',
                          icon: Icons.apps_rounded,
                          isSelected: isSelected,
                          color: const Color(0xFF4DDCC6),
                        ),
                      ),
                    );
                  }
                  final category = categories[index - 1];
                  final color = CategoryChip.colorFor(category);
                  final label = CategoryChip.labelFor(category);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        ref.read(workflowsProvider.notifier).fetchWorkflows(
                              filter: WorkflowFilter(category: category),
                            );
                      },
                      child: _CategoryPill(
                        label: label,
                        isSelected: _selectedCategory == category,
                        color: color,
                      ),
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

  Widget _buildAIAssistantBanner() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: GestureDetector(
          onTap: () => context.go('/ai-chat'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3C1989), Color(0xFF6A0045)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Not sure what you need?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Let AI find your workflow',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Ask AI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

  Widget _buildAllWorkflowsHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            const Text(
              'All Workflows',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.tune_rounded,
                color: const Color(0xFFCEBDFF).withValues(alpha: 0.7),
              ),
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

  Widget _buildAllWorkflowsList() {
    final workflowsState = ref.watch(workflowsProvider);

    return workflowsState.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const WorkflowCardShimmer(),
            ),
            childCount: 4,
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: const Color(0xFFCAC4D4).withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    ref.read(workflowsProvider.notifier).refresh(),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCEBDFF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (workflows) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WorkflowCard(workflow: workflows[index]),
            ),
            childCount: workflows.length,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMore() {
    final workflowsState = ref.watch(workflowsProvider);
    final hasMore = ref.read(workflowsProvider.notifier).hasMore;

    if (workflowsState is AsyncData && hasMore) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFCEBDFF),
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox(height: 8));
  }

  Widget _buildCustomWorkflowCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1D2022), Color(0xFF272A2C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFCEBDFF).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCEBDFF).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.build_rounded,
                      color: Color(0xFFCEBDFF),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Custom Workflow',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '\$500+',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFCEBDFF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Need something specific? We'll build it for you.",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  const phone = '+92125713042';
                  const message = 'Hi, I need a custom workflow built';
                  final uri = Uri.parse(
                    'https://wa.me/${phone.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_rounded,
                          size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Contact Us',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

class _CategoryPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final Color color;

  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? color.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected
              ? color.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isSelected ? color : Colors.white54),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? color : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
