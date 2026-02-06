import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final ApiClient apiClient;
  const AuthRemoteDatasource(this.apiClient);

  Future<({UserModel user, String token})> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.login, data: {'email': email, 'password': password});
      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      await apiClient.saveToken(data['token']);
      return (user: user, token: data['token'] as String);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Login failed', statusCode: e.response?.statusCode);
    }
  }

  Future<({UserModel user, String token})> register(String email, String password, String displayName) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.register, data: {'email': email, 'password': password, 'displayName': displayName});
      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      await apiClient.saveToken(data['token']);
      return (user: user, token: data['token'] as String);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Registration failed', statusCode: e.response?.statusCode);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.profile);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to get profile', statusCode: e.response?.statusCode);
    }
  }

  Future<void> logout() async => apiClient.deleteToken();
}
