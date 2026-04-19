import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

enum PlanTier {
  @JsonValue('STARTER')
  starter,
  @JsonValue('PRO')
  pro,
  @JsonValue('AGENCY')
  agency,
}

enum SubscriptionStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('CANCELED')
  canceled,
  @JsonValue('PAST_DUE')
  pastDue,
  @JsonValue('TRIALING')
  trialing,
}

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String userId,
    required PlanTier plan,
    required SubscriptionStatus status,
    String? stripeSubscriptionId,
    DateTime? currentPeriodEnd,
    DateTime? createdAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
