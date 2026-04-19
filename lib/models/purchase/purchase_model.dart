import 'package:freezed_annotation/freezed_annotation.dart';
import '../workflow/workflow_model.dart';

part 'purchase_model.freezed.dart';
part 'purchase_model.g.dart';

@freezed
class Purchase with _$Purchase {
  const factory Purchase({
    required String id,
    required String userId,
    required String workflowId,
    required double pricePaid,
    String? stripePaymentId,
    Workflow? workflow,
    DateTime? createdAt,
  }) = _Purchase;

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);
}
