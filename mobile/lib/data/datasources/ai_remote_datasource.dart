import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/speech_result_model.dart';
import '../models/writing_result_model.dart';
import '../models/quiz_model.dart';

class AiRemoteDatasource {
  final ApiClient apiClient;
  const AiRemoteDatasource(this.apiClient);

  Future<SpeechResultModel> analyzeSpeech(String audioPath, String targetText) async {
    try {
      final formData = FormData.fromMap({'audio': await MultipartFile.fromFile(audioPath), 'target_text': targetText});
      final response = await apiClient.aiDio.post(ApiConstants.analyzeSpeech, data: formData);
      return SpeechResultModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['detail'] ?? 'Speech analysis failed', statusCode: e.response?.statusCode);
    }
  }

  Future<WritingResultModel> correctWriting(String text, {String? context}) async {
    try {
      final response = await apiClient.aiDio.post(ApiConstants.correctWriting, data: {'text': text, if (context != null) 'context': context});
      return WritingResultModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['detail'] ?? 'Writing correction failed', statusCode: e.response?.statusCode);
    }
  }

  Future<QuizResultModel> generateQuiz(String topic, {String type = 'mcq', int count = 5, String difficulty = 'intermediate'}) async {
    try {
      final response = await apiClient.aiDio.post(ApiConstants.generateQuiz, data: {'topic': topic, 'type': type, 'count': count, 'difficulty': difficulty});
      return QuizResultModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data?['detail'] ?? 'Quiz generation failed', statusCode: e.response?.statusCode);
    }
  }
}
