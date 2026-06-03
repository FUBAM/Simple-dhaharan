import 'package:dio/dio.dart';

import 'api_service.dart';

class AuthService {
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await ApiService.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await ApiService.dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  // Future<Response> me() async {
  //   return await ApiService.dio.get('/auth/me');
  // }

  Future<Response> me() async {
    return await ApiService.dio.get('/users/profile');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await ApiService.dio.put('/users/profile', data: data);
  }

  Future<Response> updateAccount(Map<String, dynamic> data) async {
    return await ApiService.dio.put('/users/account', data: data);
  }
}
