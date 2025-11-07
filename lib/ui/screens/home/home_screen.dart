import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/cards/gradient_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActions(context),

                      const SizedBox(height: 24),

                      // Tip Card
                      _buildTipCard(),

                      const SizedBox(height: 24),

                      // Stats
                      _buildStats(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GradientCard(
      gradient: AppColors.primaryGradient,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good day,',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'John Farmer',
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.eco,
                size: 48,
                color: Colors.white70,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Weather Card
          GlassmorphicCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Weather",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '28°C',
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Partly cloudy, good for spraying',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.camera_alt,
        title: 'Disease Scan',
        subtitle: 'Capture plant photo',
        color: AppColors.primary,
        onTap: () {
          // Navigate to scan screen
        },
      ),
      _QuickAction(
        icon: Icons.trending_up,
        title: 'Yield Prediction',
        subtitle: 'Forecast harvest',
        color: AppColors.accent,
        onTap: () {
          // Navigate to yield screen
        },
      ),
      _QuickAction(
        icon: Icons.history,
        title: 'Scan History',
        subtitle: 'View past detections',
        color: const Color(0xFF8B5CF6), // purple
        onTap: () {
          // Navigate to history screen
        },
      ),
      _QuickAction(
        icon: Icons.analytics,
        title: 'Admin Panel',
        subtitle: 'View system data',
        color: AppColors.warning,
        onTap: () {
          // Navigate to admin screen
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionCard(action);
      },
    );
  }

  Widget _buildActionCard(_QuickAction action) {
    return ElevatedCard(
      onTap: action.onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: action.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              action.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            action.title,
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 4),
          Text(
            action.subtitle,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // amber-50
        border: Border.all(
          color: const Color(0xFFFDE68A), // amber-200
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Tip",
                  style: AppTextStyles.labelLarge.copyWith(
                    color: const Color(0xFF92400E), // amber-900
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scout your fields regularly for early disease detection. Early intervention can save up to 30% of potential yield loss.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF78350F), // amber-800
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: '12',
            label: 'Total Scans',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: '3',
            label: 'Predictions',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: '94%',
            label: 'Accuracy',
            color: const Color(0xFF8B5CF6), // purple
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
