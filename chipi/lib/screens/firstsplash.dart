import 'package:chipi/providers/userprovider.dart';
import 'package:chipi/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstSplashScreen extends StatefulWidget {
  @override
  _FirstSplashScreenState createState() => _FirstSplashScreenState();
}

class _FirstSplashScreenState extends State<FirstSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with overlay for better contrast
          Image.asset(AssetsManager.firstBg, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 0),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Chatbot description text
                  const Text(
                    'ברוכים הבאים לצ\'אטבוט ידידותי לילדים! כאן תוכלו לשאול שאלות וללמוד דברים חדשים בצורה כיפית ובטוחה.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/splash'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'המשך',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
