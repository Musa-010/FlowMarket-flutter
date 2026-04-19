class ApiConstants {
  ApiConstants._();

  static const defaultPageSize = 20;
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);

  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const refreshToken = '/auth/refresh';
  static const currentUser = '/auth/me';
  static const forgotPassword = '/auth/forgot-password';

  // Workflows
  static const workflows = '/workflows';
  static const featuredWorkflows = '/workflows/featured';

  // AI
  static const aiRecommend = '/ai/recommend';

  // Purchases
  static const purchases = '/purchases';

  // Checkout
  static const checkoutOneTime = '/checkout/one-time';
  static const checkoutSubscription = '/checkout/subscription';

  // Deployments
  static const deployments = '/deployments';

  // Seller
  static const sellerWorkflows = '/seller/workflows';
  static const sellerEarnings = '/seller/earnings';

  // Notifications
  static const notifications = '/notifications';
  static const markNotificationsRead = '/notifications/mark-read';
}
