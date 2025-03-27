import 'package:chipi/providers/userprovider.dart';
import 'package:chipi/services/assets_manager.dart'; // ייבוא של מחלקת ניהול התמונות
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final UserDataStorage userDataStorage = UserDataStorage();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitData(BuildContext context) async {
    final String name = _nameController.text.trim();
    final int? age = int.tryParse(_ageController.text.trim());

    if (name.isNotEmpty && age != null) {
      await userDataStorage.saveUserName(name); // שמירת שם
      await userDataStorage.saveUserAge(age); // שמירת גיל
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('אנא מלא את כל השדות')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // תמונת רקע עם שכבה כהה לשיפור הקריאות
            Image.asset(
              AssetsManager.secondBg, // תמונת רקע מתוך ניהול התמונות
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withOpacity(0.3), // שכבה כהה מעל התמונה
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // טקסט הנחיה לילדים
                    const Text(
                      'ברוכים הבאים! אנא הזן את שמך וגילך כדי להתחיל.',
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
                    SizedBox(height: 30),
                    // שדה הזנת שם
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'מה שמך?',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // שדה הזנת גיל
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'מה גילך?',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    // כפתור המשך
                    ElevatedButton(
                      onPressed: () => _submitData(context),
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
      ),
    );
  }
}
