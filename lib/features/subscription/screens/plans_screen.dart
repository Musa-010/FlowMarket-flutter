import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../repositories/purchase_repository.dart';
import '../widgets/plan_card.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  bool _isYearly = false;
  String? _loadingPlan;

  Future<void> _selectPlan(String planName) async {
    final planId = '${planName.toUpperCase()}_${_isYearly ? 'YEARLY' : 'MONTHLY'}';
    setState(() => _loadingPlan = planName);
    try {
      final result = await ref
          .read(purchaseRepositoryProvider)
          .createSubscriptionIntent(planId);

      final clientSecret = result['clientSecret'] as String?;
      final ephemeralKey = result['ephemeralKey'] as String?;
      final customerId = result['customerId'] as String?;

      if (clientSecret == null || ephemeralKey == null || customerId == null) {
        throw Exception('Invalid payment session received from server');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: customerId,
          merchantDisplayName: 'FlowMarket',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Card saved — now create subscription
      await ref
          .read(purchaseRepositoryProvider)
          .subscribeAfterSetup(planId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription activated!')),
        );
        context.pop();
      }
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
      if (mounted) setState(() => _loadingPlan = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Plan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Billing Toggle
              _buildBillingToggle(),
              const SizedBox(height: 24),

              // Plan Cards
              PlanCard(
                name: 'Starter',
                monthlyPrice: 29,
                yearlyPrice: 23,
                isYearly: _isYearly,
                isLoading: _loadingPlan == 'Starter',
                features: const [
                  ('1 active workflow', true),
                  ('1,000 executions/month', true),
                  ('Email support', true),
                  ('Priority support', false),
                  ('Custom domain', false),
                  ('White-label', false),
                ],
                onSelect: () => _selectPlan('Starter'),
              ),
              const SizedBox(height: 16),

              PlanCard(
                name: 'Pro',
                monthlyPrice: 79,
                yearlyPrice: 63,
                isPopular: true,
                isYearly: _isYearly,
                isLoading: _loadingPlan == 'Pro',
                features: const [
                  ('5 active workflows', true),
                  ('10,000 executions/month', true),
                  ('Priority support', true),
                  ('Advanced analytics', true),
                  ('Custom domain', false),
                  ('White-label', false),
                ],
                onSelect: () => _selectPlan('Pro'),
              ),
              const SizedBox(height: 16),

              PlanCard(
                name: 'Agency',
                monthlyPrice: 299,
                yearlyPrice: 239,
                isYearly: _isYearly,
                isLoading: _loadingPlan == 'Agency',
                features: const [
                  ('Unlimited workflows', true),
                  ('Unlimited executions', true),
                  ('Dedicated support', true),
                  ('Advanced analytics', true),
                  ('Custom domain', true),
                  ('White-label', true),
                ],
                onSelect: () => _selectPlan('Agency'),
              ),
              const SizedBox(height: 32),

              // FAQ Section
              _buildFaqSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.full,
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isYearly = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !_isYearly ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadius.full,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Monthly',
                  style: AppTypography.labelLarge.copyWith(
                    color:
                        !_isYearly ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _isYearly = true),
              child: Container(
                decoration: BoxDecoration(
                  color: _isYearly ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadius.full,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Yearly',
                      style: AppTypography.labelLarge.copyWith(
                        color: _isYearly
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: AppRadius.full,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Text(
                        '-20%',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Frequently Asked Questions', style: AppTypography.h4),
        const SizedBox(height: 12),
        _buildFaqTile(
          'Can I cancel anytime?',
          'Yes! You can cancel your subscription at any time. Your plan will '
              'remain active until the end of your current billing period.',
        ),
        _buildFaqTile(
          'What happens to my workflows if I cancel?',
          'Your purchased workflows remain yours forever. You just won\'t be '
              'able to deploy new ones or run executions without an active plan.',
        ),
        _buildFaqTile(
          'Do I need a subscription to buy workflows?',
          'No! You can purchase workflows without a subscription. A subscription '
              'is only needed to deploy and run workflows in the cloud.',
        ),
        _buildFaqTile(
          'What are \'executions\'?',
          'An execution is one run of your automated workflow. For example, if '
              'your workflow sends a follow-up email each time a form is submitted, '
              'each form submission counts as one execution.',
        ),
      ],
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: AppTypography.labelLarge),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            answer,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
