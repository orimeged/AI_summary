import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users'); // Firestore collection
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);

    try {
      // בדיקת אם המשתמש כבר קיים
      final userDoc = await _usersCollection.doc(_nameController.text).get();
      if (userDoc.exists) {
        _showError("משתמש כבר קיים!");
      } else {
        // יצירת משתמש חדש
        await _usersCollection.doc(_nameController.text).set({
          'username': _nameController.text,
          'password': _passwordController.text,
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      print("שגיאה בהרשמה: $e");
      _showError("שגיאה בהרשמה.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הרשמה'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'שם משתמש',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'סיסמה',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('הרשמה'),
            ),
          ],
        ),
      ),
    );
  }
}
