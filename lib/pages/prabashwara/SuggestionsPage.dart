import 'package:eat_better/pages/prabashwara/Gemini_suggest.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class SuggestionsPage extends StatefulWidget {
  final String extractedText; // Receive extracted text from NextPage

  const SuggestionsPage({super.key, required this.extractedText});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> _userPreferences = []; // User preferences
  List<String> _matchedPreferences = []; // To store matched preferences for the pie chart
  List<Map<String, int>> _linesWithMultiplePreferences = []; // Store lines with their preference counts

  @override
  void initState() {
    super.initState();
    print("Received Extracted Text: ${widget.extractedText}"); // Debugging: print the received text
    _fetchUserPreferencesAndCompare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions Based on Preferences'),
      ),
      body: _buildSuggestionsView(),
      bottomNavigationBar: _buildSendButton()
    );
  }

  Widget _buildSuggestionsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row for Pie Chart and Legend
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Card for Pie Chart
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'User Preferences Distribution',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200, // Set the height for the pie chart
                        child: _buildPieChart(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Second card for color explanation (legend)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legend:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Text('All Preferences'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      Text('Matched Preferences'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Row for two flexed-width cards
          Expanded(
            child: Row(
              children: [
                // Second Card for Matched Preferences
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Matched Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Scrollable content with a flexed height
                          Expanded(
                            child: SingleChildScrollView(
                              child: _matchedPreferences.isNotEmpty
                                  ? Text(
                                      _matchedPreferences.join(' '),
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : const Text('No Preferences Matched'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Third Card for Best Suggestions
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find our best suggestions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Scrollable content with a flexed height
                          Expanded(
                            child: SingleChildScrollView(
                              child: _linesWithMultiplePreferences.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: _buildHighlightedLines(),
                                    )
                                  : const Text('No preferences founded.'),
                            ),
                          ),
                        ],
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

  List<Widget> _buildHighlightedLines() {
    List<Widget> lineWidgets = [];
    int maxCount = _linesWithMultiplePreferences.map((e) => e.values.first).reduce((a, b) => a > b ? a : b);

    // Find the first line with the highest count for highlighting
    for (int i = 0; i < _linesWithMultiplePreferences.length; i++) {
      var lineData = _linesWithMultiplePreferences[i];
      String line = lineData.keys.first;
      int count = lineData.values.first;

      // Highlight the line if it has the highest count or if it is the first line
      bool isHighlighted = (count == maxCount) && (i == 0) || (i == 0 && lineWidgets.isEmpty);

      lineWidgets.add(
        Text(
          line,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? Colors.red : Colors.black, // Change color for highlighted line
          ),
        ),
      );
    }

    return lineWidgets;
  }

  Widget _buildPieChart() {
    final data = _preparePieChartData();

    return PieChart(
      PieChartData(
        sections: data,
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            if (event is FlTapDownEvent && pieTouchResponse != null && pieTouchResponse is! PointerExitEvent) {
              final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(data[index].title),
                  content: Text('Count: ${data[index].value.toInt()}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
    
  }

  List<PieChartSectionData> _preparePieChartData() {
    List<PieChartSectionData> sections = [];
    Map<String, int> preferencesCount = {};
    print("Matched Preferences: ${_linesWithMultiplePreferences.join(', ')}"); // Debugging: print user preferences


    // Count the occurrences of each preference
    for (String preference in _userPreferences) {
      preferencesCount[preference] = preferencesCount.containsKey(preference) ? preferencesCount[preference]! + 1 : 1;
    }

    // Create pie chart sections
    preferencesCount.forEach((preference, count) {
      final isMatched = _matchedPreferences.contains(preference);
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: '',
        color: isMatched ? Colors.green : Colors.blue,
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    });

    return sections;
  }

  Future<void> _fetchUserPreferencesAndCompare() async {
    // Fetch user preferences from Firestore
    String trimmedEmail = (user?.email ?? "User email").split('@').first;
    DocumentSnapshot doc = await _firestore.collection('users').doc(trimmedEmail).get();
    _userPreferences = List<String>.from(doc['preferences'] ?? []).map((pref) => pref.toUpperCase()).toList(); // Convert preferences to upper case
    
    // Extract lines from the received text
    List<String> extractedLines = widget.extractedText.split('\n');

    // Check each line for keyword matches and collect matched preferences
    for (String line in extractedLines) {
      // Remove lines with special characters
      if (_isLineValid(line)) {
        // Check if the line matches user preferences
        if (_doesLineMatchUserPreferences(line)) {
          _matchedPreferences.add(line);
        }
      }
    }

    setState(() {
      _linesWithMultiplePreferences.sort((a, b) => b.values.first.compareTo(a.values.first)); // Sort by count descending
    });
  }

  bool _isLineValid(String line) {
    // Check if a line contains special characters or unwanted patterns
    RegExp specialCharPattern = RegExp(r'[^\w\s]'); // Pattern for non-word, non-space characters
    return !specialCharPattern.hasMatch(line);
  }

  Widget _buildSendButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _onSendButtonPressed,
        child: const Text('Send Preferences to Gemini Suggest'),
      ),
    );
  }

  void _onSendButtonPressed() {
    // Navigate to GeminiSuggest with the matched preferences
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeminiSuggest(matchedPreferences: _matchedPreferences, LinesWithMultiplePreferences: _linesWithMultiplePreferences, userPreferences: [],),
      ),
    );
  }

  bool _doesLineMatchUserPreferences(String line) {
    int matchCount = 0;

    // Compare each word in the line with the user's preferences
    List<String> wordsInLine = line.toUpperCase().split(' ');
    for (String preference in _userPreferences) {
      if (wordsInLine.contains(preference)) {
        matchCount++;
      }
    }

    if (matchCount >= 2) {
      // Add the line to _linesWithMultiplePreferences if it has at least 2 preference matches
      _linesWithMultiplePreferences.add({line: matchCount});
    }

    return matchCount > 0; // Consider a line matched if at least one preference is found
  }
}
