// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workflow _$WorkflowFromJson(Map<String, dynamic> json) {
  return _Workflow.fromJson(json);
}

/// @nodoc
mixin _$Workflow {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get shortDescription => throw _privateConstructorUsedError;
  String? get fullDescription => throw _privateConstructorUsedError;
  WorkflowPlatform get platform => throw _privateConstructorUsedError;
  WorkflowCategory get category => throw _privateConstructorUsedError;
  WorkflowDifficulty get difficulty => throw _privateConstructorUsedError;
  double? get oneTimePrice => throw _privateConstructorUsedError;
  double? get monthlyPrice => throw _privateConstructorUsedError;
  List<String> get previewImages => throw _privateConstructorUsedError;
  List<String> get requiredIntegrations => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get steps => throw _privateConstructorUsedError;
  String? get demoVideoUrl => throw _privateConstructorUsedError;
  String? get workflowFileUrl => throw _privateConstructorUsedError;
  double get avgRating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  int get purchaseCount => throw _privateConstructorUsedError;
  String? get setupTime => throw _privateConstructorUsedError;
  WorkflowStatus get status => throw _privateConstructorUsedError;
  String? get sellerId => throw _privateConstructorUsedError;
  String? get sellerName => throw _privateConstructorUsedError;
  String? get sellerAvatarUrl => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Workflow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowCopyWith<Workflow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowCopyWith<$Res> {
  factory $WorkflowCopyWith(Workflow value, $Res Function(Workflow) then) =
      _$WorkflowCopyWithImpl<$Res, Workflow>;
  @useResult
  $Res call(
      {String id,
      String title,
      String slug,
      String shortDescription,
      String? fullDescription,
      WorkflowPlatform platform,
      WorkflowCategory category,
      WorkflowDifficulty difficulty,
      double? oneTimePrice,
      double? monthlyPrice,
      List<String> previewImages,
      List<String> requiredIntegrations,
      List<String> tags,
      List<String> steps,
      String? demoVideoUrl,
      String? workflowFileUrl,
      double avgRating,
      int reviewCount,
      int purchaseCount,
      String? setupTime,
      WorkflowStatus status,
      String? sellerId,
      String? sellerName,
      String? sellerAvatarUrl,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WorkflowCopyWithImpl<$Res, $Val extends Workflow>
    implements $WorkflowCopyWith<$Res> {
  _$WorkflowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? shortDescription = null,
    Object? fullDescription = freezed,
    Object? platform = null,
    Object? category = null,
    Object? difficulty = null,
    Object? oneTimePrice = freezed,
    Object? monthlyPrice = freezed,
    Object? previewImages = null,
    Object? requiredIntegrations = null,
    Object? tags = null,
    Object? steps = null,
    Object? demoVideoUrl = freezed,
    Object? workflowFileUrl = freezed,
    Object? avgRating = null,
    Object? reviewCount = null,
    Object? purchaseCount = null,
    Object? setupTime = freezed,
    Object? status = null,
    Object? sellerId = freezed,
    Object? sellerName = freezed,
    Object? sellerAvatarUrl = freezed,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      shortDescription: null == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String,
      fullDescription: freezed == fullDescription
          ? _value.fullDescription
          : fullDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as WorkflowPlatform,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as WorkflowCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as WorkflowDifficulty,
      oneTimePrice: freezed == oneTimePrice
          ? _value.oneTimePrice
          : oneTimePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyPrice: freezed == monthlyPrice
          ? _value.monthlyPrice
          : monthlyPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      previewImages: null == previewImages
          ? _value.previewImages
          : previewImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requiredIntegrations: null == requiredIntegrations
          ? _value.requiredIntegrations
          : requiredIntegrations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      demoVideoUrl: freezed == demoVideoUrl
          ? _value.demoVideoUrl
          : demoVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      workflowFileUrl: freezed == workflowFileUrl
          ? _value.workflowFileUrl
          : workflowFileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseCount: null == purchaseCount
          ? _value.purchaseCount
          : purchaseCount // ignore: cast_nullable_to_non_nullable
              as int,
      setupTime: freezed == setupTime
          ? _value.setupTime
          : setupTime // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkflowStatus,
      sellerId: freezed == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerName: freezed == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerAvatarUrl: freezed == sellerAvatarUrl
          ? _value.sellerAvatarUrl
          : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowImplCopyWith<$Res>
    implements $WorkflowCopyWith<$Res> {
  factory _$$WorkflowImplCopyWith(
          _$WorkflowImpl value, $Res Function(_$WorkflowImpl) then) =
      __$$WorkflowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String slug,
      String shortDescription,
      String? fullDescription,
      WorkflowPlatform platform,
      WorkflowCategory category,
      WorkflowDifficulty difficulty,
      double? oneTimePrice,
      double? monthlyPrice,
      List<String> previewImages,
      List<String> requiredIntegrations,
      List<String> tags,
      List<String> steps,
      String? demoVideoUrl,
      String? workflowFileUrl,
      double avgRating,
      int reviewCount,
      int purchaseCount,
      String? setupTime,
      WorkflowStatus status,
      String? sellerId,
      String? sellerName,
      String? sellerAvatarUrl,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WorkflowImplCopyWithImpl<$Res>
    extends _$WorkflowCopyWithImpl<$Res, _$WorkflowImpl>
    implements _$$WorkflowImplCopyWith<$Res> {
  __$$WorkflowImplCopyWithImpl(
      _$WorkflowImpl _value, $Res Function(_$WorkflowImpl) _then)
      : super(_value, _then);

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? shortDescription = null,
    Object? fullDescription = freezed,
    Object? platform = null,
    Object? category = null,
    Object? difficulty = null,
    Object? oneTimePrice = freezed,
    Object? monthlyPrice = freezed,
    Object? previewImages = null,
    Object? requiredIntegrations = null,
    Object? tags = null,
    Object? steps = null,
    Object? demoVideoUrl = freezed,
    Object? workflowFileUrl = freezed,
    Object? avgRating = null,
    Object? reviewCount = null,
    Object? purchaseCount = null,
    Object? setupTime = freezed,
    Object? status = null,
    Object? sellerId = freezed,
    Object? sellerName = freezed,
    Object? sellerAvatarUrl = freezed,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WorkflowImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      shortDescription: null == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String,
      fullDescription: freezed == fullDescription
          ? _value.fullDescription
          : fullDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as WorkflowPlatform,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as WorkflowCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as WorkflowDifficulty,
      oneTimePrice: freezed == oneTimePrice
          ? _value.oneTimePrice
          : oneTimePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyPrice: freezed == monthlyPrice
          ? _value.monthlyPrice
          : monthlyPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      previewImages: null == previewImages
          ? _value._previewImages
          : previewImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requiredIntegrations: null == requiredIntegrations
          ? _value._requiredIntegrations
          : requiredIntegrations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      demoVideoUrl: freezed == demoVideoUrl
          ? _value.demoVideoUrl
          : demoVideoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      workflowFileUrl: freezed == workflowFileUrl
          ? _value.workflowFileUrl
          : workflowFileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      avgRating: null == avgRating
          ? _value.avgRating
          : avgRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseCount: null == purchaseCount
          ? _value.purchaseCount
          : purchaseCount // ignore: cast_nullable_to_non_nullable
              as int,
      setupTime: freezed == setupTime
          ? _value.setupTime
          : setupTime // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkflowStatus,
      sellerId: freezed == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerName: freezed == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerAvatarUrl: freezed == sellerAvatarUrl
          ? _value.sellerAvatarUrl
          : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowImpl implements _Workflow {
  const _$WorkflowImpl(
      {required this.id,
      required this.title,
      required this.slug,
      required this.shortDescription,
      this.fullDescription,
      required this.platform,
      required this.category,
      this.difficulty = WorkflowDifficulty.beginner,
      this.oneTimePrice,
      this.monthlyPrice,
      final List<String> previewImages = const [],
      final List<String> requiredIntegrations = const [],
      final List<String> tags = const [],
      final List<String> steps = const [],
      this.demoVideoUrl,
      this.workflowFileUrl,
      this.avgRating = 0,
      this.reviewCount = 0,
      this.purchaseCount = 0,
      this.setupTime,
      this.status = WorkflowStatus.approved,
      this.sellerId,
      this.sellerName,
      this.sellerAvatarUrl,
      this.isFeatured = false,
      this.createdAt,
      this.updatedAt})
      : _previewImages = previewImages,
        _requiredIntegrations = requiredIntegrations,
        _tags = tags,
        _steps = steps;

  factory _$WorkflowImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String shortDescription;
  @override
  final String? fullDescription;
  @override
  final WorkflowPlatform platform;
  @override
  final WorkflowCategory category;
  @override
  @JsonKey()
  final WorkflowDifficulty difficulty;
  @override
  final double? oneTimePrice;
  @override
  final double? monthlyPrice;
  final List<String> _previewImages;
  @override
  @JsonKey()
  List<String> get previewImages {
    if (_previewImages is EqualUnmodifiableListView) return _previewImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previewImages);
  }

  final List<String> _requiredIntegrations;
  @override
  @JsonKey()
  List<String> get requiredIntegrations {
    if (_requiredIntegrations is EqualUnmodifiableListView)
      return _requiredIntegrations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredIntegrations);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _steps;
  @override
  @JsonKey()
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final String? demoVideoUrl;
  @override
  final String? workflowFileUrl;
  @override
  @JsonKey()
  final double avgRating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final int purchaseCount;
  @override
  final String? setupTime;
  @override
  @JsonKey()
  final WorkflowStatus status;
  @override
  final String? sellerId;
  @override
  final String? sellerName;
  @override
  final String? sellerAvatarUrl;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Workflow(id: $id, title: $title, slug: $slug, shortDescription: $shortDescription, fullDescription: $fullDescription, platform: $platform, category: $category, difficulty: $difficulty, oneTimePrice: $oneTimePrice, monthlyPrice: $monthlyPrice, previewImages: $previewImages, requiredIntegrations: $requiredIntegrations, tags: $tags, steps: $steps, demoVideoUrl: $demoVideoUrl, workflowFileUrl: $workflowFileUrl, avgRating: $avgRating, reviewCount: $reviewCount, purchaseCount: $purchaseCount, setupTime: $setupTime, status: $status, sellerId: $sellerId, sellerName: $sellerName, sellerAvatarUrl: $sellerAvatarUrl, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.fullDescription, fullDescription) ||
                other.fullDescription == fullDescription) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.oneTimePrice, oneTimePrice) ||
                other.oneTimePrice == oneTimePrice) &&
            (identical(other.monthlyPrice, monthlyPrice) ||
                other.monthlyPrice == monthlyPrice) &&
            const DeepCollectionEquality()
                .equals(other._previewImages, _previewImages) &&
            const DeepCollectionEquality()
                .equals(other._requiredIntegrations, _requiredIntegrations) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.demoVideoUrl, demoVideoUrl) ||
                other.demoVideoUrl == demoVideoUrl) &&
            (identical(other.workflowFileUrl, workflowFileUrl) ||
                other.workflowFileUrl == workflowFileUrl) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.purchaseCount, purchaseCount) ||
                other.purchaseCount == purchaseCount) &&
            (identical(other.setupTime, setupTime) ||
                other.setupTime == setupTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.sellerAvatarUrl, sellerAvatarUrl) ||
                other.sellerAvatarUrl == sellerAvatarUrl) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        slug,
        shortDescription,
        fullDescription,
        platform,
        category,
        difficulty,
        oneTimePrice,
        monthlyPrice,
        const DeepCollectionEquality().hash(_previewImages),
        const DeepCollectionEquality().hash(_requiredIntegrations),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_steps),
        demoVideoUrl,
        workflowFileUrl,
        avgRating,
        reviewCount,
        purchaseCount,
        setupTime,
        status,
        sellerId,
        sellerName,
        sellerAvatarUrl,
        isFeatured,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowImplCopyWith<_$WorkflowImpl> get copyWith =>
      __$$WorkflowImplCopyWithImpl<_$WorkflowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowImplToJson(
      this,
    );
  }
}

