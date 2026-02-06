import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/course_model.dart';
import '../models/unit_model.dart';

class CourseRemoteDatasource {
  final ApiClient apiClient;
  const CourseRemoteDatasource(this.apiClient);

  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.courses);
      return (response.data['data'] as List).map((c) => CourseModel.fromJson(c)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to get courses', statusCode: e.response?.statusCode);
    }
  }

  Future<CourseModel> getCourseById(String id) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.courseById(id));
      return CourseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to get course', statusCode: e.response?.statusCode);
    }
  }

  Future<List<UnitModel>> getCourseUnits(String courseId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.courseUnits(courseId));
      return (response.data['data'] as List).map((u) => UnitModel.fromJson(u)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to get units', statusCode: e.response?.statusCode);
    }
  }
}
