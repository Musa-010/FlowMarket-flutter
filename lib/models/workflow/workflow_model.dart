import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_model.freezed.dart';
part 'workflow_model.g.dart';

enum WorkflowPlatform {
  @JsonValue('N8N')
  n8n,
  @JsonValue('MAKE')
  make,
  @JsonValue('BOTH')
  both,
}

enum WorkflowCategory {
  @JsonValue('EMAIL')
  email,
  @JsonValue('LEAD_GEN')
  leadGen,
  @JsonValue('CRM')
  crm,
  @JsonValue('SOCIAL')
  social,
  @JsonValue('INVOICE')
  invoice,
  @JsonValue('ECOM')
  ecom,
  @JsonValue('REPORT')
  report,
  @JsonValue('NOTIF')
  notif,
  @JsonValue('CUSTOM')
  custom,
}

enum WorkflowDifficulty {
  @JsonValue('BEGINNER')
  beginner,
  @JsonValue('INTERMEDIATE')
  intermediate,
  @JsonValue('ADVANCED')
  advanced,
}

enum WorkflowStatus {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('PENDING_REVIEW')
  pendingReview,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}

@freezed
class Workflow with _$Workflow {
  const factory Workflow({
    required String id,
    required String title,
    required String slug,
    required String shortDescription,
    String? fullDescription,
    required WorkflowPlatform platform,
    required WorkflowCategory category,
    @Default(WorkflowDifficulty.beginner) WorkflowDifficulty difficulty,
    double? oneTimePrice,
    double? monthlyPrice,
    @Default([]) List<String> previewImages,
    @Default([]) List<String> requiredIntegrations,
    @Default([]) List<String> tags,
    @Default([]) List<String> steps,
    String? demoVideoUrl,
    String? workflowFileUrl,
    @Default(0) double avgRating,
    @Default(0) int reviewCount,
    @Default(0) int purchaseCount,
    String? setupTime,
    @Default(WorkflowStatus.approved) WorkflowStatus status,
    String? sellerId,
    String? sellerName,
    String? sellerAvatarUrl,
    @Default(false) bool isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Workflow;

  factory Workflow.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFromJson(json);
}

@freezed
class WorkflowFilter with _$WorkflowFilter {
  const factory WorkflowFilter({
    String? search,
    WorkflowCategory? category,
    WorkflowPlatform? platform,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
  }) = _WorkflowFilter;

  factory WorkflowFilter.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFilterFromJson(json);
}
