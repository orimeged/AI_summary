import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // לוודא אתחול תקין של ה-Widgets
  await Firebase.initializeApp(); 
  Gemini.init(apiKey: "AIzaSyC4wMrwsH_C1ayQSH63CzBfvfgKOCy7bAE");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Heebo',
      ),
      home: LoginScreen(),
    );
  }
}
