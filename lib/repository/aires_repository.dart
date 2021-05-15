import 'package:leafety/models/air.dart';
import 'package:leafety/models/aires_response.dart';

import 'package:leafety/providers/air_provider.dart';

class AirRepository {
  AiresApiProvider _apiProvider = AiresApiProvider();

  Future<AiresResponse> getAires(String roomId) {
    return _apiProvider.getAires(roomId);
  }

  Future<Air> getAir(String roomId) {
    return _apiProvider.getAir(roomId);
  }
}
