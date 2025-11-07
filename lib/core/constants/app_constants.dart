class AppConstants {
  // App Info
  static const String appName = 'AgriVision';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-Powered Agricultural Assistant';

  // Crop Types
  static const List<String> cropTypes = [
    'Tomato',
    'Corn',
    'Wheat',
    'Rice',
    'Potato',
    'Cotton',
    'Soybean',
  ];

  // Disease Categories
  static const List<String> diseaseCategories = [
    'Fungal',
    'Bacterial',
    'Viral',
    'Nutritional',
  ];

  // Urgency Levels
  static const String urgencyHigh = 'HIGH';
  static const String urgencyMedium = 'MEDIUM';
  static const String urgencyLow = 'LOW';

  // Local Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';

  // Default Values
  static const double defaultSoilPH = 6.5;
  static const double defaultRainfall = 700.0;
  static const double defaultTemperature = 25.0;
  static const double defaultHistoricalYield = 3000.0;
  static const int defaultDiseaseIncidents = 0;
}