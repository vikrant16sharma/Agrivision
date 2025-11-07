import '../models/scan_model.dart';
import '../services/api_service.dart';

class ScanRepository {
  final ApiService apiService;

  ScanRepository({required this.apiService});

  /// Submit a disease scan
  Future<ScanModel> submitScan({
    required String imageData,
    required String cropType,
    String? fieldId,
    String? location,
  }) async {
    return await apiService.submitDiseaseScan(
      imageData: imageData,
      cropType: cropType,
      fieldId: fieldId,
      location: location,
    );
  }

  /// Get all scans for the current user
  Future<List<ScanModel>> getScans() async {
    return await apiService.getScans();
  }

  /// Get a specific scan by ID (from cached list)
  Future<ScanModel?> getScanById(String scanId) async {
    final scans = await getScans();
    try {
      return scans.firstWhere((scan) => scan.id == scanId);
    } catch (e) {
      return null;
    }
  }
}