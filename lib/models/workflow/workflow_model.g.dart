// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowImpl _$$WorkflowImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      shortDescription: json['shortDescription'] as String,
      fullDescription: json['fullDescription'] as String?,
      platform: $enumDecode(_$WorkflowPlatformEnumMap, json['platform']),
      category: $enumDecode(_$WorkflowCategoryEnumMap, json['category']),
      difficulty: $enumDecodeNullable(
              _$WorkflowDifficultyEnumMap, json['difficulty']) ??
          WorkflowDifficulty.beginner,
      oneTimePrice: (json['oneTimePrice'] as num?)?.toDouble(),
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble(),
      previewImages: (json['previewImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requiredIntegrations: (json['requiredIntegrations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      demoVideoUrl: json['demoVideoUrl'] as String?,
      workflowFileUrl: json['workflowFileUrl'] as String?,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      purchaseCount: (json['purchaseCount'] as num?)?.toInt() ?? 0,
      setupTime: json['setupTime'] as String?,
      status: $enumDecodeNullable(_$WorkflowStatusEnumMap, json['status']) ??
          WorkflowStatus.approved,
      sellerId: json['sellerId'] as String?,
      sellerName: json['sellerName'] as String?,
      sellerAvatarUrl: json['sellerAvatarUrl'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkflowImplToJson(_$WorkflowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'shortDescription': instance.shortDescription,
      'fullDescription': instance.fullDescription,
      'platform': _$WorkflowPlatformEnumMap[instance.platform]!,
      'category': _$WorkflowCategoryEnumMap[instance.category]!,
      'difficulty': _$WorkflowDifficultyEnumMap[instance.difficulty]!,
      'oneTimePrice': instance.oneTimePrice,
      'monthlyPrice': instance.monthlyPrice,
      'previewImages': instance.previewImages,
      'requiredIntegrations': instance.requiredIntegrations,
      'tags': instance.tags,
      'steps': instance.steps,
      'demoVideoUrl': instance.demoVideoUrl,
      'workflowFileUrl': instance.workflowFileUrl,
      'avgRating': instance.avgRating,
      'reviewCount': instance.reviewCount,
      'purchaseCount': instance.purchaseCount,
      'setupTime': instance.setupTime,
      'status': _$WorkflowStatusEnumMap[instance.status]!,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'sellerAvatarUrl': instance.sellerAvatarUrl,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WorkflowPlatformEnumMap = {
  WorkflowPlatform.n8n: 'N8N',
  WorkflowPlatform.make: 'MAKE',
  WorkflowPlatform.both: 'BOTH',
};

const _$WorkflowCategoryEnumMap = {
  WorkflowCategory.email: 'EMAIL',
  WorkflowCategory.leadGen: 'LEAD_GEN',
  WorkflowCategory.crm: 'CRM',
  WorkflowCategory.social: 'SOCIAL',
  WorkflowCategory.invoice: 'INVOICE',
  WorkflowCategory.ecom: 'ECOM',
  WorkflowCategory.report: 'REPORT',
  WorkflowCategory.notif: 'NOTIF',
  WorkflowCategory.custom: 'CUSTOM',
};

const _$WorkflowDifficultyEnumMap = {
  WorkflowDifficulty.beginner: 'BEGINNER',
  WorkflowDifficulty.intermediate: 'INTERMEDIATE',
  WorkflowDifficulty.advanced: 'ADVANCED',
};

const _$WorkflowStatusEnumMap = {
  WorkflowStatus.draft: 'DRAFT',
  WorkflowStatus.pendingReview: 'PENDING_REVIEW',
  WorkflowStatus.approved: 'APPROVED',
  WorkflowStatus.rejected: 'REJECTED',
};

_$WorkflowFilterImpl _$$WorkflowFilterImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowFilterImpl(
      search: json['search'] as String?,
      category:
          $enumDecodeNullable(_$WorkflowCategoryEnumMap, json['category']),
      platform:
          $enumDecodeNullable(_$WorkflowPlatformEnumMap, json['platform']),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      sort: json['sort'] as String?,
    );

Map<String, dynamic> _$$WorkflowFilterImplToJson(
        _$WorkflowFilterImpl instance) =>
    <String, dynamic>{
      'search': instance.search,
      'category': _$WorkflowCategoryEnumMap[instance.category],
      'platform': _$WorkflowPlatformEnumMap[instance.platform],
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'minRating': instance.minRating,
      'sort': instance.sort,
    };
