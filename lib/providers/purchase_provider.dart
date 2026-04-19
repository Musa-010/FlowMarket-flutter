import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/purchase/purchase_model.dart';
import '../repositories/purchase_repository.dart';

final purchasesProvider =
    StateNotifierProvider<PurchasesNotifier, AsyncValue<List<Purchase>>>((ref) {
  return PurchasesNotifier(ref);
});

class PurchasesNotifier extends StateNotifier<AsyncValue<List<Purchase>>> {
  final Ref _ref;
  int _page = 1;
  bool _hasMore = true;

  PurchasesNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchPurchases();
  }

  Future<void> fetchPurchases() async {
    try {
      final response =
          await _ref.read(purchaseRepositoryProvider).getPurchases(page: _page);
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
    await fetchPurchases();
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    await fetchPurchases();
  }

  bool get hasMore => _hasMore;
}
