class RouteNames {
  RouteNames._();

  // Auth & Onboarding
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const register = 'register';
  static const forgotPassword = 'forgot-password';

  // Main Tabs
  static const marketplace = 'marketplace';
  static const aiChat = 'ai-chat';
  static const dashboard = 'dashboard';
  static const purchases = 'purchases';
  static const profile = 'profile';

  // Marketplace Sub-routes
  static const workflowDetail = 'workflow-detail';
  static const search = 'search';

  // Deployments
  static const deployments = 'deployments';
  static const deploymentDetail = 'deployment-detail';
  static const configWizard = 'config-wizard';

  // Profile Sub-routes
  static const editProfile = 'edit-profile';
  static const billing = 'billing';
  static const plans = 'plans';
  static const notifications = 'notifications';

  // Seller
  static const seller = 'seller';
  static const sellerOnboarding = 'seller-onboarding';
  static const uploadWorkflow = 'upload-workflow';
  static const myWorkflows = 'my-workflows';
  static const earnings = 'earnings';

  // Checkout
  static const checkout = 'checkout';
  static const paymentSuccess = 'payment-success';
}

class RoutePaths {
  RoutePaths._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const marketplace = '/marketplace';
  static const aiChat = '/ai-chat';
  static const dashboard = '/dashboard';
  static const purchases = '/purchases';
  static const profile = '/profile';

  static const search = '/search';
  static const seller = '/seller';

  static String workflowDetail(String slug) => '/marketplace/$slug';
  static String deploymentDetail(String id) => '/deployments/$id';
  static String configWizard(String id) => '/deployments/$id/configure';
  static String checkout(String workflowId) => '/checkout/$workflowId';
  static const paymentSuccess = '/payment-success';
}
