import 'package:leafety/global/environment.dart';
import 'package:leafety/models/room.dart';
import 'package:leafety/models/room_response.dart';
import 'package:leafety/models/rooms_response.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class RoomsApiProvider {
  final prefs = new AuthUserPreferences();

  Future<RoomsResponse> getRooms(String userId) async {
    final urlFinal = ('${Environment.apiUrl}/api/room/rooms/user/$userId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final roomsResponse = roomsResponseFromJson(resp.body);
      return roomsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RoomsResponse.withError("$error");
    }
  }

  Future<Room> getRoom(String roomId) async {
    final urlFinal = ('${Environment.apiUrl}/api/room/room/$roomId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final roomsResponse = roomResponseFromJson(resp.body);
      return roomsResponse.room;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Room(id: '0');
    }
  }
}
