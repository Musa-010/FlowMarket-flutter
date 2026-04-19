import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/user/user_model.dart';
import '../constants/api_constants.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Auth
  @POST(ApiConstants.login)
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.register)
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.currentUser)
  Future<User> getCurrentUser();

  @POST(ApiConstants.forgotPassword)
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  // Workflows
  @GET(ApiConstants.workflows)
  Future<dynamic> getWorkflows(@Queries() Map<String, dynamic> query);

  @GET(ApiConstants.featuredWorkflows)
  Future<dynamic> getFeaturedWorkflows();

  @GET('${ApiConstants.workflows}/{slug}')
  Future<dynamic> getWorkflowBySlug(@Path('slug') String slug);

  // AI
  @POST(ApiConstants.aiRecommend)
  Future<dynamic> recommendAi(@Body() Map<String, dynamic> body);

  // Purchases
  @GET(ApiConstants.purchases)
  Future<dynamic> getPurchases(@Queries() Map<String, dynamic> query);

  @POST(ApiConstants.checkoutOneTime)
  Future<dynamic> createOneTimeCheckout(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.checkoutSubscription)
  Future<dynamic> createSubscriptionCheckout(@Body() Map<String, dynamic> body);

  // Deployments
  @GET(ApiConstants.deployments)
  Future<dynamic> getDeployments();

  @GET('${ApiConstants.deployments}/{id}')
  Future<dynamic> getDeployment(@Path('id') String id);

  @POST(ApiConstants.deployments)
  Future<dynamic> createDeployment(@Body() Map<String, dynamic> body);

  @POST('${ApiConstants.deployments}/{id}/configure')
  Future<dynamic> configureDeployment(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('${ApiConstants.deployments}/{id}/pause')
  Future<dynamic> pauseDeployment(@Path('id') String id);

  @POST('${ApiConstants.deployments}/{id}/resume')
  Future<dynamic> resumeDeployment(@Path('id') String id);

  @POST('${ApiConstants.deployments}/{id}/stop')
  Future<dynamic> stopDeployment(@Path('id') String id);

  @GET('${ApiConstants.deployments}/{id}/logs')
  Future<dynamic> getDeploymentLogs(
    @Path('id') String id,
    @Queries() Map<String, dynamic> query,
  );

  // Seller
  @GET(ApiConstants.sellerWorkflows)
  Future<dynamic> getSellerWorkflows();

  @POST(ApiConstants.sellerWorkflows)
  Future<dynamic> createSellerWorkflow(@Body() Map<String, dynamic> body);

  @PATCH('${ApiConstants.sellerWorkflows}/{id}')
  Future<dynamic> updateSellerWorkflow(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('${ApiConstants.sellerWorkflows}/{id}/submit')
  Future<dynamic> submitSellerWorkflow(@Path('id') String id);

  @GET(ApiConstants.sellerEarnings)
  Future<dynamic> getSellerEarnings();
}
