// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: _fullNameFromJson(_readFullName(json, 'fullName')),
  avatarUrl: json['avatarUrl'] as String?,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.buyer,
  stripeCustomerId: json['stripeCustomerId'] as String?,
  stripeConnectId: json['stripeConnectId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'role': _$UserRoleEnumMap[instance.role]!,
      'stripeCustomerId': instance.stripeCustomerId,
      'stripeConnectId': instance.stripeConnectId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.buyer: 'BUYER',
  UserRole.seller: 'SELLER',
  UserRole.admin: 'ADMIN',
};

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };

_$LoginDtoImpl _$$LoginDtoImplFromJson(Map<String, dynamic> json) =>
    _$LoginDtoImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginDtoImplToJson(_$LoginDtoImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$RegisterDtoImpl _$$RegisterDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterDtoImpl(
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.buyer,
);

Map<String, dynamic> _$$RegisterDtoImplToJson(_$RegisterDtoImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'role': _$UserRoleEnumMap[instance.role]!,
    };
