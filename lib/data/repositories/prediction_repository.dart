import '../models/prediction_model.dart';
import '../services/api_service.dart';

class PredictionRepository {
  final ApiService apiService;

  PredictionRepository({required this.apiService});

  /// Submit a yield prediction
  Future<PredictionModel> submitPrediction({
    required String cropType,
    String? variety,
    double? fieldSize,
    DateTime? plantingDate,
    required double historicalYield,
    required double soilPH,
    required double rainfall,
    required double temperature,
    Fertilizer? fertilizer,
    required int diseaseIncidents,
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

  /// Get all predictions for the current user
  Future<List<PredictionModel>> getPredictions() async {
    return await apiService.getPredictions();
  }

  /// Get a specific prediction by ID (from cached list)
  Future<PredictionModel?> getPredictionById(String predictionId) async {
    final predictions = await getPredictions();
    try {
      return predictions.firstWhere((pred) => pred.id == predictionId);
    } catch (e) {
      return null;
    }
  }
}