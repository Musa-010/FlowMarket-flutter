import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subscription/subscription_model.dart';

final currentSubscriptionProvider =
    StateProvider<Subscription?>((ref) => null);
