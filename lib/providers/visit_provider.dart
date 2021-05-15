import 'package:leafety/global/environment.dart';
import 'package:leafety/models/plant.dart';
import 'package:leafety/models/plant_response.dart';
import 'package:leafety/models/visit.dart';
import 'package:leafety/models/visits_response.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class VisitApiProvider {
  final prefs = new AuthUserPreferences();

  Future<VisitsResponse> getVisit(String plantId) async {
    final urlFinal = ('${Environment.apiUrl}/api/visit/visits/plant/$plantId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitResponse = visitsResponseFromJson(resp.body);
      return visitResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return VisitsResponse.withError("$error");
    }
  }

  Future<List<Visit>> getVisitPlant(String plantId) async {
    final urlFinal = ('${Environment.apiUrl}/api/visit/visits/plant/$plantId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitResponse = visitsResponseFromJson(resp.body);
      return visitResponse.visits;
    } catch (e) {
      return [];
    }
  }

  Future<VisitsResponse> getLastVisitsByUser(String userId) async {
    try {
      final token = prefs.token;

      final urlFinal = ('${Environment.apiUrl}/api/visit/visits/user/$userId');

      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitsResponse = visitsResponseFromJson(resp.body);

      return visitsResponse;
    } catch (error) {
      return VisitsResponse.withError("$error");
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

  Future deletePlant(String plantId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/plant/delete/$plantId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
