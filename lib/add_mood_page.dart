import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({super.key});

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  String? selectedMood;
  final TextEditingController _thoughtsController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Happy', 'color': Colors.yellow.shade400},
    {'emoji': '😢', 'label': 'Sad', 'color': Colors.blue.shade400},
    {'emoji': '😠', 'label': 'Angry', 'color': Colors.red.shade400},
    {'emoji': '😌', 'label': 'Calm', 'color': Colors.green.shade400},
  ];

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              _buildTitle(),
                              SizedBox(height: isMobile ? 32 : 40),
                              
                              // Mood Selection
                              _buildMoodSelection(),
                              SizedBox(height: isMobile ? 32 : 40),
                              
                              // Thoughts Text Area
                              _buildThoughtsSection(),
                              SizedBox(height: isMobile ? 40 : 50),
                              
                              // Add to Mood Jar Button
                              _buildAddToMoodJarButton(),
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
      'How are you\nfeeling today?',
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6366F1),
        height: 1.2,
      ),
    );
  }

  Widget _buildMoodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator line
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: selectedMood != null ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                flex: selectedMood != null ? 0 : 1,
                child: Container(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Mood options
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moods.map((mood) => _buildMoodOption(
            mood['emoji'],
            mood['label'],
            mood['color'],
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodOption(String emoji, String label, Color color) {
    bool isSelected = selectedMood == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = label;
        });
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? color : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThoughtsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share your thoughts (optional)',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _thoughtsController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Color(0xFF374151),
            ),
            decoration: InputDecoration(
              hintText: "What's on your mind today?\nHow are you feeling?",
              hintStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: Color(0xFF9CA3AF),
                height: 1.5,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToMoodJarButton() {
    bool canSubmit = selectedMood != null;
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: canSubmit 
          ? LinearGradient(
              colors: [
                Color(0xFFDDD6FE), // Light purple
                Color(0xFFC4B5FD), // Medium light purple
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
          : null,
        color: canSubmit ? null : Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: canSubmit ? _handleAddToMoodJar : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: canSubmit ? Color(0xFF374151) : Color(0xFF9CA3AF),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 20,
              color: canSubmit ? Color(0xFF374151) : Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 8),
            Text(
              'Add to Mood Jar',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddToMoodJar() {
    if (selectedMood == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Mood Added!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your mood has been saved to your mood jar.',
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 8),
            Text(
              'Mood: $selectedMood',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_thoughtsController.text.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Thoughts: ${_thoughtsController.text}',
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to dashboard
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF6366F1),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
