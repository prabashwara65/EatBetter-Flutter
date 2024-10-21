import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide the system UI elemnts
    _checkConnectivity(); // Check connectivity when splash screen is initialized
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // Show the system UI elements
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet connection
      _showNoInternetDialog();
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/widget_tree');
      });
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text(
              "Please check your internet connection. You can either try again or exit."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _checkConnectivity(); // Retry connection check
              },
              child: Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(); // Exit the app
              },
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo in the middle of the page
            Expanded(
              child: Center(
                child: Image.asset('assets/images/logo.png',
                    width: 200), // Display the logo
              ),
            ),
            // Dot loading animation at the bottom
            const Padding(
              padding: EdgeInsets.only(
                  bottom: 50.0), // Optional padding for bottom spacing
              child: const SpinKitFadingCircle(
                color: Colors.orange,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
