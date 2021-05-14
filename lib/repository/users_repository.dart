import 'package:flutter_plants/models/profiles_response.dart';
import 'package:flutter_plants/providers/users_provider.dart';

class UsersRepository {
  UsersProvider _apiProvider = UsersProvider();

  Future<ProfilesResponse> getPrincipalSearch(String query) {
    return _apiProvider.getSearchPrincipalByQuery(query);
  }
}
