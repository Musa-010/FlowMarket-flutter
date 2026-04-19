// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      plan: $enumDecode(_$PlanTierEnumMap, json['plan']),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      currentPeriodEnd: json['currentPeriodEnd'] == null
          ? null
          : DateTime.parse(json['currentPeriodEnd'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'plan': _$PlanTierEnumMap[instance.plan]!,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'currentPeriodEnd': instance.currentPeriodEnd?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$PlanTierEnumMap = {
  PlanTier.starter: 'STARTER',
  PlanTier.pro: 'PRO',
  PlanTier.agency: 'AGENCY',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'ACTIVE',
  SubscriptionStatus.canceled: 'CANCELED',
  SubscriptionStatus.pastDue: 'PAST_DUE',
  SubscriptionStatus.trialing: 'TRIALING',
};
