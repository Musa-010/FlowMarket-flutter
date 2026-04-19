// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deployment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeploymentImpl _$$DeploymentImplFromJson(Map<String, dynamic> json) =>
    _$DeploymentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workflowId: json['workflowId'] as String,
      status: $enumDecode(_$DeploymentStatusEnumMap, json['status']),
      n8nWorkflowId: json['n8nWorkflowId'] as String?,
      config: json['config'] as Map<String, dynamic>? ?? const {},
      totalExecutions: (json['totalExecutions'] as num?)?.toInt() ?? 0,
      lastRunAt: json['lastRunAt'] == null
          ? null
          : DateTime.parse(json['lastRunAt'] as String),
      workflow: json['workflow'] == null
          ? null
          : Workflow.fromJson(json['workflow'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DeploymentImplToJson(_$DeploymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'workflowId': instance.workflowId,
      'status': _$DeploymentStatusEnumMap[instance.status]!,
      'n8nWorkflowId': instance.n8nWorkflowId,
      'config': instance.config,
      'totalExecutions': instance.totalExecutions,
      'lastRunAt': instance.lastRunAt?.toIso8601String(),
      'workflow': instance.workflow,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$DeploymentStatusEnumMap = {
  DeploymentStatus.configuring: 'CONFIGURING',
  DeploymentStatus.active: 'ACTIVE',
  DeploymentStatus.paused: 'PAUSED',
  DeploymentStatus.failed: 'FAILED',
  DeploymentStatus.stopped: 'STOPPED',
};

_$ExecutionLogImpl _$$ExecutionLogImplFromJson(Map<String, dynamic> json) =>
    _$ExecutionLogImpl(
      id: json['id'] as String,
      deploymentId: json['deploymentId'] as String,
      success: json['success'] as bool,
      durationMs: (json['durationMs'] as num).toInt(),
      errorMessage: json['errorMessage'] as String?,
      executedAt: json['executedAt'] == null
          ? null
          : DateTime.parse(json['executedAt'] as String),
    );

Map<String, dynamic> _$$ExecutionLogImplToJson(_$ExecutionLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deploymentId': instance.deploymentId,
      'success': instance.success,
      'durationMs': instance.durationMs,
      'errorMessage': instance.errorMessage,
      'executedAt': instance.executedAt?.toIso8601String(),
    };