abstract class _Workflow implements Workflow {
  const factory _Workflow(
      {required final String id,
      required final String title,
      required final String slug,
      required final String shortDescription,
      final String? fullDescription,
      required final WorkflowPlatform platform,
      required final WorkflowCategory category,
      final WorkflowDifficulty difficulty,
      final double? oneTimePrice,
      final double? monthlyPrice,
      final List<String> previewImages,
      final List<String> requiredIntegrations,
      final List<String> tags,
      final List<String> steps,
      final String? demoVideoUrl,
      final String? workflowFileUrl,
      final double avgRating,
      final int reviewCount,
      final int purchaseCount,
      final String? setupTime,
      final WorkflowStatus status,
      final String? sellerId,
      final String? sellerName,
      final String? sellerAvatarUrl,
      final bool isFeatured,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WorkflowImpl;

  factory _Workflow.fromJson(Map<String, dynamic> json) =
      _$WorkflowImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String get shortDescription;
  @override
  String? get fullDescription;
  @override
  WorkflowPlatform get platform;
  @override
  WorkflowCategory get category;
  @override
  WorkflowDifficulty get difficulty;
  @override
  double? get oneTimePrice;
  @override
  double? get monthlyPrice;
  @override
  List<String> get previewImages;
  @override
  List<String> get requiredIntegrations;
  @override
  List<String> get tags;
  @override
  List<String> get steps;
  @override
  String? get demoVideoUrl;
  @override
  String? get workflowFileUrl;
  @override
  double get avgRating;
  @override
  int get reviewCount;
  @override
  int get purchaseCount;
  @override
  String? get setupTime;
  @override
  WorkflowStatus get status;
  @override
  String? get sellerId;
  @override
  String? get sellerName;
  @override
  String? get sellerAvatarUrl;
  @override
  bool get isFeatured;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Workflow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowImplCopyWith<_$WorkflowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowFilter _$WorkflowFilterFromJson(Map<String, dynamic> json) {
  return _WorkflowFilter.fromJson(json);
}

/// @nodoc
mixin _$WorkflowFilter {
  String? get search => throw _privateConstructorUsedError;
  WorkflowCategory? get category => throw _privateConstructorUsedError;
  WorkflowPlatform? get platform => throw _privateConstructorUsedError;
  double? get minPrice => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;
  double? get minRating => throw _privateConstructorUsedError;
  String? get sort => throw _privateConstructorUsedError;

  /// Serializes this WorkflowFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowFilterCopyWith<WorkflowFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowFilterCopyWith<$Res> {
  factory $WorkflowFilterCopyWith(
          WorkflowFilter value, $Res Function(WorkflowFilter) then) =
      _$WorkflowFilterCopyWithImpl<$Res, WorkflowFilter>;
  @useResult
  $Res call(
      {String? search,
      WorkflowCategory? category,
      WorkflowPlatform? platform,
      double? minPrice,
      double? maxPrice,
      double? minRating,
      String? sort});
}

/// @nodoc
class _$WorkflowFilterCopyWithImpl<$Res, $Val extends WorkflowFilter>
    implements $WorkflowFilterCopyWith<$Res> {
  _$WorkflowFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? category = freezed,
    Object? platform = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRating = freezed,
    Object? sort = freezed,
  }) {
    return _then(_value.copyWith(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as WorkflowCategory?,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as WorkflowPlatform?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowFilterImplCopyWith<$Res>
    implements $WorkflowFilterCopyWith<$Res> {
  factory _$$WorkflowFilterImplCopyWith(_$WorkflowFilterImpl value,
          $Res Function(_$WorkflowFilterImpl) then) =
      __$$WorkflowFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? search,
      WorkflowCategory? category,
      WorkflowPlatform? platform,
      double? minPrice,
      double? maxPrice,
      double? minRating,
      String? sort});
}

/// @nodoc
class __$$WorkflowFilterImplCopyWithImpl<$Res>
    extends _$WorkflowFilterCopyWithImpl<$Res, _$WorkflowFilterImpl>
    implements _$$WorkflowFilterImplCopyWith<$Res> {
  __$$WorkflowFilterImplCopyWithImpl(
      _$WorkflowFilterImpl _value, $Res Function(_$WorkflowFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? category = freezed,
    Object? platform = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRating = freezed,
    Object? sort = freezed,
  }) {
    return _then(_$WorkflowFilterImpl(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as WorkflowCategory?,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as WorkflowPlatform?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowFilterImpl implements _WorkflowFilter {
  const _$WorkflowFilterImpl(
      {this.search,
      this.category,
      this.platform,
      this.minPrice,
      this.maxPrice,
      this.minRating,
      this.sort});

  factory _$WorkflowFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowFilterImplFromJson(json);

  @override
  final String? search;
  @override
  final WorkflowCategory? category;
  @override
  final WorkflowPlatform? platform;
  @override
  final double? minPrice;
  @override
  final double? maxPrice;
  @override
  final double? minRating;
  @override
  final String? sort;

  @override
  String toString() {
    return 'WorkflowFilter(search: $search, category: $category, platform: $platform, minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating, sort: $sort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowFilterImpl &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.sort, sort) || other.sort == sort));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, search, category, platform,
      minPrice, maxPrice, minRating, sort);

  /// Create a copy of WorkflowFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowFilterImplCopyWith<_$WorkflowFilterImpl> get copyWith =>
      __$$WorkflowFilterImplCopyWithImpl<_$WorkflowFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowFilterImplToJson(
      this,
    );
  }
}

abstract class _WorkflowFilter implements WorkflowFilter {
  const factory _WorkflowFilter(
      {final String? search,
      final WorkflowCategory? category,
      final WorkflowPlatform? platform,
      final double? minPrice,
      final double? maxPrice,
      final double? minRating,
      final String? sort}) = _$WorkflowFilterImpl;

  factory _WorkflowFilter.fromJson(Map<String, dynamic> json) =
      _$WorkflowFilterImpl.fromJson;

  @override
  String? get search;
  @override
  WorkflowCategory? get category;
  @override
  WorkflowPlatform? get platform;
  @override
  double? get minPrice;
  @override
  double? get maxPrice;
  @override
  double? get minRating;
  @override
  String? get sort;

  /// Create a copy of WorkflowFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowFilterImplCopyWith<_$WorkflowFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
