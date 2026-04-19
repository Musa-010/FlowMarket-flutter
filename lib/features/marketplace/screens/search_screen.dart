import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/storage/hive_storage.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../repositories/workflow_repository.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../widgets/category_chip.dart';
import '../widgets/workflow_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _recentSearches = [];
  List<Workflow> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await ref.read(hiveStorageProvider).getRecentSearches();
    if (mounted) {
      setState(() {
        _recentSearches = searches;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _hasSearched = false;
        _results = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ref.read(workflowRepositoryProvider).getWorkflows(
            filter: WorkflowFilter(search: query),
          );
      if (mounted) {
        setState(() {
          _results = response.data;
          _hasSearched = true;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasSearched = true;
        });
      }
    }

    await ref.read(hiveStorageProvider).addRecentSearch(query.trim());
    _loadRecentSearches();
  }

  void _onSubmitted(String query) {
    _debounce?.cancel();
    _performSearch(query);
  }

  void _setSearchAndPerform(String text) {
    _searchController.text = text;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
    _debounce?.cancel();
    _performSearch(text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _onSearchChanged,
              onSubmitted: _onSubmitted,
              decoration: InputDecoration(
                hintText: 'Search workflows...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.full,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.full,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.full,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
              ),
              style: AppTypography.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasSearched) {
      return _buildResults();
    }

    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                'Recent Searches',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final term = _recentSearches[index];
                return ListTile(
                  leading: const Icon(
                    Icons.access_time,
                    color: AppColors.textTertiary,
                  ),
                  title: Text(term, style: AppTypography.bodyMedium),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () async {
                      await ref
                          .read(hiveStorageProvider)
                          .removeRecentSearch(term);
                      setState(() {
                        _recentSearches.remove(term);
                      });
                    },
                  ),
                  onTap: () => _setSearchAndPerform(term),
                );
              },
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              'Popular Categories',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 3,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: WorkflowCategory.values.map((category) {
              return CategoryChip(
                category: category,
                isSelected: false,
                onTap: () {
                  final label = CategoryChip.labelFor(category);
                  _setSearchAndPerform(label);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No workflows found',
        subtitle: 'Try different keywords',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_results.length} results for \'${_searchController.text}\'',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return WorkflowCard(workflow: _results[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: AppSpacing.md);
              },
            ),
          ),
        ],
      ),
    );
  }
}
