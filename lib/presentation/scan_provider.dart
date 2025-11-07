import 'package:flutter/foundation.dart';
import '../../data/repositories/scan_repository.dart';
import '../../data/models/scan_model.dart';

class ScanProvider extends ChangeNotifier {
  final ScanRepository scanRepository;

  ScanProvider({required this.scanRepository});

  List<ScanModel> _scans = [];
  ScanModel? _currentScan;
  bool _isLoading = false;
  String? _error;

  List<ScanModel> get scans => _scans;
  ScanModel? get currentScan => _currentScan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Submit a new disease scan
  Future<ScanModel?> submitScan({
    required String imageData,
    required String cropType,
    String? fieldId,
    String? location,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final scan = await scanRepository.submitScan(
        imageData: imageData,
        cropType: cropType,
        fieldId: fieldId,
        location: location,
      );

      _currentScan = scan;
      _scans.insert(0, scan); // Add to beginning of list
      _isLoading = false;
      notifyListeners();
      return scan;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Load all scans for the current user
  Future<void> loadScans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _scans = await scanRepository.getScans();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set current scan (for viewing details)
  void setCurrentScan(ScanModel scan) {
    _currentScan = scan;
    notifyListeners();
  }

  /// Clear current scan
  void clearCurrentScan() {
    _currentScan = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get scan statistics
  Map<String, dynamic> get statistics {
    if (_scans.isEmpty) {
      return {
        'totalScans': 0,
        'averageConfidence': 0.0,
        'highUrgencyCount': 0,
      };
    }

    final avgConfidence = _scans
        .map((s) => s.confidence)
        .reduce((a, b) => a + b) / _scans.length;

    final highUrgencyCount = _scans
        .where((s) => s.recommendations.urgency == 'HIGH')
        .length;

    return {
      'totalScans': _scans.length,
      'averageConfidence': avgConfidence,
      'highUrgencyCount': highUrgencyCount,
    };
  }
}