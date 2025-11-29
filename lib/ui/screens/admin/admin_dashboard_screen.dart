import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ Top Stats ------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _AnalyticsCard(
                  title: "Total Scans",
                  value: "124",
                  percent: "+12%",
                  icon: Icons.qr_code_scanner_rounded,
                ),
                _AnalyticsCard(
                  title: "Users",
                  value: "47",
                  percent: "+5%",
                  icon: Icons.person_rounded,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _AnalyticsCard(
                  title: "Active Farms",
                  value: "32",
                  percent: "+3%",
                  icon: Icons.agriculture_rounded,
                ),
                _AnalyticsCard(
                  title: "Alerts",
                  value: "6",
                  percent: "-8%",
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ------------------ Graph ------------------
            const Text(
              "Requests Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: _cardDecoration(),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[value.toInt() % 7],
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: const [
                        FlSpot(0, 20),
                        FlSpot(1, 40),
                        FlSpot(2, 35),
                        FlSpot(3, 50),
                        FlSpot(4, 45),
                        FlSpot(5, 60),
                        FlSpot(6, 55),
                      ],
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ------------------ System Overview ------------------
            const Text(
              "System Status",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                children: const [
                  _OverviewRow(label: "Model Accuracy", value: "92.4%"),
                  _OverviewRow(label: "Server Status", value: "Online"),
                  _OverviewRow(label: "Requests / Hour", value: "134"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ------------------ Activity Log ------------------
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            _activityItem(
              icon: Icons.bug_report,
              color: Colors.redAccent,
              title: "Wheat disease scan processed",
              timestamp: "Today, 4:12 PM",
            ),
            _activityItem(
              icon: Icons.person_add,
              color: Colors.blue,
              title: "New user registered",
              timestamp: "Today, 2:50 PM",
            ),
            _activityItem(
              icon: Icons.landscape_rounded,
              color: Colors.green,
              title: "Farm added to database",
              timestamp: "Yesterday, 6:45 PM",
            ),
            _activityItem(
              icon: Icons.analytics_rounded,
              color: Colors.deepPurple,
              title: "Model training completed",
              timestamp: "Yesterday, 3:12 PM",
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ Activity Tile ------------------
  Widget _activityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String timestamp,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 3),
                Text(
                  timestamp,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// =========================================================
//                  SUB WIDGETS
// =========================================================

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final IconData icon;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.percent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 24,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 22),
              const Spacer(),
              Text(
                percent,
                style: const TextStyle(color: Colors.green, fontSize: 13),
              )
            ],
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          Text(value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}

// =========================================================
//                  COMMON CARD DECORATION
// =========================================================

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 8,
        offset: const Offset(0, 3),
      )
    ],
  );
}
