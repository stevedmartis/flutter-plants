import 'package:flutter_plants/models/air.dart';
import 'package:flutter_plants/models/aires_response.dart';

import 'package:flutter_plants/providers/air_provider.dart';

class AirRepository {
  AiresApiProvider _apiProvider = AiresApiProvider();

  Future<AiresResponse> getAires(String roomId) {
    return _apiProvider.getAires(roomId);
  }

  Future<Air> getAir(String roomId) {
    return _apiProvider.getAir(roomId);
  }
}
