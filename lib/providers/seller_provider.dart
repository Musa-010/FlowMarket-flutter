import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/workflow/workflow_model.dart';
import '../repositories/seller_repository.dart';

final sellerWorkflowsProvider = FutureProvider<List<Workflow>>((ref) async {
  return ref.watch(sellerRepositoryProvider).getSellerWorkflows();
});

final sellerEarningsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  return ref.watch(sellerRepositoryProvider).getEarnings();
});
