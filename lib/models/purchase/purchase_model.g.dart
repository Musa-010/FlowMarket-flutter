// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseImpl _$$PurchaseImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workflowId: json['workflowId'] as String,
      pricePaid: (json['pricePaid'] as num).toDouble(),
      stripePaymentId: json['stripePaymentId'] as String?,
      workflow: json['workflow'] == null
          ? null
          : Workflow.fromJson(json['workflow'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PurchaseImplToJson(_$PurchaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'workflowId': instance.workflowId,
      'pricePaid': instance.pricePaid,
      'stripePaymentId': instance.stripePaymentId,
      'workflow': instance.workflow,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
