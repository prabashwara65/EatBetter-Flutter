import 'package:eat_better/navigation_menu.dart';
import 'package:eat_better/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eat_better/pages/prabashwara/SuggestionsPage.dart'; // Adjust the path as necessary

class NextPage extends StatelessWidget {
  final String extractedText;

  const NextPage({Key? key, required this.extractedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Process the extracted text to filter out menu items
    final List<String> menuItems = _processExtractedText(extractedText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Text'),
        backgroundColor: const Color(0xFFF86A2E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 600,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (menuItems.isEmpty)
                        const Center(child: Text('No menu items found')),
                      ...menuItems.map((item) => _buildMenuCard(item)).toList(),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to SuggestionsPage, passing the extracted text
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuggestionsPage(extractedText: extractedText),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Give Suggest',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Second button action (to be defined)
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NavigationMenu()), // Wrap HomePage in a MaterialPageRoute
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      ' Home ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _processExtractedText(String text) {
    final lines = text.split('\n');

    return lines
        .where((line) =>
            line.isNotEmpty &&
            RegExp(r'[a-zA-Z]').hasMatch(line))
        .map((line) => line.replaceAll(RegExp(r'[^a-zA-Z\s]'), ''))
        .where((line) => line.split(' ').any((word) => word.length > 1))
        .toList();
  }

  Widget _buildMenuCard(String item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
