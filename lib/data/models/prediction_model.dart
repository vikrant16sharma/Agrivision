class PredictionModel {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String cropType;
  final String? variety;
  final double? fieldSize;
  final DateTime? plantingDate;
  final PredictionInputs inputs;
  final double predictedYield;
  final UncertaintyBand uncertaintyBand;
  final List<YieldDriver> drivers;

  PredictionModel({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.cropType,
    this.variety,
    this.fieldSize,
    this.plantingDate,
    required this.inputs,
    required this.predictedYield,
    required this.uncertaintyBand,
    required this.drivers,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'],
      userId: json['userId'],
      timestamp: DateTime.parse(json['timestamp']),
      cropType: json['cropType'],
      variety: json['variety'],
      fieldSize: json['fieldSize']?.toDouble(),
      plantingDate: json['plantingDate'] != null
          ? DateTime.parse(json['plantingDate'])
          : null,
      inputs: PredictionInputs.fromJson(json['inputs']),
      predictedYield: (json['predictedYield'] as num).toDouble(),
      uncertaintyBand: UncertaintyBand.fromJson(json['uncertaintyBand']),
      drivers: (json['drivers'] as List)
          .map((d) => YieldDriver.fromJson(d))
          .toList(),
    );
  }

  String get formattedYield =>
      '${predictedYield.toStringAsFixed(0)} kg/ha';
}

class PredictionInputs {
  final double soilPH;
  final double rainfall;
  final double temperature;
  final Fertilizer? fertilizer;
  final int diseaseIncidents;
  final double historicalYield;

  PredictionInputs({
    required this.soilPH,
    required this.rainfall,
    required this.temperature,
    this.fertilizer,
    required this.diseaseIncidents,
    required this.historicalYield,
  });

  factory PredictionInputs.fromJson(Map<String, dynamic> json) {
    return PredictionInputs(
      soilPH: (json['soilPH'] as num).toDouble(),
      rainfall: (json['rainfall'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      fertilizer: json['fertilizer'] != null
          ? Fertilizer.fromJson(json['fertilizer'])
          : null,
      diseaseIncidents: json['diseaseIncidents'],
      historicalYield: (json['historicalYield'] as num).toDouble(),
    );
  }
}

class Fertilizer {
  final double nitrogen;
  final double phosphorus;
  final double potassium;

  Fertilizer({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
  });

  factory Fertilizer.fromJson(Map<String, dynamic> json) {
    return Fertilizer(
      nitrogen: (json['nitrogen'] as num).toDouble(),
      phosphorus: (json['phosphorus'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
    };
  }
}

class UncertaintyBand {
  final double lower;
  final double upper;

  UncertaintyBand({required this.lower, required this.upper});

  factory UncertaintyBand.fromJson(Map<String, dynamic> json) {
    return UncertaintyBand(
      lower: (json['lower'] as num).toDouble(),
      upper: (json['upper'] as num).toDouble(),
    );
  }
}

class YieldDriver {
  final String factor;
  final String impact;

  YieldDriver({required this.factor, required this.impact});

  factory YieldDriver.fromJson(Map<String, dynamic> json) {
    return YieldDriver(
      factor: json['factor'],
      impact: json['impact'],
    );
  }

  bool get isPositive => impact.startsWith('+');
  bool get isNegative => impact.startsWith('-');
}