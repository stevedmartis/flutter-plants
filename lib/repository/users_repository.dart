import 'package:leafety/models/profiles_response.dart';
import 'package:leafety/providers/users_provider.dart';

class UsersRepository {
  UsersProvider _apiProvider = UsersProvider();

  Future<ProfilesResponse> getPrincipalSearch(String query) {
    return _apiProvider.getSearchPrincipalByQuery(query);
  }
}
