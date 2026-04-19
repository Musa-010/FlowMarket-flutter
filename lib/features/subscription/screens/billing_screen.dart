import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_radius.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../repositories/purchase_repository.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  bool _isAddingCard = false;

  Future<void> _addCard() async {
    setState(() => _isAddingCard = true);
    try {
      // 1. Create SetupIntent on backend
      final result = await ref.read(purchaseRepositoryProvider).createSetupIntent();

      final setupIntentClientSecret = result['setupIntentClientSecret'] as String?;
      final ephemeralKey = result['ephemeralKey'] as String?;
      final customerId = result['customerId'] as String?;

      if (setupIntentClientSecret == null || ephemeralKey == null || customerId == null) {
        throw Exception('Invalid setup session received from server');
      }

      // 2. Initialize Payment Sheet for card setup (no charge)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: setupIntentClientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          merchantDisplayName: 'FlowMarket',
          style: ThemeMode.light,
        ),
      );

      // 3. Present — user enters card details
      await Stripe.instance.presentPaymentSheet();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card added successfully')),
        );
        setState(() {});
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.error.localizedMessage ?? 'Failed to add card')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingCard = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing & Subscription'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Plan
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.md,
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Free Plan', style: AppTypography.h3),
                          const SizedBox(height: 4),
                          Text(
                            'No active subscription',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      label: 'Upgrade',
                      fullWidth: false,
                      onPressed: () => context.push('/profile/plans'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Payment History
              Text('Payment History', style: AppTypography.h4),
              const SizedBox(height: 12),
              Text(
                'No payments yet',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Payment Method
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
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No payment method on file',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    _isAddingCard
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton(
                            onPressed: _addCard,
                            child: Text(
                              'Add',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Manage on Stripe
              Center(
                child: TextButton.icon(
                  onPressed: () => context.push('/profile/plans'),
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Manage Subscription',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
