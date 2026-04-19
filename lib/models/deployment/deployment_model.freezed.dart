// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deployment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Deployment _$DeploymentFromJson(Map<String, dynamic> json) {
  return _Deployment.fromJson(json);
}

/// @nodoc
mixin _$Deployment {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get workflowId => throw _privateConstructorUsedError;
  DeploymentStatus get status => throw _privateConstructorUsedError;
  String? get n8nWorkflowId => throw _privateConstructorUsedError;
  Map<String, dynamic> get config => throw _privateConstructorUsedError;
  int get totalExecutions => throw _privateConstructorUsedError;
  DateTime? get lastRunAt => throw _privateConstructorUsedError;
  Workflow? get workflow => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Deployment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Deployment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeploymentCopyWith<Deployment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeploymentCopyWith<$Res> {
  factory $DeploymentCopyWith(
    Deployment value,
    $Res Function(Deployment) then,
  ) = _$DeploymentCopyWithImpl<$Res, Deployment>;
  @useResult
  $Res call({
    String id,
    String userId,
    String workflowId,
    DeploymentStatus status,
    String? n8nWorkflowId,
    Map<String, dynamic> config,
    int totalExecutions,
    DateTime? lastRunAt,
    Workflow? workflow,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  $WorkflowCopyWith<$Res>? get workflow;
}

/// @nodoc
class _$DeploymentCopyWithImpl<$Res, $Val extends Deployment>
    implements $DeploymentCopyWith<$Res> {
  _$DeploymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Deployment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workflowId = null,
    Object? status = null,
    Object? n8nWorkflowId = freezed,
    Object? config = null,
    Object? totalExecutions = null,
    Object? lastRunAt = freezed,
    Object? workflow = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            workflowId: null == workflowId
                ? _value.workflowId
                : workflowId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DeploymentStatus,
            n8nWorkflowId: freezed == n8nWorkflowId
                ? _value.n8nWorkflowId
                : n8nWorkflowId // ignore: cast_nullable_to_non_nullable
                      as String?,
            config: null == config
                ? _value.config
                : config // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            totalExecutions: null == totalExecutions
                ? _value.totalExecutions
                : totalExecutions // ignore: cast_nullable_to_non_nullable
                      as int,
            lastRunAt: freezed == lastRunAt
                ? _value.lastRunAt
                : lastRunAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            workflow: freezed == workflow
                ? _value.workflow
                : workflow // ignore: cast_nullable_to_non_nullable
                      as Workflow?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of Deployment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowCopyWith<$Res>? get workflow {
    if (_value.workflow == null) {
      return null;
    }

    return $WorkflowCopyWith<$Res>(_value.workflow!, (value) {
      return _then(_value.copyWith(workflow: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeploymentImplCopyWith<$Res>
    implements $DeploymentCopyWith<$Res> {
  factory _$$DeploymentImplCopyWith(
    _$DeploymentImpl value,
    $Res Function(_$DeploymentImpl) then,
  ) = __$$DeploymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String workflowId,
    DeploymentStatus status,
    String? n8nWorkflowId,
    Map<String, dynamic> config,
    int totalExecutions,
    DateTime? lastRunAt,
    Workflow? workflow,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  $WorkflowCopyWith<$Res>? get workflow;
}

/// @nodoc
class __$$DeploymentImplCopyWithImpl<$Res>
    extends _$DeploymentCopyWithImpl<$Res, _$DeploymentImpl>
    implements _$$DeploymentImplCopyWith<$Res> {
  __$$DeploymentImplCopyWithImpl(
    _$DeploymentImpl _value,
    $Res Function(_$DeploymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Deployment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workflowId = null,
    Object? status = null,
    Object? n8nWorkflowId = freezed,
    Object? config = null,
    Object? totalExecutions = null,
    Object? lastRunAt = freezed,
    Object? workflow = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DeploymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        workflowId: null == workflowId
            ? _value.workflowId
            : workflowId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DeploymentStatus,
        n8nWorkflowId: freezed == n8nWorkflowId
            ? _value.n8nWorkflowId
            : n8nWorkflowId // ignore: cast_nullable_to_non_nullable
                  as String?,
        config: null == config
            ? _value._config
            : config // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        totalExecutions: null == totalExecutions
            ? _value.totalExecutions
            : totalExecutions // ignore: cast_nullable_to_non_nullable
                  as int,
        lastRunAt: freezed == lastRunAt
            ? _value.lastRunAt
            : lastRunAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        workflow: freezed == workflow
            ? _value.workflow
            : workflow // ignore: cast_nullable_to_non_nullable
                  as Workflow?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeploymentImpl implements _Deployment {
  const _$DeploymentImpl({
    required this.id,
    required this.userId,
    required this.workflowId,
    required this.status,
    this.n8nWorkflowId,
    final Map<String, dynamic> config = const {},
    this.totalExecutions = 0,
    this.lastRunAt,
    this.workflow,
    this.createdAt,
    this.updatedAt,
  }) : _config = config;

  factory _$DeploymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeploymentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String workflowId;
  @override
  final DeploymentStatus status;
  @override
  final String? n8nWorkflowId;
  final Map<String, dynamic> _config;
  @override
  @JsonKey()
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  @override
  @JsonKey()
  final int totalExecutions;
  @override
  final DateTime? lastRunAt;
  @override
  final Workflow? workflow;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Deployment(id: $id, userId: $userId, workflowId: $workflowId, status: $status, n8nWorkflowId: $n8nWorkflowId, config: $config, totalExecutions: $totalExecutions, lastRunAt: $lastRunAt, workflow: $workflow, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeploymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.n8nWorkflowId, n8nWorkflowId) ||
                other.n8nWorkflowId == n8nWorkflowId) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            (identical(other.totalExecutions, totalExecutions) ||
                other.totalExecutions == totalExecutions) &&
            (identical(other.lastRunAt, lastRunAt) ||
                other.lastRunAt == lastRunAt) &&
            (identical(other.workflow, workflow) ||
                other.workflow == workflow) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    workflowId,
    status,
    n8nWorkflowId,
    const DeepCollectionEquality().hash(_config),
    totalExecutions,
    lastRunAt,
    workflow,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Deployment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeploymentImplCopyWith<_$DeploymentImpl> get copyWith =>
      __$$DeploymentImplCopyWithImpl<_$DeploymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeploymentImplToJson(this);
  }
}

abstract class _Deployment implements Deployment {
  const factory _Deployment({
    required final String id,
    required final String userId,
    required final String workflowId,
    required final DeploymentStatus status,
    final String? n8nWorkflowId,
    final Map<String, dynamic> config,
    final int totalExecutions,
    final DateTime? lastRunAt,
    final Workflow? workflow,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$DeploymentImpl;

  factory _Deployment.fromJson(Map<String, dynamic> json) =
      _$DeploymentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get workflowId;
  @override
  DeploymentStatus get status;
  @override
  String? get n8nWorkflowId;
  @override
  Map<String, dynamic> get config;
  @override
  int get totalExecutions;
  @override
  DateTime? get lastRunAt;
  @override
  Workflow? get workflow;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Deployment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeploymentImplCopyWith<_$DeploymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExecutionLog _$ExecutionLogFromJson(Map<String, dynamic> json) {
  return _ExecutionLog.fromJson(json);
}

/// @nodoc
mixin _$ExecutionLog {
  String get id => throw _privateConstructorUsedError;
  String get deploymentId => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime? get executedAt => throw _privateConstructorUsedError;

  /// Serializes this ExecutionLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExecutionLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExecutionLogCopyWith<ExecutionLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExecutionLogCopyWith<$Res> {
  factory $ExecutionLogCopyWith(
    ExecutionLog value,
    $Res Function(ExecutionLog) then,
  ) = _$ExecutionLogCopyWithImpl<$Res, ExecutionLog>;
  @useResult
  $Res call({
    String id,
    String deploymentId,
    bool success,
    int durationMs,
    String? errorMessage,
    DateTime? executedAt,
  });
}

/// @nodoc
class _$ExecutionLogCopyWithImpl<$Res, $Val extends ExecutionLog>
    implements $ExecutionLogCopyWith<$Res> {
  _$ExecutionLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExecutionLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deploymentId = null,
    Object? success = null,
    Object? durationMs = null,
    Object? errorMessage = freezed,
    Object? executedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            deploymentId: null == deploymentId
                ? _value.deploymentId
                : deploymentId // ignore: cast_nullable_to_non_nullable
                      as String,
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            durationMs: null == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            executedAt: freezed == executedAt
                ? _value.executedAt
                : executedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExecutionLogImplCopyWith<$Res>
    implements $ExecutionLogCopyWith<$Res> {
  factory _$$ExecutionLogImplCopyWith(
    _$ExecutionLogImpl value,
    $Res Function(_$ExecutionLogImpl) then,
  ) = __$$ExecutionLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String deploymentId,
    bool success,
    int durationMs,
    String? errorMessage,
    DateTime? executedAt,
  });
}

/// @nodoc
class __$$ExecutionLogImplCopyWithImpl<$Res>
    extends _$ExecutionLogCopyWithImpl<$Res, _$ExecutionLogImpl>
    implements _$$ExecutionLogImplCopyWith<$Res> {
  __$$ExecutionLogImplCopyWithImpl(
    _$ExecutionLogImpl _value,
    $Res Function(_$ExecutionLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExecutionLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deploymentId = null,
    Object? success = null,
    Object? durationMs = null,
    Object? errorMessage = freezed,
    Object? executedAt = freezed,
  }) {
    return _then(
      _$ExecutionLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        deploymentId: null == deploymentId
            ? _value.deploymentId
            : deploymentId // ignore: cast_nullable_to_non_nullable
                  as String,
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        durationMs: null == durationMs
            ? _value.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        executedAt: freezed == executedAt
            ? _value.executedAt
            : executedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExecutionLogImpl implements _ExecutionLog {
  const _$ExecutionLogImpl({
    required this.id,
    required this.deploymentId,
    required this.success,
    required this.durationMs,
    this.errorMessage,
    this.executedAt,
  });

  factory _$ExecutionLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExecutionLogImplFromJson(json);

  @override
  final String id;
  @override
  final String deploymentId;
  @override
  final bool success;
  @override
  final int durationMs;
  @override
  final String? errorMessage;
  @override
  final DateTime? executedAt;

  @override
  String toString() {
    return 'ExecutionLog(id: $id, deploymentId: $deploymentId, success: $success, durationMs: $durationMs, errorMessage: $errorMessage, executedAt: $executedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExecutionLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deploymentId, deploymentId) ||
                other.deploymentId == deploymentId) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    deploymentId,
    success,
    durationMs,
    errorMessage,
    executedAt,
  );

  /// Create a copy of ExecutionLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExecutionLogImplCopyWith<_$ExecutionLogImpl> get copyWith =>
      __$$ExecutionLogImplCopyWithImpl<_$ExecutionLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExecutionLogImplToJson(this);
  }
}

abstract class _ExecutionLog implements ExecutionLog {
  const factory _ExecutionLog({
    required final String id,
    required final String deploymentId,
    required final bool success,
    required final int durationMs,
    final String? errorMessage,
    final DateTime? executedAt,
  }) = _$ExecutionLogImpl;

  factory _ExecutionLog.fromJson(Map<String, dynamic> json) =
      _$ExecutionLogImpl.fromJson;

  @override
  String get id;
  @override
  String get deploymentId;
  @override
  bool get success;
  @override
  int get durationMs;
  @override
  String? get errorMessage;
  @override
  DateTime? get executedAt;

  /// Create a copy of ExecutionLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExecutionLogImplCopyWith<_$ExecutionLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
