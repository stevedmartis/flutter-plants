import 'package:leafety/models/room.dart';
import 'package:leafety/models/rooms_response.dart';
import 'package:leafety/providers/rooms_provider.dart';

class RoomsRepository {
  RoomsApiProvider _apiProvider = RoomsApiProvider();

  Future<RoomsResponse> getRooms(String userId) {
    return _apiProvider.getRooms(userId);
  }

  Future<Room> getRoom(String roomId) {
    return _apiProvider.getRoom(roomId);
  }
}
