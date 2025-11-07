import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/scan_model.dart';
import '../models/prediction_model.dart';

class ApiService {
  final String baseUrl;
  final SupabaseClient supabase;

  ApiService({
    required this.baseUrl,
    required this.supabase,
  });

  Future<Map<String, String>> _getHeaders() async {
    final session = supabase.auth.currentSession;
    final token = session?.accessToken ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Disease Scan
  Future<ScanModel> submitDiseaseScan({
    required String imageData,
    required String cropType,
    String? fieldId,
    String? location,
  }) async {
    final url = Uri.parse('$baseUrl/disease-scan');
    final headers = await _getHeaders();

    final body = json.encode({
      'imageData': imageData,
      'cropType': cropType,
      'fieldId': fieldId,
      'location': location,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ScanModel.fromJson(data['scan']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Failed to scan image');
    }
  }

  // Yield Prediction
  Future<PredictionModel> submitYieldPrediction({
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
    final url = Uri.parse('$baseUrl/yield-prediction');
    final headers = await _getHeaders();

    final body = json.encode({
      'cropType': cropType,
      'variety': variety,
      'fieldSize': fieldSize,
      'plantingDate': plantingDate?.toIso8601String(),
      'historicalYield': historicalYield,
      'soilPH': soilPH,
      'rainfall': rainfall,
      'temperature': temperature,
      'fertilizer': fertilizer?.toJson(),
      'diseaseIncidents': diseaseIncidents,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PredictionModel.fromJson(data['prediction']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Failed to predict yield');
    }
  }

  // Get Scans
  Future<List<ScanModel>> getScans() async {
    final url = Uri.parse('$baseUrl/scans');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final scans = (data['scans'] as List)
          .map((scan) => ScanModel.fromJson(scan))
          .toList();
      return scans;
    } else {
      throw Exception('Failed to load scans');
    }
  }

  // Get Predictions
  Future<List<PredictionModel>> getPredictions() async {
    final url = Uri.parse('$baseUrl/predictions');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = (data['predictions'] as List)
          .map((pred) => PredictionModel.fromJson(pred))
          .toList();
      return predictions;
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  // Get Admin Scans (All scans across all users)
  Future<List<ScanModel>> getAdminScans() async {
    final url = Uri.parse('$baseUrl/admin/scans');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final scans = (data['scans'] as List)
          .map((scan) => ScanModel.fromJson(scan))
          .toList();
      return scans;
    } else {
      throw Exception('Failed to load admin scans');
    }
  }
}