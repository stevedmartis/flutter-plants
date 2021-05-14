import 'package:flutter_plants/global/environment.dart';
import 'package:flutter_plants/models/plant.dart';
import 'package:flutter_plants/models/plant_response.dart';
import 'package:flutter_plants/models/plants_response.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class PlantsApiProvider {
  final prefs = new AuthUserPreferences();

  Future<PlantsResponse> getPlants(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/plant/plants/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);
      return plantsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PlantsResponse.withError("$error");
    }
  }

  Future<PlantsResponse> getLastPlantsByUser(String userId) async {
    try {
      final token = prefs.token;

      final urlFinal = ('${Environment.apiUrl}/api/plant/plants/user/$userId');

      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);

      return plantsResponse;
    } catch (error) {
      return PlantsResponse.withError("$error");
    }
  }

  Future<List<Plant>> getPlantsRoom(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/plant/plants/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);
      return plantsResponse.plants;
    } catch (e) {
      return [];
    }
  }

  Future<List<Plant>> getPlantsRoomSelectedProduct(
      String roomId, String productId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/plant/plants/room/$roomId/product/$productId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);
      return plantsResponse.plants;
    } catch (e) {
      return [];
    }
  }

  Future<List<Plant>> getPlantsByProduct(String productId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/plant_product/plants/product/$productId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = plantsResponseFromJson(resp.body);
      return plantsResponse.plants;
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
