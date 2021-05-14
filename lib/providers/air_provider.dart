import 'package:flutter_plants/global/environment.dart';
import 'package:flutter_plants/models/air.dart';
import 'package:flutter_plants/models/air_response.dart';
import 'package:flutter_plants/models/aires_response.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class AiresApiProvider {
  final prefs = new AuthUserPreferences();

  Future<AiresResponse> getAires(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/air/airs/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airesResponse = airesResponseFromJson(resp.body);
      return airesResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return AiresResponse.withError("$error");
    }
  }

  Future<Air> getAir(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/plant/plant/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airResponse = airResponseFromJson(resp.body);
      return airResponse.air;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Air(id: '0');
    }
  }

  Future<List<Air>> getAiresRoom(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/air/airs/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airesResponse = airesResponseFromJson(resp.body);
      return airesResponse.airs;
    } catch (e) {
      return [];
    }
  }

  Future deleteAir(String airId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/air/delete/$airId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
