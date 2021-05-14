import 'package:flutter_plants/models/room.dart';
import 'package:flutter_plants/models/rooms_response.dart';
import 'package:flutter_plants/providers/rooms_provider.dart';

class RoomsRepository {
  RoomsApiProvider _apiProvider = RoomsApiProvider();

  Future<RoomsResponse> getRooms(String userId) {
    return _apiProvider.getRooms(userId);
  }

  Future<Room> getRoom(String roomId) {
    return _apiProvider.getRoom(roomId);
  }
}
