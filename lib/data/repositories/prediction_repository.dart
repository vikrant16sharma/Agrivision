import '../models/prediction_model.dart';
import '../services/api_service.dart';

class PredictionRepository {
  final ApiService apiService;

  PredictionRepository({required this.apiService});

  /// 🌾 Submit yield prediction request
  Future<PredictionModel> submitYieldPrediction({
    required String cropType,
    String? variety,
    double? fieldSize,
    DateTime? plantingDate,
    required double historicalYield,
    required double soilPH,
    required double rainfall,
    required double temperature,
    required int diseaseIncidents,
    Fertilizer? fertilizer,
  }) async {
    return await apiService.submitYieldPrediction(
      cropType: cropType,
      variety: variety,
      fieldSize: fieldSize,
      plantingDate: plantingDate,
      historicalYield: historicalYield,
      soilPH: soilPH,
      rainfall: rainfall,
      temperature: temperature,
      fertilizer: fertilizer,
      diseaseIncidents: diseaseIncidents,
    );
  }

  /// 📄 Get all yield predictions
  Future<List<PredictionModel>> getPredictions() async {
    return await apiService.getPredictions();
  }
}
