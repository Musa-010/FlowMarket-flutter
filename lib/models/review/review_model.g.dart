// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  workflowId: json['workflowId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  userName: json['userName'] as String?,
  userAvatarUrl: json['userAvatarUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'workflowId': instance.workflowId,
      'rating': instance.rating,
      'comment': instance.comment,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$CreateReviewDtoImpl _$$CreateReviewDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateReviewDtoImpl(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$$CreateReviewDtoImplToJson(
  _$CreateReviewDtoImpl instance,
) => <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};
