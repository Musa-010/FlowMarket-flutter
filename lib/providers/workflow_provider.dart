import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workflow/workflow_model.dart';
import '../repositories/workflow_repository.dart';

final workflowsProvider =
    StateNotifierProvider<WorkflowsNotifier, AsyncValue<List<Workflow>>>((ref) {
  return WorkflowsNotifier(ref);
});

final featuredWorkflowsProvider =
    FutureProvider<List<Workflow>>((ref) async {
  return ref.read(workflowRepositoryProvider).getFeaturedWorkflows();
});

final workflowDetailProvider =
    FutureProvider.family<Workflow, String>((ref, slug) async {
  return ref.read(workflowRepositoryProvider).getBySlug(slug);
});

class WorkflowsNotifier extends StateNotifier<AsyncValue<List<Workflow>>> {
  final Ref _ref;
  int _page = 1;
  bool _hasMore = true;
  WorkflowFilter? _filter;

  WorkflowsNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchWorkflows();
  }

  Future<void> fetchWorkflows({WorkflowFilter? filter}) async {
    if (filter != null) {
      _filter = filter;
      _page = 1;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final response = await _ref.read(workflowRepositoryProvider).getWorkflows(
            page: _page,
            filter: _filter,
          );

      _hasMore = response.hasMore;

      if (_page == 1) {
        state = AsyncValue.data(response.data);
      } else {
        final current = state.value ?? [];
        state = AsyncValue.data([...current, ...response.data]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page++;
    await fetchWorkflows();
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    await fetchWorkflows();
  }

  bool get hasMore => _hasMore;
}
