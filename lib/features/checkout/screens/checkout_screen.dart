import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_radius.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../providers/workflow_provider.dart';
import '../../../repositories/purchase_repository.dart';
import '../widgets/order_summary_card.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key, required this.workflowId});

  final String workflowId;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _handlePayment(Workflow workflow) async {
    setState(() => _isProcessing = true);
    try {
      // 1. Create PaymentIntent on backend
      final result = await ref
          .read(purchaseRepositoryProvider)
          .createPaymentIntent(workflow.id);

      final clientSecret = result['clientSecret'] as String?;
      final ephemeralKey = result['ephemeralKey'] as String?;
      final customerId = result['customerId'] as String?;

      if (clientSecret == null || ephemeralKey == null || customerId == null) {
        throw Exception('Invalid payment session received from server');
      }

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          merchantDisplayName: 'FlowMarket',
          style: ThemeMode.light,
        ),
      );

      // 3. Present Payment Sheet — user enters card here
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment confirmed
      if (mounted) context.go('/payment-success');
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.error.localizedMessage ?? 'Payment failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncWorkflow = ref.watch(workflowDetailProvider(widget.workflowId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: asyncWorkflow.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorWidget(message: error.toString()),
        data: (workflow) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderSummaryCard(workflow: workflow),
                  const SizedBox(height: 24),
                  Text('Payment Method', style: AppTypography.h4),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: AppRadius.md,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.credit_card_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Credit or Debit Card',
                              style: AppTypography.labelMedium,
                            ),
                            Text(
                              'Powered by Stripe',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.lock_rounded,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Your payment is secured with 256-bit encryption',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label:
                        'Pay \$${(workflow.oneTimePrice ?? 0).toStringAsFixed(0)}',
                    onPressed: () => _handlePayment(workflow),
                    isLoading: _isProcessing,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_rounded,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Secure payment by Stripe',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
