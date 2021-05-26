import 'dart:convert';

import 'package:leafety/models/profile_response.dart';
import 'package:leafety/models/profiles.dart';
import 'package:leafety/models/room.dart';
import 'package:flutter/material.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:leafety/global/environment.dart';

import 'package:leafety/models/login_response.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:universal_platform/universal_platform.dart';

class AuthService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Profiles _profile;
  bool _bottomVisible = true;
  List<Room> rooms;
  bool _authenticated = false;

  static String clientId = 'com.budanty.signinservice';
  static String redirectUri =
      'https://api.gettymarket.com/api/apple/callbacks/sign_in_with_apple';

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  appleSignIn() async {
    bool isIos = UniversalPlatform.isIOS;
    //bool isWeb = UniversalPlatform.isWeb;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientId, redirectUri: Uri.parse(redirectUri)));

      final useBundleId = isIos ? true : false;

      final res = await this.siginWithApple(
          credential.authorizationCode,
          credential.email,
          credential.givenName,
          useBundleId,
          credential.state);

      return res;
    } catch (e) {
      print(e);
    }
  }

  bool get authenticated => this._authenticated;
  set authenticated(bool valor) {
    this._authenticated = valor;
    notifyListeners();
  }

  Profiles get profile => this._profile;

  set profile(Profiles valor) {
    this._profile = valor;

    notifyListeners();
  }

  bool get bottomVisible => this._bottomVisible;

  set bottomVisible(bool valor) {
    this._bottomVisible = valor;
    notifyListeners();
  }

  void logout() {
    prefs.setToken = '';
    signOut();
  }

  Future<bool> login(String email, String password) async {
    this.authenticated = true;

    final data = {'email': email, 'password': password};

    final urlFinal = ('${Environment.apiUrl}/api/profile/login');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticated = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;

      prefs.setToken = loginResponse.token;

      prefs.setCredentialEmail = email;

      return true;
    } else {
      return false;
    }
  }

  Future siginWithGoogleBack(token) async {
    final urlFinal = ('${Environment.apiUrl}/api/google/sign-in');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;

      prefs.setToken = loginResponse.token;

      return true;
    } else {
      return false;
    }
  }

  Future signInWitchGoogle() async {
    try {
      print('her');
      final account = await _googleSignIn.signIn();

      final googleKey = await account.authentication;

      final authBack = await siginWithGoogleBack(googleKey.idToken);

      return authBack;
    } catch (e) {
      print('error signin google');
      print(e);
    }
  }

  Future siginWithApple(String code, String email, String firstName,
      bool useBundleId, String state) async {
    final urlFinal = ('${Environment.apiUrl}/api/apple/sign_in_with_apple');

    final data = {
      'code': code,
      'email': email,
      'firstName': firstName,
      'useBundleId': useBundleId,
      if (state != null) 'state': state
    };
    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;

      prefs.setToken = loginResponse.token;

      return true;
    } else {
      return false;
    }
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }

  Future register(String username, String email, String password) async {
    final data = {'username': username, 'email': email, 'password': password};

    final urlFinal = ('${Environment.apiUrl}/api/login/new');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticated = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.profile = loginResponse.profile;

      prefs.setToken = loginResponse.token;
      prefs.setCredentialEmail = email;

      print(prefs.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editProfile(String uid, String username, String about, String name,
      String email, String password) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/profile/edit');

    final data = {
      'uid': uid,
      'username': username,
      'name': name,
      'about': about,
      'email': email,
      'password': password,
    };

    final token = prefs.token;

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.profile = loginResponse.profile;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editImageRecipe(String imageRecipe, String uid) async {
    final urlFinal = ('${Environment.apiUrl}/api/profile/image_recipe/edit');

    final data = {
      'uid': uid,
      'imageRecipe': imageRecipe,
    };

    final token = prefs.token;

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final profileResponse = profileResponseFromJson(resp.body);

      this.profile.imageRecipe = profileResponse.profile.imageRecipe;

      return profileResponse;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    var urlFinal = ('${Environment.apiUrl}/api/login/renew');

    final token = prefs.token;
    print('hellor' + token);

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.profile = loginResponse.profile;
      // this.profile = loginResponse.profile;
      prefs.setToken = loginResponse.token;
      // await getProfileByUserId(this.user.uid);
      // this.logout();a
      this.authenticated = false;

      return true;
    } else {
      logout();
      return false;
    }
  }
}
