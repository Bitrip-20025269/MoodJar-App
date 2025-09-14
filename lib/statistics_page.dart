import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Sample data - in a real app, this would come from your mood storage
  final List<MoodData> moodStats = [
    MoodData(
      emoji: '😊',
      label: 'Happy',
      description: 'Positive vibes',
      percentage: 35,
      color: Colors.yellow.shade400,
      count: 42,
    ),
    MoodData(
      emoji: '😢',
      label: 'Sad',
      description: 'Down moments',
      percentage: 25,
      color: Colors.blue.shade400,
      count: 30,
    ),
    MoodData(
      emoji: '😠',
      label: 'Angry',
      description: 'Frustrated times',
      percentage: 20,
      color: Colors.red.shade400,
      count: 24,
    ),
    MoodData(
      emoji: '😌',
      label: 'Calm',
      description: 'Peaceful state',
      percentage: 20,
      color: Colors.green.shade400,
      count: 24,
    ),
  ];

  int totalEntries = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAB8CE6), // Light purple from image top
              Color(0xFF9C7CE3), // Medium light purple 
              Color(0xFF8B6CE0), // Medium purple
              Color(0xFF7A5CDD), // Medium dark purple
              Color(0xFF6A4CDA), // Dark purple from image bottom
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive breakpoints
              bool isMobile = constraints.maxWidth < 600;
              bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
              
              double cardWidth;
              double horizontalPadding;
              
              if (isMobile) {
                cardWidth = constraints.maxWidth * 0.9;
                horizontalPadding = 16.0;
              } else if (isTablet) {
                cardWidth = 500;
                horizontalPadding = 32.0;
              } else {
                cardWidth = 450;
                horizontalPadding = 48.0;
              }
              
              return Column(
                children: [
                  // Back button
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 16.0,
                        ),
                        child: Container(
                          width: cardWidth,
                          padding: EdgeInsets.all(isMobile ? 32.0 : 40.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title
                              _buildTitle(),
                              SizedBox(height: isMobile ? 32 : 40),
                              
                              // Pie Chart
                              _buildPieChart(),
                              SizedBox(height: isMobile ? 32 : 40),
                              
                              // Mood Statistics List
                              _buildMoodStatsList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Your Mood Stats',
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: _getPieChartSections(),
              centerSpaceRadius: 60,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            ),
          ),
          // Center text
          Center(
            child: Text(
              totalEntries.toString(),
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return moodStats.map((mood) {
      return PieChartSectionData(
        color: mood.color,
        value: mood.percentage.toDouble(),
        title: '',
        radius: 30,
        badgeWidget: null,
      );
    }).toList();
  }

  Widget _buildMoodStatsList() {
    return Column(
      children: moodStats.map((mood) => _buildMoodStatItem(mood)).toList(),
    );
  }

  Widget _buildMoodStatItem(MoodData mood) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Emoji and color indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: mood.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: mood.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                mood.emoji,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: 16),
          
          // Mood info and progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mood.label,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      '${mood.percentage}%',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  mood.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 8),
                // Progress bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: mood.percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: mood.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoodData {
  final String emoji;
  final String label;
  final String description;
  final int percentage;
  final Color color;
  final int count;

  MoodData({
    required this.emoji,
    required this.label,
    required this.description,
    required this.percentage,
    required this.color,
    required this.count,
  });
}
