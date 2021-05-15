import 'package:leafety/models/profilesDispensaries_response.dart';
import 'package:leafety/models/profiles_response.dart';
import 'package:leafety/models/subscribe.dart';

import 'package:leafety/providers/subscription_provider.dart';

class SubscriptionRepository {
  SubscriptionApiProvider _apiProvider = SubscriptionApiProvider();

  Future<Subscription> getSubscription(String userAuth, String userId) {
    return _apiProvider.getSubscription(userAuth, userId);
  }

  Future<ProfilesDispensariesResponse> getProfilesSubsciptionsPending(
      String userId) {
    return _apiProvider.getProfilesSubscriptionsByUser(userId);
  }

  Future<ProfilesDispensariesResponse> getProfilesSubsciptionsApprove(
      String userId) {
    return _apiProvider.getProfilesSubsciptionsApprove(userId);
  }

  Future<ProfilesResponse> getProfilesSubsciptionsApproveNotifi(String userId) {
    return _apiProvider.getProfilesSubsciptionsApproveNotifi(userId);
  }
}
