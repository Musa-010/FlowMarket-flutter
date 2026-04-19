import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String userId,
    required String workflowId,
    required int rating,
    String? comment,
    String? userName,
    String? userAvatarUrl,
    DateTime? createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}

@freezed
class CreateReviewDto with _$CreateReviewDto {
  const factory CreateReviewDto({
    required int rating,
    String? comment,
  }) = _CreateReviewDto;

  factory CreateReviewDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewDtoFromJson(json);
}
