import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedPeriod = "This Week";
  bool isDropdownOpen = false;
  String? hoveredTooltip;
  String? hoveredImagePath;
  Offset? tooltipPosition;

  final List<Map<String, dynamic>> stats = [
    {"day": "16", "minutes": 110.0, "kcal": 66.0},
    {"day": "17", "minutes": 105.0, "kcal": 70.0},
    {"day": "18", "minutes": 100.0, "kcal": 60.0},
    {"day": "19", "minutes": 120.0, "kcal": 75.0},
    {"day": "20", "minutes": 90.0, "kcal": 50.0},
    {"day": "21", "minutes": 110.0, "kcal": 65.0},
    {"day": "22", "minutes": 100.0, "kcal": 60.0},
  ];

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: responsiveHelper.h(12)),
              Center(
                child: Text(
                  'Report',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: responsiveHelper.sp(24),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: responsiveHelper.h(30)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
                padding: EdgeInsets.all(responsiveHelper.w(4)),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        responsiveHelper: responsiveHelper,
                        icon: 'assets/images/cal.png',
                        value: '0',
                        unit: 'Kcal',
                      ),
                    ),
                    SizedBox(width: responsiveHelper.w(12)),
                    Expanded(
                      child: _buildSummaryCard(
                        responsiveHelper: responsiveHelper,
                        icon: 'assets/images/time.png',
                        value: '0',
                        unit: 'Minute',
                      ),
                    ),
                    SizedBox(width: responsiveHelper.w(12)),
                    Expanded(
                      child: _buildSummaryCard(
                        responsiveHelper: responsiveHelper,
                        icon: 'assets/images/dumbbell.png',
                        value: '0',
                        unit: 'Workout',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveHelper.h(30)),
              _buildStatisticsCard(responsiveHelper),
              SizedBox(height: responsiveHelper.h(30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required ResponsiveHelper responsiveHelper,
    required String icon,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: EdgeInsets.all(responsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Image.asset(
            icon,
            width: responsiveHelper.w(32),
            height: responsiveHelper.h(32),
          ),
          SizedBox(height: responsiveHelper.h(12)),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: responsiveHelper.sp(24),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsiveHelper.h(8)),
          Text(
            unit,
            style: TextStyle(
              color: const Color(0xFF848484),
              fontSize: responsiveHelper.sp(14),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(ResponsiveHelper responsiveHelper) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsiveHelper.w(16)),
      padding: EdgeInsets.all(responsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFF6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: responsiveHelper.h(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Statistics",
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: responsiveHelper.sp(18),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDropdownOpen = !isDropdownOpen;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsiveHelper.w(12),
                          vertical: responsiveHelper.h(8),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: const Color(0xFFF6FFF6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedPeriod,
                              style: TextStyle(
                                color: const Color(0xFF1E1E1E),
                                fontSize: responsiveHelper.sp(14),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: responsiveHelper.w(8)),
                            Icon(
                              isDropdownOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: const Color(0xFF1E1E1E),
                              size: responsiveHelper.sp(20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveHelper.h(12)),
              Divider(
                color: Colors.grey.withValues(alpha: 0.2),
                height: 1,
                thickness: 2,
              ),
              SizedBox(
                height: responsiveHelper.h(200),
                child: Stack(
                  children: [
                    BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 140,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: 15.r,
                        getTooltipColor: (group) {
                          return Colors.white;
                        },
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final item = stats[groupIndex];
                          String label;
                          
                          if (rodIndex == 0) {
                            // Minutes bar
                            label = "🔥 ${item["minutes"]} Min";
                          } else {
                            // Kcal bar
                            label = "⚡ ${item["kcal"]} Kcal";
                          }
                          
                          return BarTooltipItem(
                            label,
                            TextStyle(
                              color: Colors.black,
                              fontSize: responsiveHelper.sp(12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: EdgeInsets.only(top: responsiveHelper.h(4)),
                              child: Text(
                                stats[value.toInt()]["day"].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsiveHelper.sp(12),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(stats.length, (index) {
                      final item = stats[index];
                      return BarChartGroupData(
                        x: index,
                        barsSpace: 5,
                        barRods: [
                          BarChartRodData(
                            toY: item["minutes"],
                            color: const Color(0xFF28A228),
                            width: responsiveHelper.w(8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                          BarChartRodData(
                            toY: item["kcal"],
                            color: const Color(0xFFCB574D),
                            width: responsiveHelper.w(8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                        ],
                      );
                    }),
                    gridData: const FlGridData(show: false),
                  ),
                ),
                if (hoveredTooltip != null && tooltipPosition != null)
                  Positioned(
                    left: tooltipPosition!.dx,
                    top: tooltipPosition!.dy,
                    child: _buildCustomTooltip(
                      hoveredTooltip!,
                      hoveredImagePath!,
                      responsiveHelper,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: responsiveHelper.h(24)),
          Divider(
            color: Colors.grey.withValues(alpha: 0.2),
            height: 1,
            thickness: 2,
          ),
          SizedBox(height: responsiveHelper.h(24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(
                responsiveHelper: responsiveHelper,
                color: const Color(0xFF28A228),
                text: "Minutes",
              ),
              SizedBox(width: responsiveHelper.w(80)),
              _buildLegend(
                responsiveHelper: responsiveHelper,
                color: const Color(0xFFCB574D),
                text: "Kcal",
              ),
            ],
          ),
          if (isDropdownOpen)
            Positioned(
              top: responsiveHelper.h(50),
              right: responsiveHelper.w(0),
              child: Container(
                width: responsiveHelper.w(160),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownItem("Today", responsiveHelper),
                    _buildDropdownItem("This Week", responsiveHelper),
                    _buildDropdownItem("Last week", responsiveHelper),
                    _buildDropdownItem("Last Month", responsiveHelper),
                    _buildDropdownItem("Last 6 months", responsiveHelper),
                  ],
                ),
              ),
            ),
                      ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(String text, ResponsiveHelper responsiveHelper) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPeriod = text;
          isDropdownOpen = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: responsiveHelper.w(12),
          vertical: responsiveHelper.h(10),
        ),
        decoration: BoxDecoration(
          color: selectedPeriod == text
              ? const Color(0xFFF6FFF6)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: responsiveHelper.sp(14),
            color: Colors.black,
            fontWeight: selectedPeriod == text
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend({
    required ResponsiveHelper responsiveHelper,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: responsiveHelper.w(14),
          height: responsiveHelper.h(14),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: responsiveHelper.w(6)),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF848484),
            fontSize: responsiveHelper.sp(14),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  Widget _buildCustomTooltip(String label, String imagePath, ResponsiveHelper responsiveHelper) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveHelper.w(12),
        vertical: responsiveHelper.h(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: responsiveHelper.w(16),
            height: responsiveHelper.h(16),
          ),
          SizedBox(width: responsiveHelper.w(6)),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: responsiveHelper.sp(12),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveHelper {
  final BuildContext context;
  ResponsiveHelper(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  double w(double value) => ScreenUtil().setWidth(value);
  double h(double value) => ScreenUtil().setHeight(value);
  double sp(double value) => ScreenUtil().setSp(value);
}