import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text(
          'DASHBOARD',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 15,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Sales Report Section
            Text(
              'GENERAL SALES REPORT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Total Sale', '166', Icons.shopping_cart, Colors.orange),
                _buildStatCard('New Sale', '102', Icons.card_giftcard, Colors.pink),
                _buildStatCard('Products', '1061', Icons.computer, Colors.cyan),
              ],
            ),
            SizedBox(height: 24),

            // Sales Report Graph
            Text(
              'SALES REPORT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Income - March2020',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\$1.65K - 2.5K',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '\$${value.toInt()}K',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Text('Jan', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 2:
                                    return Text('Feb', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 4:
                                    return Text('Mar', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 6:
                                    return Text('Apr', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 8:
                                    return Text('May', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 10:
                                    return Text('Jun', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 12:
                                    return Text('Jul', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 14:
                                    return Text('Aug', style: TextStyle(fontSize: 12, color: Colors.grey));
                                  case 16:
                                    return Text('Sep', style: TextStyle(fontSize: 12, color: Colors.grey));
                                }
                                return Text('');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 16,
                        minY: 0,
                        maxY: 3,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 1.5),
                              FlSpot(2, 1.8),
                              FlSpot(4, 1.2),
                              FlSpot(6, 2.0),
                              FlSpot(8, 1.5),
                              FlSpot(10, 2.5),
                              FlSpot(12, 2.0),
                              FlSpot(14, 2.3),
                              FlSpot(16, 1.8),
                            ],
                            isCurved: true,
                            color: Colors.cyan,
                            barWidth: 2,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.cyan.withOpacity(0.1),
                            ),
                            dotData: FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 1.0),
                              FlSpot(2, 1.5),
                              FlSpot(4, 1.0),
                              FlSpot(6, 1.8),
                              FlSpot(8, 1.2),
                              FlSpot(10, 2.0),
                              FlSpot(12, 1.5),
                              FlSpot(14, 1.8),
                              FlSpot(16, 1.3),
                            ],
                            isCurved: true,
                            color: Colors.pink,
                            barWidth: 2,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.pink.withOpacity(0.1),
                            ),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Daily Report Section
            Text(
              'DAILY REPORT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDailyReportCard('Product Sale', Colors.cyan, [
                  FlSpot(0, 1.0),
                  FlSpot(1, 1.5),
                  FlSpot(2, 1.2),
                  FlSpot(3, 1.8),
                  FlSpot(4, 1.3),
                ]),
                _buildDailyReportCard('New Seller', Colors.pink, [
                  FlSpot(0, 1.2),
                  FlSpot(1, 1.8),
                  FlSpot(2, 1.5),
                  FlSpot(3, 2.0),
                  FlSpot(4, 1.7),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReportCard(String title, Color color, List<FlSpot> spots) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$1500 - June05',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Container(
            height: 80,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: 0,
                maxY: 2.5,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(Colors.grey[300]!),
              _buildDot(Colors.grey[500]!),
              _buildDot(Colors.grey[700]!),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}