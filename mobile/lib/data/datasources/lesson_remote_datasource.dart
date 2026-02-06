import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/challenge_model.dart';
import '../models/progress_model.dart';

class LessonRemoteDatasource {
  final ApiClient apiClient;
  const LessonRemoteDatasource(this.apiClient);

  Future<List<ChallengeModel>> getLessonChallenges(String lessonId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.lessonChallenges(lessonId));
      return (response.data['data'] as List).map((c) => ChallengeModel.fromJson(c)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to get challenges', statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> submitAnswer(String challengeId, String answer) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.submitAnswer, data: {'challengeId': challengeId, 'answer': answer});
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to submit answer', statusCode: e.response?.statusCode);
    }
  }

  Future<ProgressModel> getCourseProgress(String courseId) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.courseProgress(courseId));
      return ProgressModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to get progress', statusCode: e.response?.statusCode);
    }
  }

  Future<Map<String, dynamic>> refillHearts() async {
    try {
      final response = await apiClient.dio.post(ApiConstants.refillHearts);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['error'] ?? 'Failed to refill hearts', statusCode: e.response?.statusCode);
    }
  }
}
