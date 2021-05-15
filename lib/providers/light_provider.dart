import 'package:leafety/global/environment.dart';
import 'package:leafety/models/light.dart';
import 'package:leafety/models/lights_response.dart';
import 'package:leafety/models/plant.dart';
import 'package:leafety/models/plant_response.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class LightApiProvider {
  final prefs = new AuthUserPreferences();

  Future<LightsResponse> getLight(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/light/lights/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final lightsResponse = lightsResponseFromJson(resp.body);
      return lightsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return LightsResponse.withError("$error");
    }
  }

  Future<List<Light>> getLightsRoom(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/light/lights/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final lightsResponse = lightsResponseFromJson(resp.body);
      return lightsResponse.lights;
    } catch (e) {
      return [];
    }
  }

  Future<Plant> getPlant(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/plant/plant/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantResponse = plantResponseFromJson(resp.body);
      return plantResponse.plant;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Plant(id: '0');
    }
  }

  Future deleteLight(String lightId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/light/delete/$lightId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
