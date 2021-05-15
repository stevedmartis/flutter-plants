import 'dart:async';
import 'package:leafety/bloc/validators.dart';
import 'package:leafety/models/profiles.dart';
import 'package:leafety/models/profiles_response.dart';

import 'package:leafety/repository/users_repository.dart';

import 'package:rxdart/rxdart.dart';

class UsersBloc with Validators {
  final _usersController = BehaviorSubject<List<Profiles>>();

  final UsersRepository _repository = UsersRepository();

  final BehaviorSubject<ProfilesResponse> _subject =
      BehaviorSubject<ProfilesResponse>();

  getPrincipalSearch() async {
    ProfilesResponse response = await _repository.getPrincipalSearch('');
    _subject.sink.add(response);
  }

  BehaviorSubject<ProfilesResponse> get subject => _subject;
  // Recuperar los datos del Stream

  Stream<List<Profiles>> get rooms => _usersController.stream;

  Function(List<Profiles>) get addUser => _usersController.sink.add;

  dispose() {
    _subject.close();

    _usersController?.close();
  }
}

final usersBloc = UsersBloc();
