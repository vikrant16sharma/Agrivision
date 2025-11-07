import 'package:flutter/foundation.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../data/models/prediction_model.dart';

class PredictionProvider extends ChangeNotifier {
  final PredictionRepository predictionRepository;

  PredictionProvider({required this.predictionRepository});

  List<PredictionModel> _predictions = [];
  PredictionModel? _currentPrediction;
  bool _isLoading = false;
  String? _error;

  List<PredictionModel> get predictions => _predictions;
  PredictionModel? get currentPrediction => _currentPrediction;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Submit a new yield prediction
  Future<PredictionModel?> submitPrediction({
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prediction = await predictionRepository.submitPrediction(
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

      _currentPrediction = prediction;
      _predictions.insert(0, prediction); // Add to beginning of list
      _isLoading = false;
      notifyListeners();
      return prediction;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Load all predictions for the current user
  Future<void> loadPredictions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _predictions = await predictionRepository.getPredictions();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set current prediction (for viewing details)
  void setCurrentPrediction(PredictionModel prediction) {
    _currentPrediction = prediction;
    notifyListeners();
  }

  /// Clear current prediction
  void clearCurrentPrediction() {
    _currentPrediction = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get prediction statistics
  Map<String, dynamic> get statistics {
    if (_predictions.isEmpty) {
      return {
        'totalPredictions': 0,
        'averageYield': 0.0,
        'latestPrediction': null,
      };
    }

    final avgYield = _predictions
        .map((p) => p.predictedYield)
        .reduce((a, b) => a + b) / _predictions.length;

    return {
      'totalPredictions': _predictions.length,
      'averageYield': avgYield,
      'latestPrediction': _predictions.first,
    };
  }
}