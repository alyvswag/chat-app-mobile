import 'package:chatapp_project/service/shared_preferences_service.dart';
import 'package:chatapp_project/views/app_view.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _submit() async {
    await SharedPreferencesService()
        .submit(_firstNameController.text, _lastNameController.text);
    _pushAppView(); // Burada push əmri icra edirik
  }

  void _pushAppView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AppView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Giriş',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade300,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Adınız',
                    labelStyle: TextStyle(
                      color: Colors.purple.shade300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Soyadınız',
                    labelStyle: TextStyle(
                      color: Colors.purple.shade300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.purple[100], // Normal vəziyyətdəki rəng
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4, // Button hündürlüyü (istəyə görə)
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.pressed)) {
                          return Colors
                              .purple[400]; // Hover və ya basılı olduğu rəng
                        }
                        return null; // Əks halda orijinal rəng qalır
                      },
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
