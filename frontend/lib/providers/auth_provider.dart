import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

import '../services/auth_service.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService =
      AuthService();

  UserModel? user;

  bool isLoading = false;

  bool get isLoggedIn =>
      user != null;

  Future<bool> login({
    required String email,
    required String password,
  }) async {

    try {

      isLoading = true;
      notifyListeners();

      final response =
          await _authService.login(
        email: email,
        password: password,
      );

      final token =
          response.data['access_token'];

      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.setString(
        'token',
        token,
      );

      ApiService.dio.options.headers[
          'Authorization'] =
          'Bearer $token';

      await getCurrentUser();

      return true;

    } catch (e) {

      return false;

    } finally {

      isLoading = false;
      notifyListeners();

    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {

    try {

      await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      return true;

    } catch (e) {

      return false;

    }
  }

  Future<void> getCurrentUser() async {

    final response =
        await _authService.me();

    user = UserModel.fromJson(
      response.data,
    );

    notifyListeners();
  }

  Future<void> logout() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove('token');

    user = null;

    notifyListeners();
  }

  Future<void> autoLogin() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final token =
        prefs.getString('token');

    if (token == null) {
      return;
    }

    ApiService.dio.options.headers[
        'Authorization'] =
        'Bearer $token';

    try {

      await getCurrentUser();

    } catch (_) {

      await logout();

    }
  }
}