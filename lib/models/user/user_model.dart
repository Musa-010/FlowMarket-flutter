// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('BUYER')
  buyer,
  @JsonValue('SELLER')
  seller,
  @JsonValue('ADMIN')
  admin,
}

Object? _readFullName(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['name'];

String _fullNameFromJson(Object? value) => (value as String?) ?? '';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    @JsonKey(readValue: _readFullName, fromJson: _fullNameFromJson)
    required String fullName,
    String? avatarUrl,
    @Default(UserRole.buyer) UserRole role,
    String? stripeCustomerId,
    String? stripeConnectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class LoginDto with _$LoginDto {
  const factory LoginDto({required String email, required String password}) =
      _LoginDto;

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);
}

@freezed
class RegisterDto with _$RegisterDto {
  const factory RegisterDto({
    required String fullName,
    required String email,
    required String password,
    @Default(UserRole.buyer) UserRole role,
  }) = _RegisterDto;

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);
}
