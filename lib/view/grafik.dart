import 'package:e_commerce/model/user_model.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:e_commerce/controller/BottomNavBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GrafikScreen extends StatelessWidget {
  final User user;
  const GrafikScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userProvider.getChartData(user.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final transactions = snapshot.data ?? [];
          final transactionCount = transactions.length;
          final totalItems = transactions.fold<int>(0, (sum, item) {
            final quantity = item['quantity'];
            return sum + (quantity is int ? quantity : 1);
          });
          final totalAmount = transactions.fold<double>(0, (sum, item) {
            final amount = item['amount'];
            return sum + (amount is num ? amount.toDouble() : 0);
          });

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.green.shade200,
                        child: const Image(
                          image: AssetImage('assets/hulk.jpg'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Halo ${user.username}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grafik Aktivitas Belanja',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lihat bagaimana pola belanjamu selama beberapa bulan terakhir.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY:
                            transactions.isNotEmpty
                                ? transactions.length.toDouble() * 1.2
                                : 10,
                        minY: 0,
                        barGroups: _generateBarGroups(transactions),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  'Sun',
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                ];
                                return Text(days[value.toInt() % 7]);
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval:
                                  transactions.length > 0
                                      ? (transactions.length / 5).ceilToDouble()
                                      : 1,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildLegend(Colors.red, 'Hari ini'),
                      const SizedBox(width: 12),
                      _buildLegend(Colors.grey.shade300, 'Hari sebelumnya'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah transaksi  : $transactionCount transaksi'),
                      Text('Total item dibeli : $totalItems item'),
                      Text(
                        'Nilai pembelian    : Rp ${totalAmount.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Bottomnavbar(user: user),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  List<BarChartGroupData> _generateBarGroups(
    List<Map<String, dynamic>> transactions,
  ) {
    final dailyCounts = List<int>.filled(7, 0);

    for (final transaction in transactions) {
      final day = transaction['day'] ?? 0;
      dailyCounts[day % 7]++;
    }

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dailyCounts[index].toDouble(),
            color: Color(0xFFDA6C6C),
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
