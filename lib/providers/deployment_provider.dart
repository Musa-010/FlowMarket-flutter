import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/deployment/deployment_model.dart';
import '../repositories/deployment_repository.dart';

final deploymentsProvider =
    StateNotifierProvider<DeploymentsNotifier, AsyncValue<List<Deployment>>>(
        (ref) {
  return DeploymentsNotifier(ref);
});

final deploymentDetailProvider =
    FutureProvider.family<Deployment, String>((ref, id) async {
  return ref.read(deploymentRepositoryProvider).getDeployment(id);
});

final deploymentLogsProvider =
    FutureProvider.family<List<ExecutionLog>, String>((ref, id) async {
  return ref.read(deploymentRepositoryProvider).getDeploymentLogs(id);
});

class DeploymentsNotifier extends StateNotifier<AsyncValue<List<Deployment>>> {
  final Ref _ref;

  DeploymentsNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchDeployments();
  }

  Future<void> fetchDeployments() async {
    state = const AsyncValue.loading();
    try {
      final deployments =
          await _ref.read(deploymentRepositoryProvider).getDeployments();
      state = AsyncValue.data(deployments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> pauseDeployment(String id) async {
    try {
      await _ref.read(deploymentRepositoryProvider).pauseDeployment(id);
      await fetchDeployments();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> resumeDeployment(String id) async {
    try {
      await _ref.read(deploymentRepositoryProvider).resumeDeployment(id);
      await fetchDeployments();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await fetchDeployments();
  }
}
