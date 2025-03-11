import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to the Home Page!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
