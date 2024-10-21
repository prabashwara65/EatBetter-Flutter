import 'package:eat_better/authFile/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserPreferencePage extends StatefulWidget {
  UserPreferencePage({Key? key}) : super(key: key);

  final User? user = Auth().CurrentUser;

  @override
  State<UserPreferencePage> createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Define the list of preferences
  final List<String> preferences = [   //Chicken, Beef, Pork, Fish, Tofu, Eggs, Plant-Based
    "Italian",
    "Chinese",
    "Indian",
    "Mexican",
    "Japanese",
    "Thai",
    "Mediterranean",
    "Vegetarian",
    "Gluten-Free",
    "Halal",
    "Kosher",
    "Nut-Free",
    "Chicken",
    "Beef",
    "Pork",
    "Eggs",
    "Plant-Based",
    "Curry",
  ];

  // Track selected preferences
  final Set<String> _selectedPreferences = {};
  bool _preferencesLoaded = false;
  bool _isNewUser = false;

  @override
  void initState() {
    super.initState();
    _fetchUserPreferences();
  }

  Future<void> _fetchUserPreferences() async {
    String trimmedEmail = (widget.user?.email ?? "User email").split('@').first;

    DocumentSnapshot doc = await _firestore.collection('users').doc(trimmedEmail).get();
    if (doc.exists) {
      setState(() {
        _selectedPreferences.addAll(List<String>.from(doc['preferences'] ?? []));
        _preferencesLoaded = true; // Preferences loaded
      });
    } else {
      setState(() {
        _isNewUser = true; // User is new, no preferences
        _preferencesLoaded = true; // Preferences loaded (none)
      });
    }
  }

  Future<void> _updateUserPreferences() async {
    String trimmedEmail = (widget.user?.email ?? "User email").split('@').first;

    await _firestore.collection('users').doc(trimmedEmail).set({
      'userId': trimmedEmail, // Use trimmed email as user ID
      'preferences': _selectedPreferences.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    String trimmedEmail = (widget.user?.email ?? "User email").split('@').first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Preferences'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                trimmedEmail,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _preferencesLoaded
              ? _buildPreferenceContent()
              : const CircularProgressIndicator(), // Show loading indicator while fetching
        ),
      ),
    );
  }

  Widget _buildPreferenceContent() {
    if (_isNewUser) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text('Select your preferences below:'),
          // const SizedBox(height: 20),
          Expanded(child: _buildPreferenceButtons()),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
   
          const Text('Choose your preferences:'),
          //const SizedBox(height: 20),
          Expanded(child: _buildPreferenceButtons()),
        ],
      );
    }
  }

  Widget _buildPreferenceButtons() {
    return SingleChildScrollView(
      child: Container(
        width: 500, // Set the desired width
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            crossAxisSpacing: 5, // Space between columns
            mainAxisSpacing: 5, // Space between rows
          ),
          itemCount: preferences.length,
          shrinkWrap: true, // Ensure the grid takes only needed height
          physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
          itemBuilder: (context, index) {
            return _buildPreferenceButton(preferences[index], false);
          },
        ),
      ),
    );
  }

  Widget _buildPreferenceButton(String preference, bool isCurrent) {
    bool isSelected = _selectedPreferences.contains(preference);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            _selectedPreferences.remove(preference);
          } else {
            _selectedPreferences.add(preference);
          }
          // Update preferences in Firestore
          _updateUserPreferences();
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.deepPurple,
        backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Adjust button size here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(
          color: isSelected ? Colors.white : Colors.deepPurpleAccent,
          width: 2,
        ),
        shadowColor: Colors.deepPurpleAccent,
        elevation: 8,
      ),
      child: Text(
        preference,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.deepPurple,
        ),
      ),
    );
  }
}
