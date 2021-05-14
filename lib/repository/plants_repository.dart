import 'package:flutter_plants/models/plant.dart';
import 'package:flutter_plants/models/plants_response.dart';
import 'package:flutter_plants/providers/plants_provider.dart';

class PlantsRepository {
  PlantsApiProvider _apiProvider = PlantsApiProvider();

  Future<PlantsResponse> getPlants(String roomId) {
    return _apiProvider.getPlants(roomId);
  }

  Future<PlantsResponse> getPlantsUser(String uid) {
    return _apiProvider.getLastPlantsByUser(uid);
  }

  Future<Plant> getPlant(String plantId) {
    return _apiProvider.getPlant(plantId);
  }
}
