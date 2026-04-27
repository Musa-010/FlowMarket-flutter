import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/marketplace/screens/marketplace_screen.dart';
import '../../features/marketplace/screens/workflow_detail_screen.dart';
import '../../features/marketplace/screens/search_screen.dart';
import '../../features/ai_assistant/screens/ai_chat_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/purchases/screens/purchases_screen.dart';
import '../../features/deployments/screens/deployments_screen.dart';
import '../../features/deployments/screens/deployment_detail_screen.dart';
import '../../features/deployments/screens/config_wizard_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/subscription/screens/plans_screen.dart';
import '../../features/subscription/screens/billing_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/seller/screens/seller_home_screen.dart';
import '../../features/seller/screens/seller_onboarding_screen.dart';
import '../../features/seller/screens/upload_workflow_screen.dart';
import '../../features/seller/screens/my_workflows_screen.dart';
import '../../features/seller/screens/earnings_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/checkout/screens/payment_success_screen.dart';
import '../../shared/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isSplash = location == '/splash';

      // Auth still loading — stay on splash
      if (authState.isLoading) return isSplash ? null : '/splash';

      final isLoggedIn = authState.value != null;
      final isAuthRoute = location.startsWith('/login') ||
          location.startsWith('/register') ||
          location.startsWith('/onboarding') ||
          location.startsWith('/forgot-password');

      // Auth just finished — redirect from splash
      if (isSplash) return isLoggedIn ? '/dashboard' : '/login';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/dashboard';

      return null;
    },
    routes: [
      // --- Auth & Onboarding (no bottom nav) ---
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      // --- Main shell with bottom navigation ---
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(navigationShell: shell),
        branches: [
          // Tab 1: Marketplace
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/marketplace',
              builder: (_, __) => const MarketplaceScreen(),
              routes: [
                GoRoute(
                  path: ':slug',
                  builder: (_, state) => WorkflowDetailScreen(
                    slug: state.pathParameters['slug']!,
                  ),
                ),
              ],
            ),
          ]),

          // Tab 2: AI Chat
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/ai-chat',
              builder: (_, __) => const AiChatScreen(),
            ),
          ]),

          // Tab 3: Dashboard
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard',
              builder: (_, __) => const DashboardScreen(),
            ),
          ]),

          // Tab 4: My Library (Purchases + Deployments)
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/purchases',
              builder: (_, __) => const PurchasesScreen(),
            ),
            GoRoute(
              path: '/deployments',
              builder: (_, __) => const DeploymentsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (_, state) => DeploymentDetailScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: ':id/configure',
                  builder: (_, state) => ConfigWizardScreen(
                    deploymentId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),

          // Tab 5: Profile
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, __) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'billing',
                  builder: (_, __) => const BillingScreen(),
                ),
                GoRoute(
                  path: 'plans',
                  builder: (_, __) => const PlansScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (_, __) => const NotificationsScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),

      // --- Seller routes (no bottom nav) ---
      GoRoute(
        path: '/seller',
        builder: (_, __) => const SellerHomeScreen(),
        routes: [
          GoRoute(
            path: 'onboarding',
            builder: (_, __) => const SellerOnboardingScreen(),
          ),
          GoRoute(
            path: 'upload',
            builder: (_, __) => const UploadWorkflowScreen(),
          ),
          GoRoute(
            path: 'workflows',
            builder: (_, __) => const MyWorkflowsScreen(),
          ),
          GoRoute(
            path: 'earnings',
            builder: (_, __) => const EarningsScreen(),
          ),
        ],
      ),

      // --- Standalone routes (no bottom nav) ---
      GoRoute(
        path: '/search',
        builder: (_, __) => const SearchScreen(),
      ),
      GoRoute(
        path: '/checkout/:workflowId',
        builder: (_, state) => CheckoutScreen(
          workflowId: state.pathParameters['workflowId']!,
        ),
      ),
      GoRoute(
        path: '/payment-success',
        builder: (_, __) => const PaymentSuccessScreen(),
      ),
    ],
  );
});
