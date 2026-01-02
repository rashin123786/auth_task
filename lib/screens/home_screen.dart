import 'package:auth_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("HomeScreen"),
              Consumer<AuthProvider>(
                builder: (context, value, child) => ElevatedButton(
                  onPressed: () async {
                    final result = await value.signOut();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result)));

                    if (result == 'Logout Successful') {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: Text("Sign Out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
