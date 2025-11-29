import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../../data/models/prediction_model.dart';
import '../../../presentation/prediction_provider.dart';

class YieldPredictionScreen extends StatefulWidget {
  const YieldPredictionScreen({super.key});

  @override
  State<YieldPredictionScreen> createState() => _YieldPredictionScreenState();
}

class _YieldPredictionScreenState extends State<YieldPredictionScreen> {
  final cropController = TextEditingController();
  final fieldSizeController = TextEditingController();
  final soilPHController = TextEditingController();
  final rainfallController = TextEditingController();
  final tempController = TextEditingController();
  final diseaseController = TextEditingController();
  final prevYieldController = TextEditingController();

  PredictionModel? result;

  @override
  void dispose() {
    cropController.dispose();
    fieldSizeController.dispose();
    soilPHController.dispose();
    rainfallController.dispose();
    tempController.dispose();
    diseaseController.dispose();
    prevYieldController.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (cropController.text.isEmpty ||
        fieldSizeController.text.isEmpty ||
        soilPHController.text.isEmpty ||
        rainfallController.text.isEmpty ||
        tempController.text.isEmpty ||
        diseaseController.text.isEmpty ||
        prevYieldController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    final provider = Provider.of<PredictionProvider>(context, listen: false);

    final prediction = await provider.submitPrediction(
      cropType: cropController.text.trim(),
      fieldSize: double.tryParse(fieldSizeController.text.trim()),
      soilPH: double.parse(soilPHController.text.trim()),
      rainfall: double.parse(rainfallController.text.trim()),
      temperature: double.parse(tempController.text.trim()),
      diseaseIncidents: int.parse(diseaseController.text.trim()),
      historicalYield: double.parse(prevYieldController.text.trim()),
      plantingDate: DateTime.now(),
    );

    if (prediction != null) {
      setState(() => result = prediction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PredictionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text("Yield Prediction"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Enter Field Data",
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.black)),
          const SizedBox(height: 16),

          _input("Crop Type", cropController, Icons.agriculture),
          _input("Field Size (ha)", fieldSizeController, Icons.landscape,
              inputType: TextInputType.number),
          _input("Soil pH", soilPHController, Icons.science,
              inputType: TextInputType.number),
          _input("Rainfall (mm)", rainfallController, Icons.water_drop,
              inputType: TextInputType.number),
          _input("Temperature (°C)", tempController,
              Icons.thermostat_auto_rounded,
              inputType: TextInputType.number),
          _input("Disease Incidents", diseaseController, Icons.bug_report,
              inputType: TextInputType.number),
          _input("Historical Yield (kg/ha)", prevYieldController,
              Icons.history_edu,
              inputType: TextInputType.number),

          const SizedBox(height: 20),

          PrimaryButton(
            text: 'Predict Yield',
            onPressed: provider.isLoading ? null : _predict,
            isLoading: provider.isLoading,
          ),

          if (provider.error != null) ...[
            const SizedBox(height: 20),
            Text("⚠ Error: ${provider.error!}",
                style: const TextStyle(color: Colors.red)),
          ],

          if (result != null) _buildResultCard(result!)
        ]),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl, IconData icon,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.backgroundWhite,
        ),
      ),
    );
  }

  Widget _buildResultCard(PredictionModel p) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🌱 Predicted Yield",
                  style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 8),
              Text("${p.predictedYield.toStringAsFixed(0)} kg/ha",
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              Text(
                  "📉 Range: ${p.uncertaintyBand.lower.toStringAsFixed(0)} - ${p.uncertaintyBand.upper.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 14)),
              const Divider(),
              const Text("Major Yield Drivers",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...p.drivers.map((d) => Row(
                children: [
                  Icon(
                    d.isPositive
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: d.isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text("${d.factor}: ${d.impact}"),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
