import 'package:leafety/models/profiles.dart';
import 'package:leafety/models/profiles_response.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

import 'package:leafety/models/usuario.dart';
import 'package:leafety/models/usuarios_response.dart';

import 'package:leafety/global/environment.dart';

class UsuariosService {
  final prefs = new AuthUserPreferences();
  Future<List<User>> getUsers() async {
    final urlFinal = ('${Environment.apiUrl}/api/users');

    try {
      final resp = await http.get(Uri.parse(urlFinal), headers: {
        'Content-Type': 'application/json',
        'x-token': prefs.token
      });

      final usersResponse = usuariosResponseFromJson(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }

  Future<List<Profiles>> getProfilesLastUsers() async {
    final urlFinal = ('${Environment.apiUrl}/api/profile/last/users');

    try {
      final resp = await http.get(Uri.parse(urlFinal), headers: {
        'Content-Type': 'application/json',
        'x-token': prefs.token
      });

      final profilesResponse = profilesResponseFromJson(resp.body);

      return profilesResponse.profiles;
    } catch (e) {
      return [];
    }
  }
}
