import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/otp_verify_screen.dart';
import '../../models/user/user_model.dart';
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

// Holds current auth state so redirect can read it safely without ref
class _RouterNotifier extends ChangeNotifier {
  AsyncValue _authState = const AsyncValue.loading();
  AsyncValue get authState => _authState;

  _RouterNotifier(Ref ref) {
    _authState = ref.read(authProvider);
    ref.listen<AsyncValue>(authProvider, (_, next) {
      _authState = next;
      notifyListeners();
    });
  }
}

final _routerNotifierProvider =
    ChangeNotifierProvider((ref) => _RouterNotifier(ref));

final appRouterProvider = Provider<GoRouter>((ref) {
  // ref.read — do NOT watch. GoRouter created once, refreshListenable handles redirects.
  final notifier = ref.read(_routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = notifier.authState;
      final location = state.matchedLocation;
      final isSplash = location == '/splash';

      final isAuthRoute = location.startsWith('/login') ||
          location.startsWith('/register') ||
          location.startsWith('/onboarding') ||
          location.startsWith('/forgot-password') ||
          location.startsWith('/verify-otp');

      // During loading: stay on splash/auth routes, redirect everything else to splash
      if (authState.isLoading) {
        if (isSplash || isAuthRoute) return null;
        return '/splash';
      }

      // Login error — stay on current auth route, don't navigate away
      if (authState.hasError) return isAuthRoute ? null : '/login';

      final isLoggedIn = authState.value != null;

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
      GoRoute(
        path: '/verify-otp',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) return const Scaffold(backgroundColor: Color(0xFF101415));
          return OtpVerifyScreen(
            email: extra['email'] as String,
            fullName: extra['fullName'] as String,
            password: extra['password'] as String,
            role: extra['role'] as UserRole,
          );
        },
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
