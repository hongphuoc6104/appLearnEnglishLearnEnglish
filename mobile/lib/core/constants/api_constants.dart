class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String aiBaseUrl = 'http://10.0.2.2:8000';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  static const String courses = '/courses';
  static String courseById(String id) {
    return "/courses/$id";
  }
  static String courseUnits(String id) {
    return "/courses/$id/units";
  }
  static String lessonById(String id) {
    return "/lessons/$id";
  }
  static String lessonChallenges(String id) {
    return "/lessons/$id/challenges";
  }
  static const String submitAnswer = '/progress/submit-answer';
  static String courseProgress(String courseId) {
    return "/progress/course/$courseId";
  }
  static const String refillHearts = '/progress/refill-hearts';
  static const String leaderboard = '/leaderboard';
  static const String analyzeSpeech = '/analyze-speech';
  static const String correctWriting = '/correct-writing';
  static const String generateQuiz = '/generate-quiz';
}
