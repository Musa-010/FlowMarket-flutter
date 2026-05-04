import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/workflow/workflow_model.dart';
import '../../../repositories/workflow_repository.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/glass_widgets.dart';
import '../widgets/category_chip.dart';
import '../widgets/workflow_card.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  WorkflowCategory? _selected;
  List<Workflow> _workflows = [];
  bool _isLoading = false;
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchCategory(null);
  }

  Future<void> _fetchCategory(WorkflowCategory? category) async {
    setState(() {
      _selected = category;
      _isLoading = true;
    });
    try {
      final response = await ref.read(workflowRepositoryProvider).getWorkflows(
            filter: WorkflowFilter(category: category),
            limit: 20,
          );
      if (mounted) {
        setState(() {
          _workflows = response.data;
          _isLoading = false;
          _hasFetched = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
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
                    padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
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
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color(0xFFCEBDFF)),
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
                        const Expanded(
                          child: Text(
                            'Explore Ecosystems',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/search'),
                          child: GlassCard(
                            borderRadius: BorderRadius.circular(999),
                            padding: const EdgeInsets.all(10),
                            opacity: 0.06,
                            child: Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Body
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Bento category grid
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BROWSE BY CATEGORY',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _CategoryBento(
                            selected: _selected,
                            onSelect: _fetchCategory,
                          ),
                          const SizedBox(height: 20),

                          // Trending tags
                          Text(
                            'TRENDING TAGS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _trendingTags.map((tag) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                        '/search?q=${Uri.encodeComponent(tag)}'),
                                    child: GlassCard(
                                      borderRadius: BorderRadius.circular(999),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 7),
                                      opacity: 0.05,
                                      child: Text(
                                        '# $tag',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Colors.white.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Results header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selected == null
                                    ? 'ALL WORKFLOWS'
                                    : 'TOP IN ${CategoryChip.labelFor(_selected!).toUpperCase()}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: Color(0xFFCEBDFF),
                                ),
                              ),
                              if (_hasFetched)
                                Text(
                                  '${_workflows.length} workflows',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // Workflow list
                  if (_isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFCEBDFF),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  else if (_hasFetched && _workflows.isEmpty)
                    SliverToBoxAdapter(
                      child: EmptyStateWidget(
                        icon: Icons.category_outlined,
                        title: 'No workflows here yet',
                        subtitle: 'Check back soon or explore another category',
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WorkflowCard(workflow: _workflows[index]),
                          ),
                          childCount: _workflows.length,
                        ),
                      ),
                    ),

                  // Custom workflow builder card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: _CustomBuilderCard(),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _trendingTags = [
    'automation',
    'no-code',
    'AI agents',
    'Slack',
    'HubSpot',
    'GPT-4',
    'Stripe',
    'Notion',
    'Zapier',
    'webhook',
  ];
}

class _CategoryBento extends StatelessWidget {
  final WorkflowCategory? selected;
  final ValueChanged<WorkflowCategory?> onSelect;

  const _CategoryBento({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final categories = WorkflowCategory.values;

    return Column(
      children: [
        // "All" pill + first row
        Row(
          children: [
            _BentoTile(
              label: 'All',
              icon: Icons.apps_rounded,
              color: const Color(0xFF8B5CF6),
              isSelected: selected == null,
              onTap: () => onSelect(null),
              flex: 1,
            ),
            const SizedBox(width: 10),
            _BentoTile(
              label: CategoryChip.labelFor(categories[0]),
              icon: CategoryChip.iconFor(categories[0]),
              color: CategoryChip.colorFor(categories[0]),
              isSelected: selected == categories[0],
              onTap: () => onSelect(categories[0]),
              flex: 2,
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Remaining rows of 2
        ...List.generate((categories.length - 1) ~/ 2, (rowIndex) {
          final i1 = 1 + rowIndex * 2;
          final i2 = i1 + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                _BentoTile(
                  label: CategoryChip.labelFor(categories[i1]),
                  icon: CategoryChip.iconFor(categories[i1]),
                  color: CategoryChip.colorFor(categories[i1]),
                  isSelected: selected == categories[i1],
                  onTap: () => onSelect(categories[i1]),
                  flex: 1,
                ),
                const SizedBox(width: 10),
                if (i2 < categories.length)
                  _BentoTile(
                    label: CategoryChip.labelFor(categories[i2]),
                    icon: CategoryChip.iconFor(categories[i2]),
                    color: CategoryChip.colorFor(categories[i2]),
                    isSelected: selected == categories[i2],
                    onTap: () => onSelect(categories[i2]),
                    flex: 1,
                  )
                else
                  const Spacer(),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final int flex;

  const _BentoTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? color.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isSelected ? 0.25 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? color : Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomBuilderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3C1989).withValues(alpha: 0.5),
                const Color(0xFF6A0045).withValues(alpha: 0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Build Custom Workflow',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Describe what you need and our AI will build it for you.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => context.push('/ai-chat'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome,
                                size: 14, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Ask AI to Build',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
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
              const SizedBox(width: 16),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: Color(0xFFCEBDFF),
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
