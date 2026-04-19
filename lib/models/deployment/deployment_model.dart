import 'package:freezed_annotation/freezed_annotation.dart';
import '../workflow/workflow_model.dart';

part 'deployment_model.freezed.dart';
part 'deployment_model.g.dart';

enum DeploymentStatus {
  @JsonValue('CONFIGURING')
  configuring,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('PAUSED')
  paused,
  @JsonValue('FAILED')
  failed,
  @JsonValue('STOPPED')
  stopped,
}

@freezed
class Deployment with _$Deployment {
  const factory Deployment({
    required String id,
    required String userId,
    required String workflowId,
    required DeploymentStatus status,
    String? n8nWorkflowId,
    @Default({}) Map<String, dynamic> config,
    @Default(0) int totalExecutions,
    DateTime? lastRunAt,
    Workflow? workflow,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Deployment;

  factory Deployment.fromJson(Map<String, dynamic> json) =>
      _$DeploymentFromJson(json);
}

@freezed
class ExecutionLog with _$ExecutionLog {
  const factory ExecutionLog({
    required String id,
    required String deploymentId,
    required bool success,
    required int durationMs,
    String? errorMessage,
    DateTime? executedAt,
  }) = _ExecutionLog;

  factory ExecutionLog.fromJson(Map<String, dynamic> json) =>
      _$ExecutionLogFromJson(json);
}
