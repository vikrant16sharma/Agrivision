class ScanModel {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String? imageData;
  final String? fieldId;
  final String cropType;
  final String? location;
  final String disease;
  final double confidence;
  final double severity;
  final String category;
  final RecommendationsModel recommendations;

  ScanModel({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.imageData,
    this.fieldId,
    required this.cropType,
    this.location,
    required this.disease,
    required this.confidence,
    required this.severity,
    required this.category,
    required this.recommendations,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    return ScanModel(
      id: json['id'],
      userId: json['userId'],
      timestamp: DateTime.parse(json['timestamp']),
      imageData: json['imageData'],
      fieldId: json['fieldId'],
      cropType: json['cropType'],
      location: json['location'],
      disease: json['disease'],
      confidence: (json['confidence'] as num).toDouble(),
      severity: (json['severity'] as num).toDouble(),
      category: json['category'],
      recommendations: RecommendationsModel.fromJson(json['recommendations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'imageData': imageData,
      'fieldId': fieldId,
      'cropType': cropType,
      'location': location,
      'disease': disease,
      'confidence': confidence,
      'severity': severity,
      'category': category,
      'recommendations': recommendations.toJson(),
    };
  }

  String get urgencyColor {
    switch (recommendations.urgency) {
      case 'HIGH':
        return '#EF4444';
      case 'MEDIUM':
        return '#F59E0B';
      case 'LOW':
        return '#10B981';
      default:
        return '#6B7280';
    }
  }

  int get confidencePercent => (confidence * 100).round();
  int get severityPercent => (severity * 100).round();
}

class RecommendationsModel {
  final List<String> immediate;
  final List<String> chemical;
  final List<String> organic;
  final List<String> preventive;
  final String urgency;

  RecommendationsModel({
    required this.immediate,
    required this.chemical,
    required this.organic,
    required this.preventive,
    required this.urgency,
  });

  factory RecommendationsModel.fromJson(Map<String, dynamic> json) {
    return RecommendationsModel(
      immediate: List<String>.from(json['immediate']),
      chemical: List<String>.from(json['chemical']),
      organic: List<String>.from(json['organic']),
      preventive: List<String>.from(json['preventive']),
      urgency: json['urgency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'immediate': immediate,
      'chemical': chemical,
      'organic': organic,
      'preventive': preventive,
      'urgency': urgency,
    };
  }
}