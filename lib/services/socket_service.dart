import 'package:flutter_plants/global/environment.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void connect() async {
    final token = prefs.token;

    // Dart client
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.on('connection', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
