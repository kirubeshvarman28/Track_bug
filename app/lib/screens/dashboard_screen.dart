import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTrendSection(),
          const SizedBox(height: 30),
          _buildStatisticSection(),
        ],
      ),
    );
  }

  Widget _buildTrendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trend',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              '29 Oct - 11 Nov',
              style: TextStyle(color: Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildTab('High', true),
            const SizedBox(width: 10),
            _buildTab('Medium', false),
            const SizedBox(width: 10),
            _buildTab('Low', false),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(2.6, 2),
                    FlSpot(4.9, 5),
                    FlSpot(6.8, 2.5),
                    FlSpot(8, 4),
                    FlSpot(9.5, 3),
                    FlSpot(11, 4),
                  ],
                  isCurved: true,
                  color: const Color(0xFFC6FF00),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFC6FF00).withOpacity(0.1),
                  ),
                ),
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1),
                    FlSpot(2, 3),
                    FlSpot(4, 2),
                    FlSpot(6, 4),
                    FlSpot(8, 2),
                    FlSpot(10, 3),
                  ],
                  isCurved: true,
                  color: Colors.purpleAccent,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Risk vulnerabilities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarGroup(0, 8),
                _buildBarGroup(1, 12),
                _buildBarGroup(2, 6),
                _buildBarGroup(3, 10),
                _buildBarGroup(4, 5),
                _buildBarGroup(5, 9),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistic',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(child: _buildTab('Results', true)),
              Expanded(child: _buildTab('Assets Scanned', false)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildStatItem('Total Assets', '57,985.07', '0.14%', true),
        const SizedBox(height: 10),
        _buildStatItem('Vulnerable Assets', '28,374.12', '0.91%', false),
        const SizedBox(height: 30),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFFC6FF00),
                        value: 60,
                        radius: 20,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.purpleAccent.withOpacity(0.3),
                        value: 40,
                        radius: 20,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flash_on, size: 40, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(const Color(0xFFC6FF00), 'High'),
            const SizedBox(width: 20),
            _buildLegend(Colors.white38, 'Low'),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFC6FF00) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x % 2 == 0 ? Colors.purpleAccent.withOpacity(0.5) : const Color(0xFFC6FF00),
          width: 15,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, String percent, bool positive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: positive ? const Color(0xFFC6FF00).withOpacity(0.1) : Colors.purpleAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: positive ? const Color(0xFFC6FF00) : Colors.purpleAccent, width: 0.5),
              ),
              child: Text(
                percent,
                style: TextStyle(
                  color: positive ? const Color(0xFFC6FF00) : Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white38)),
      ],
    );
  }
}
