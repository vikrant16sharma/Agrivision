class ApiConstants {
  // Endpoints
  static const String signupEndpoint = '/signup';
  static const String diseaseScanEndpoint = '/disease-scan';
  static const String yieldPredictionEndpoint = '/yield-prediction';
  static const String scansEndpoint = '/scans';
  static const String predictionsEndpoint = '/predictions';
  static const String adminScansEndpoint = '/admin/scans';
  static const String fertilizerRecommendationEndpoint = '/fertilizer-recommendation';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Image Processing
  static const int maxImageWidth = 1024;
  static const int imageQuality = 85;
  static const int mlModelInputSize = 224;
}