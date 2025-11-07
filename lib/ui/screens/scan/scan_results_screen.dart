import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/gradient_card.dart';

class ScanResultsScreen extends StatelessWidget {
  const ScanResultsScreen({super.key});

  // Mock data - replace with actual scan data
  final String disease = 'Early Blight';
  final double confidence = 0.87;
  final double severity = 0.65;
  final String category = 'fungal';
  final String urgency = 'HIGH';

  @override
  Widget build(BuildContext context) {
    final int confidencePercent = (confidence * 100).round();
    final int severityPercent = (severity * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Results'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Disease Detection Card
                  _buildDiseaseCard(confidencePercent, severityPercent),

                  const SizedBox(height: 16),

                  // Immediate Actions
                  _buildSectionCard(
                    title: '🚨 Immediate Actions',
                    items: [
                      'Remove and destroy infected leaves',
                      'Improve air circulation',
                      'Reduce leaf wetness',
                    ],
                    color: AppColors.urgencyHigh,
                  ),

                  const SizedBox(height: 16),

                  // Chemical Treatment
                  _buildSectionCard(
                    title: '🧪 Chemical Treatment',
                    items: [
                      'Apply copper-based fungicide',
                      'Use chlorothalonil spray',
                    ],
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: 16),

                  // Organic Alternatives
                  _buildSectionCard(
                    title: '🌿 Organic Alternatives',
                    items: [
                      'Use neem oil spray',
                      'Apply sulfur dust',
                    ],
                    color: AppColors.success,
                  ),

                  const SizedBox(height: 16),

                  // Preventive Measures
                  _buildSectionCard(
                    title: '🛡️ Prevention for Future',
                    items: [
                      'Practice crop rotation',
                      'Use disease-resistant varieties',
                    ],
                    color: AppColors.accent,
                  ),

                  const SizedBox(height: 16),

                  // Learn More Card
                  _buildLearnMoreCard(),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'New Scan',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SecondaryButton(
                          text: 'Home',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(int confidencePercent, int severityPercent) {
    Color urgencyColor = urgency == 'HIGH'
        ? AppColors.urgencyHigh
        : urgency == 'MEDIUM'
        ? AppColors.urgencyMedium
        : AppColors.urgencyLow;

    Color urgencyBgColor = urgency == 'HIGH'
        ? const Color(0xFFFEE2E2) // red-100
        : urgency == 'MEDIUM'
        ? const Color(0xFFFEF3C7) // amber-100
        : const Color(0xFFDCFCE7); // green-100

    return ElevatedCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2), // red-100
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.eco,
                  color: AppColors.urgencyHigh,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(disease, style: AppTextStyles.h3),
                    const SizedBox(height: 4),
                    Text(
                      '$category disease',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Confidence and Severity Bars
          _buildMetricBar(
            label: 'Confidence',
            value: confidencePercent,
            color: AppColors.accent,
          ),

          const SizedBox(height: 16),

          _buildMetricBar(
            label: 'Severity',
            value: severityPercent,
            color: severityPercent > 60
                ? AppColors.urgencyHigh
                : severityPercent > 40
                ? AppColors.urgencyMedium
                : AppColors.success,
          ),

          const SizedBox(height: 20),

          // Urgency Badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: urgencyBgColor,
              border: Border.all(
                color: urgencyColor.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  urgency == 'HIGH'
                      ? Icons.warning
                      : urgency == 'MEDIUM'
                      ? Icons.access_time
                      : Icons.check_circle,
                  color: urgencyColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Urgency: $urgency',
                  style: AppTextStyles.h4.copyWith(color: urgencyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$value%',
              style: AppTextStyles.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.backgroundGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return ElevatedCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h4),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLearnMoreCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFAF5FF), // purple-50
            Color(0xFFFDF2F8), // pink-50
          ],
        ),
        border: Border.all(
          color: const Color(0xFFE9D5FF), // purple-200
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📚 Learn More', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            'Get detailed information about $disease and treatment methods.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              // Open web browser
            },
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Search for resources'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: const Color(0xFF7C3AED), // violet-600
            ),
          ),
        ],
      ),
    );
  }
}
